// Copyright (c) .NET Foundation. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using Harmony.Core.EF.Extensions.Internal;
using Harmony.Core.FileIO.Queryable;
using JetBrains.Annotations;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Internal;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Query;
using Microsoft.EntityFrameworkCore.Query.ExpressionVisitors;
using Microsoft.EntityFrameworkCore.Query.ExpressionVisitors.Internal;
using Microsoft.EntityFrameworkCore.Query.Internal;
using Microsoft.EntityFrameworkCore.Storage;
using Remotion.Linq;
using Remotion.Linq.Clauses;
using Remotion.Linq.Clauses.Expressions;
using Remotion.Linq.Clauses.ResultOperators;

namespace Harmony.Core.EF.Query.Internal
{
    /// <summary>
    ///     This API supports the Entity Framework Core infrastructure and is not intended to be used
    ///     directly from your code. This API may change or be removed in future releases.
    /// </summary>
    public class HarmonyQueryModelVisitor : EntityQueryModelVisitor
    {
        /// <summary>
        ///     This API supports the Entity Framework Core infrastructure and is not intended to be used
        ///     directly from your code. This API may change or be removed in future releases.
        /// </summary>
        public HarmonyQueryModelVisitor(
            EntityQueryModelVisitorDependencies dependencies,
            QueryCompilationContext queryCompilationContext)
            : base(dependencies, queryCompilationContext)
        {
            _projectionExpressionVisitorFactory = dependencies.ProjectionExpressionVisitorFactory;
        }
        private readonly IProjectionExpressionVisitorFactory _projectionExpressionVisitorFactory;

        private Expression ProcessWeirdJoin(Expression inner, Expression outer, QueryModel queryModel)
        {

            //var joiningType = QueryCompilationContext.Model.FindEntityType(outerQuery.ItemType);
            //var mainEntityType = QueryCompilationContext.Model.FindEntityType(innerQuery.ItemType);
            //var targetProperty = joiningType.FindProperty(propName);
            //var maybeForeignKeys = joiningType.FindForeignKeys(targetProperty);
            //var targetKey = maybeForeignKeys.FirstOrDefault((key) => key.PrincipalEntityType == mainEntityType);

            //if (targetKey == null)
            //{
            //    var primaryKey = joiningType.FindKey(targetProperty);
            //    if (primaryKey == null)
            //        throw new NotImplementedException();
            //    targetKey = primaryKey.GetReferencingForeignKeys().FirstOrDefault((key) => key.DeclaringEntityType == mainEntityType);
            //    if (targetKey == null)
            //        throw new NotImplementedException();
            //}

            //return Expression.Equal(expr, Expression.Call(typeof(Microsoft.EntityFrameworkCore.EF), "Property", new Type[] { expr.Type }, new QuerySourceReferenceExpression(outerQuery), Expression.Constant(targetKey.PrincipalKey.Properties.First().Name)));
            throw new NotImplementedException();
        }

        private static bool IsPartOfLeftJoinPattern(AdditionalFromClause additionalFromClause, QueryModel queryModel)
        {
            int num = queryModel.BodyClauses.IndexOf(additionalFromClause);
            SubQueryExpression obj = ((additionalFromClause != null) ? additionalFromClause.FromExpression : null) as SubQueryExpression;
            QueryModel queryModel2 = (obj != null) ? obj.QueryModel : null;
            IQuerySource querySource = (queryModel2 != null) ? queryModel2.MainFromClause.FromExpression.TryGetReferencedQuerySource() : null;
            GroupJoinClause groupJoinClause;
            if ((groupJoinClause = (queryModel.BodyClauses.ElementAtOrDefault(num - 1) as GroupJoinClause)) != null && groupJoinClause == querySource && queryModel.CountQuerySourceReferences(groupJoinClause) == 1 && queryModel2.BodyClauses.Count == 0 && queryModel2.ResultOperators.Count == 1 && ((Collection<ResultOperatorBase>)queryModel2.ResultOperators)[0] is DefaultIfEmptyResultOperator)
            {
                return true;
            }
            return false;
        }

        private void TryOptimizeCorrelatedCollections(QueryModel queryModel)
        {
            if (!queryModel.BodyClauses.OfType<AdditionalFromClause>().Any((AdditionalFromClause c) => !IsPartOfLeftJoinPattern(c, queryModel)))
            {
                CorrelatedCollectionOptimizingVisitor correlatedCollectionOptimizingVisitor = new CorrelatedCollectionOptimizingVisitor(this, queryModel);
                Expression expression = correlatedCollectionOptimizingVisitor.Visit(queryModel.SelectClause.Selector);
                if (expression != queryModel.SelectClause.Selector)
                {
                    queryModel.SelectClause.Selector = expression;
                    if (correlatedCollectionOptimizingVisitor.ParentOrderings.Count > 0)
                    {
                        this.RemoveOrderings(queryModel);
                        OrderByClause orderByClause = new OrderByClause();
                        foreach (Ordering parentOrdering in correlatedCollectionOptimizingVisitor.ParentOrderings)
                        {
                            orderByClause.Orderings.Add(parentOrdering);
                        }
                        queryModel.BodyClauses.Add(orderByClause);
                        this.VisitOrderByClause(orderByClause, queryModel, queryModel.BodyClauses.IndexOf(orderByClause));
                    }
                }
            }
        }

        public override void VisitQueryModel(QueryModel queryModel)
        {
            MainQueryType = queryModel.MainFromClause.ItemType;
            this.TryOptimizeCorrelatedCollections(queryModel);
            this.CurrentParameter = Expression.Parameter(MainQueryType, queryModel.MainFromClause.ItemName);

            var aliasMapping = new Dictionary<IQuerySource, IQuerySource>();
            foreach (var bodyClause in queryModel.BodyClauses)
            {
                var groupJoin = bodyClause as GroupJoinClause;
                var additionalFrom = bodyClause as AdditionalFromClause;
                if (groupJoin != null && groupJoin.ItemName != groupJoin.JoinClause.ItemName)
                {
                    if (!aliasMapping.ContainsKey(groupJoin))
                        aliasMapping.Add(groupJoin, groupJoin.JoinClause);
                }

                if (additionalFrom != null)
                {
                    var flatGroupJoin = additionalFrom.TryGetFlattenedGroupJoinClause();
                    if (flatGroupJoin != null && aliasMapping.ContainsKey(flatGroupJoin))
                        aliasMapping.Add(additionalFrom, flatGroupJoin.JoinClause);
                }
            }

            Type resultTypeParameter = queryModel.ResultTypeOverride.ForceSequenceType();

            if (!(from ro in queryModel.ResultOperators
                  select ro.GetType()).Any(delegate (Type t)
                  {
                      if (!(t == typeof(GroupResultOperator)))
                      {
                          return t == typeof(AllResultOperator);
                      }
                      return true;
                  }))
            {
                
                var subQueryVisitor = new SubQueryRewriter { QueryModel = queryModel, Parent = this, QuerySourceMapping = QueryCompilationContext.QuerySourceMapping, QuerySourceAliases = aliasMapping };
                //Expression expression = selectorRewriter.Visit(queryModel.SelectClause.Selector);
                var selector = subQueryVisitor.Visit(queryModel.SelectClause.Selector);
                QueryPlan = QueryModelVisitor.PrepareQuery(queryModel, ProcessWeirdJoin, out var querySourceBuffer);
                Expression = Expression.Call(
                        HarmonyQueryModelVisitor.EntityQueryMethodInfo.MakeGenericMethod(MainQueryType),
                        EntityQueryModelVisitor.QueryContextParameter,
                        Expression.Constant(QueryPlan),
                        Expression.Constant(QueryCompilationContext.IsTrackingQuery));

                var memberAccessVisitor = new MemberAccessBindingExpressionVisitor(QueryCompilationContext.QuerySourceMapping, this, false);
                var buffers = QueryPlan.GetQueryBuffer().TypeBuffers;
                foreach (var kvp in querySourceBuffer)
                {
                    if (!QueryCompilationContext.QuerySourceMapping.ContainsMapping(kvp.Key))
                    {
                        if (!string.IsNullOrWhiteSpace(buffers[kvp.Value].ParentFieldName))
                        {
                            var propertyNode = Expression.Property(this.CurrentParameter, MainQueryType.GetProperty(buffers[kvp.Value].ParentFieldName));
                            QueryCompilationContext.QuerySourceMapping.AddMapping(kvp.Key, propertyNode);
                        }
                        else
                        {
                            QueryCompilationContext.QuerySourceMapping.AddMapping(kvp.Key, this.CurrentParameter);
                        }
                    }
                }

                foreach (var queryAlias in aliasMapping)
                {
                    if (QueryCompilationContext.QuerySourceMapping.ContainsMapping(queryAlias.Value))
                    {
                        if (!QueryCompilationContext.QuerySourceMapping.ContainsMapping(queryAlias.Key))
                        {
                            QueryCompilationContext.QuerySourceMapping.AddMapping(queryAlias.Key, QueryCompilationContext.QuerySourceMapping.GetExpression(queryAlias.Value));
                        }
                        else
                        {
                            QueryCompilationContext.QuerySourceMapping.ReplaceMapping(queryAlias.Key, QueryCompilationContext.QuerySourceMapping.GetExpression(queryAlias.Value));
                        }
                    }
                }
                var expression = memberAccessVisitor.Visit(selector);
                Expression expression2 = expression;
                TaskLiftingExpressionVisitor taskLiftingExpressionVisitor = new TaskLiftingExpressionVisitor();
                if (Expression.Type.TryGetElementType(typeof(IAsyncEnumerable<>)) != (Type)null)
                {
                    expression2 = taskLiftingExpressionVisitor.LiftTasks(expression);
                }

                Expression = ((expression2 == expression) ?
                    Expression.Call(this.LinqOperatorProvider.Select.MakeGenericMethod(this.CurrentParameter.Type, resultTypeParameter), Expression, Expression.Lambda(expression, this.CurrentParameter)) :
                    Expression.Call(EntityQueryModelVisitor.SelectAsyncMethod.MakeGenericMethod(this.CurrentParameter.Type, resultTypeParameter), Expression, Expression.Lambda(expression2, this.CurrentParameter, taskLiftingExpressionVisitor.CancellationTokenParameter)));
                
            }

            VisitResultOperators(queryModel.ResultOperators, queryModel);
        }
        protected override Func<QueryContext, TResults> CreateExecutorLambda<TResults>()
        {
            return base.CreateExecutorLambda<TResults>();
        }

        public class SubQueryRewriter : System.Linq.Expressions.ExpressionVisitor
        {
            public Dictionary<IQuerySource, IQuerySource> QuerySourceAliases;
            public QuerySourceMapping QuerySourceMapping;
            public HarmonyQueryModelVisitor Parent;
            public QueryModel QueryModel;
            private QuerySourceReferenceExpression Source;
            private string SubQueryTargetName;
            private SubQueryExpression SubQuery;
            private ReadOnlyCollection<ParameterExpression> CurrentParameters;

            protected override Expression VisitConstant(ConstantExpression node)
            {
                return node;
            }

            private QuerySourceReferenceExpression _currentIncludeSource;
            protected override Expression VisitExtension(Expression node)
            {
                return node;
            }

            protected override Expression VisitLambda<T>(Expression<T> node)
            {
                CurrentParameters = node.Parameters;
                return base.VisitLambda(node);
            }

            protected override MemberAssignment VisitMemberAssignment(MemberAssignment node)
            {
                //this is for things like SelectAllAndExpand from OData
                //we should be able to shake things into this pattern if they have a similar purpose with a subquery
                if (node.Member.Name == "Instance")
                {
                    Source = node.Expression as QuerySourceReferenceExpression;
                }
                else if (node.Member.Name == "Name")
                {
                    SubQueryTargetName = ((ConstantExpression)node.Expression).Value as string;
                }
                else if (node.Member.Name == "Value" && node.Expression is SubQueryExpression)
                {
                    SubQuery = node.Expression as SubQueryExpression;
                    var queryModel = SubQuery.QueryModel;
                    var propValue = Expression.PropertyOrField(Parent.CurrentParameter, SubQueryTargetName);
                    var resultExpressionElementType = propValue.Type.IsGenericType ? propValue.Type.GenericTypeArguments.First() : propValue.Type;
                    Expression resultExpression = (propValue.Type.GetGenericTypeDefinition() == typeof(ICollection<>)) ? 
                        Expression.Condition(Expression.Equal(propValue, Expression.Constant(null)), Expression.Convert(Expression.New(typeof(List<>).MakeGenericType(new Type[] { resultExpressionElementType })), propValue.Type), propValue) : 
                        (Expression)propValue;

                    foreach (var bodyClause in queryModel.BodyClauses)
                    {
                        var groupJoin = bodyClause as GroupJoinClause;
                        var additionalFrom = bodyClause as AdditionalFromClause;
                        if (groupJoin != null && groupJoin.ItemName != groupJoin.JoinClause.ItemName)
                        {
                            if (!QuerySourceAliases.ContainsKey(groupJoin))
                                QuerySourceAliases.Add(groupJoin, groupJoin.JoinClause);
                        }

                        if (additionalFrom != null)
                        {
                            var flatGroupJoin = additionalFrom.TryGetFlattenedGroupJoinClause();
                            if (flatGroupJoin != null && QuerySourceAliases.ContainsKey(flatGroupJoin))
                                QuerySourceAliases.Add(additionalFrom, flatGroupJoin.JoinClause);
                        }
                    }

                    Type resultTypeParameter = queryModel.ResultTypeOverride.ForceSequenceType();
                    var currentParameter = Expression.Parameter(resultExpressionElementType);
                    if(Source != null && Source.ReferencedQuerySource.ItemType == Parent.CurrentParameter.Type && !QuerySourceMapping.ContainsMapping(Source.ReferencedQuerySource))
                        QuerySourceMapping.AddMapping(Source.ReferencedQuerySource, Parent.CurrentParameter);

                    if (!QuerySourceMapping.ContainsMapping(queryModel.MainFromClause) && queryModel.MainFromClause.ItemType == currentParameter.Type)
                        QuerySourceMapping.AddMapping(queryModel.MainFromClause, currentParameter);

                    if (!(from ro in queryModel.ResultOperators
                          select ro.GetType()).Any(delegate (Type t)
                          {
                              if (!(t == typeof(GroupResultOperator)))
                              {
                                  return t == typeof(AllResultOperator);
                              }
                              return true;
                          }))
                    {

                        var subQueryVisitor = new SubQueryRewriter { QueryModel = queryModel, Parent = Parent, QuerySourceMapping = QuerySourceMapping, QuerySourceAliases = QuerySourceAliases };
                        //Expression expression = selectorRewriter.Visit(queryModel.SelectClause.Selector);
                        var selector = subQueryVisitor.Visit(queryModel.SelectClause.Selector);
                        var memberAccessVisitor = new MemberAccessBindingExpressionVisitor(QuerySourceMapping, Parent, false);
                        // querySourceMapping.AddMapping(kvp.Key, propertyNode);

                        foreach (var queryAlias in QuerySourceAliases)
                        {
                            if (QuerySourceMapping.ContainsMapping(queryAlias.Value))
                            {
                                if (!QuerySourceMapping.ContainsMapping(queryAlias.Key))
                                {
                                    QuerySourceMapping.AddMapping(queryAlias.Key, QuerySourceMapping.GetExpression(queryAlias.Value));
                                }
                                else
                                {
                                    QuerySourceMapping.ReplaceMapping(queryAlias.Key, QuerySourceMapping.GetExpression(queryAlias.Value));
                                }
                            }
                        }


                        var expression = memberAccessVisitor.Visit(selector);
                        Expression expression2 = expression;
                        TaskLiftingExpressionVisitor taskLiftingExpressionVisitor = new TaskLiftingExpressionVisitor();
                        if (resultExpression.Type.TryGetElementType(typeof(IAsyncEnumerable<>)) != (Type)null)
                        {
                            expression2 = taskLiftingExpressionVisitor.LiftTasks(expression);
                        }

                        resultExpression = ((expression2 == expression) ?
                            Expression.Call(Parent.LinqOperatorProvider.Select.MakeGenericMethod(resultExpressionElementType, resultTypeParameter), resultExpression, Expression.Lambda(expression, currentParameter)) :
                            Expression.Call(EntityQueryModelVisitor.SelectAsyncMethod.MakeGenericMethod(resultExpressionElementType, resultTypeParameter), resultExpression, Expression.Lambda(expression2, currentParameter, taskLiftingExpressionVisitor.CancellationTokenParameter)));
                    }

                    return node.Update(resultExpression);
                }
                return base.VisitMemberAssignment(node);
            }

            protected override Expression VisitMethodCall(MethodCallExpression node)
            {
                if (IncludeCompiler.IsIncludeMethod(node))
                {
                    _currentIncludeSource = node.Arguments[1] as QuerySourceReferenceExpression;
                }

                Visit(node.Arguments.Last());

                //we fold the include directly into the query this is a nop
                if (IncludeCompiler.IsIncludeMethod(node))
                {
                    _currentIncludeSource = null;
                    return node.Arguments[1];
                }
                else if(node.Method.Name == "IncludeCollection")
                {
                    //get the target navigation property
                    var navProp = node.Arguments[1] as ConstantExpression;
                    var realNavProp = navProp.Value as INavigation;
                    var joinOnLambda = node.Arguments.Last() as LambdaExpression;
                    var entitySourceType = typeof(EntityQueryable<>).MakeGenericType(joinOnLambda.Parameters[0].Type);
                    var entityQueryable = Expression.Constant(Activator.CreateInstance(entitySourceType, ((dynamic)_currentIncludeSource.ReferencedQuerySource).FromExpression.Value.Provider as IQueryProvider));
                    var madeJoin = new JoinClause(realNavProp.Name,
                        realNavProp.PropertyInfo.PropertyType.GenericTypeArguments[0], entityQueryable, Expression.Constant(true), Expression.Constant(true));
                    var madeGroupJoin = new GroupJoinClause(_currentIncludeSource.ReferencedQuerySource.ItemName + "." + realNavProp.Name, typeof(IEnumerable<>).MakeGenericType(madeJoin.ItemType), madeJoin);
                    var newQuerySource = new QuerySourceReferenceExpression(madeGroupJoin);
                    var rewrite = new SelectorRewriter()
                    {
                        Replacements = new Dictionary<Expression, Expression>
                        {
                            { joinOnLambda.Parameters[1], newQuerySource },
                            { joinOnLambda.Parameters[0], _currentIncludeSource }
                        }
                    };
                    var rewrittenJoinLambda = rewrite.Visit(joinOnLambda) as LambdaExpression;
                    var simpleJoinCondition = rewrittenJoinLambda.Body as BinaryExpression;

                    madeJoin.InnerKeySelector = simpleJoinCondition.Right;
                    madeJoin.OuterKeySelector = simpleJoinCondition.Left;
                    QueryModel.BodyClauses.Add(madeGroupJoin);
                }

                return node;
            }
        }

        public class SelectorRewriter : System.Linq.Expressions.ExpressionVisitor
        {
            public Dictionary<Expression, Expression> Replacements;
            protected override Expression VisitMember(MemberExpression node)
            {
                if (Replacements.TryGetValue(node.Expression, out var replacement))
                {
                    return Expression.Call(typeof(Microsoft.EntityFrameworkCore.EF), "Property", new Type[] { ((PropertyInfo) node.Member).PropertyType }, replacement, Expression.Constant(node.Member.Name));
                }
                else
                    return node;
            }
        }

        public PreparedQueryPlan QueryPlan { get; set; }
        public Type MainQueryType { get; set; }
        /// <summary>
        ///     This API supports the Entity Framework Core infrastructure and is not intended to be used
        ///     directly from your code. This API may change or be removed in future releases.
        /// </summary>
        public static readonly MethodInfo EntityQueryMethodInfo
            = typeof(HarmonyQueryModelVisitor).GetTypeInfo()
                .GetDeclaredMethod(nameof(EntityQuery));

        /// <summary>
        ///     This API supports the Entity Framework Core infrastructure and is not intended to be used
        ///     directly from your code. This API may change or be removed in future releases.
        /// </summary>
        public static readonly MethodInfo OfTypeMethodInfo
            = typeof(Enumerable).GetTypeInfo()
                .GetDeclaredMethod(nameof(Enumerable.OfType));


        private static IEnumerable<TEntity> EntityQuery<TEntity>(
            QueryContext queryContext,
            PreparedQueryPlan queryPlan,
            bool isTrackingQuery)
            where TEntity : DataObjectBase
        {
            return queryPlan.ExecuteCollectionPlan<TEntity>(
                (obj) => 
                {
                    if (isTrackingQuery)
                        queryContext.QueryBuffer.StartTracking(obj, (((HarmonyQueryContext)queryContext).GetEntityType(obj.GetType())));
                    return obj;
                },
                queryContext.ParameterValues, 
                (((HarmonyQueryContext)queryContext).Store));
        }

        /// <summary>
        ///     This API supports the Entity Framework Core infrastructure and is not intended to be used
        ///     directly from your code. This API may change or be removed in future releases.
        /// </summary>
        public static readonly MethodInfo ProjectionQueryMethodInfo
            = typeof(HarmonyQueryModelVisitor).GetTypeInfo()
                .GetDeclaredMethod(nameof(ProjectionQuery));


        private static IEnumerable<ValueBuffer> ProjectionQuery(
            QueryContext queryContext,
            PreparedQueryPlan queryPlan,
            bool isTrackingQuery)

        {
            throw new NotImplementedException();
            //QueryModelVisitor.ExecuteSelectInternal((expr, propName, outerQuery, innerQuery) =>
            //    {
            //        var joiningType = compilationContext.Model.FindEntityType(outerQuery.ItemType);
            //        var mainEntityType = compilationContext.Model.FindEntityType(innerQuery.ItemType);
            //        var maybeForeignKeys = joiningType.FindForeignKeys(joiningType.FindProperty(propName));
            //        var targetKey = maybeForeignKeys.FirstOrDefault((key) => key.PrincipalEntityType == mainEntityType);

            //        if (targetKey == null)
            //            throw new NotImplementedException();

            //        return Expression.And(expr, Expression.Call(typeof(Microsoft.EntityFrameworkCore.EF), "Property", new Type[] { targetKey.PrincipalKey.Properties.First().ClrType }, Expression.Constant(outerQuery), Expression.Constant(targetKey.PrincipalKey.Properties.First().Name)));
            //    }, queryModel, (obj) => { queryContext.QueryBuffer.StartTracking(obj, entityType); return obj; }, queryContext.ParameterValues, (((HarmonyQueryContext)queryContext).Store)).OfType<DataObjectBase>()
            //        .Select(t => new ValueBuffer(t.InternalGetValues()));
        }
    }
}
