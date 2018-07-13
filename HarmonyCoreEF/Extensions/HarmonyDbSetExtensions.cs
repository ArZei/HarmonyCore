﻿using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace Harmony.Core.EF.Extensions
{
    public static class HarmonyDbSetExtensions
    {
        public static T FindAlternate<T>(this DbSet<T> thisp, string keyName, object keyValue) where T : class
        {
            // Find DbContext, entity type, and primary key.
            var context = ((IInfrastructure<IServiceProvider>)thisp).GetService<DbContext>();
            var entityType = context.Model.FindEntityType(typeof(T));
            // Build the lambda expression for the query: (TEntity entity) => AND( entity.keyProperty[i] == keyValues[i])
            var entityParameter = Expression.Parameter(typeof(T), "entity");
            Expression whereClause = Expression.Equal(
                    Expression.Property(entityParameter, keyName),
                    Expression.Constant(keyValue));

            var lambdaExpression = (Expression<Func<T, bool>>)Expression.Lambda(whereClause, entityParameter);

            // Execute against the in-memory entities, which we get from ChangeTracker (but not filtering the state of the entities).
            var entries = context.ChangeTracker.Entries<T>().Select((EntityEntry e) => (T)e.Entity);
            T entity = entries.AsQueryable().Where(lambdaExpression).FirstOrDefault(); // First is what triggers the query execution.

            // If found in memory then we're done.
            if (entity != null) { return entity; }

            // Otherwise execute the query against the database.
            return thisp.Where(lambdaExpression).FirstOrDefault();
        }

        public static T FindAlternate<T>(this DbSet<T> thisp, string keyName, object keyValue, string keyName2, object keyValue2) where T : class
        {
            // Find DbContext, entity type, and primary key.
            var context = ((IInfrastructure<IServiceProvider>)thisp).GetService<DbContext>();
            var entityType = context.Model.FindEntityType(typeof(T));
            // Build the lambda expression for the query: (TEntity entity) => AND( entity.keyProperty[i] == keyValues[i])
            var entityParameter = Expression.Parameter(typeof(T), "entity");
            Expression whereClause = Expression.And(
                Expression.Equal(
                    Expression.Property(entityParameter, keyName),
                    Expression.Constant(keyValue)),
                Expression.Equal(
                    Expression.Property(entityParameter, keyName2),
                    Expression.Constant(keyValue2)));

            var lambdaExpression = (Expression<Func<T, bool>>)Expression.Lambda(whereClause, entityParameter);

            // Execute against the in-memory entities, which we get from ChangeTracker (but not filtering the state of the entities).
            var entries = context.ChangeTracker.Entries<T>().Select((EntityEntry e) => (T)e.Entity);
            T entity = entries.AsQueryable().Where(lambdaExpression).FirstOrDefault(); // First is what triggers the query execution.

            // If found in memory then we're done.
            if (entity != null) { return entity; }

            // Otherwise execute the query against the database.
            return thisp.Where(lambdaExpression).FirstOrDefault();
        }

        public static T FindAlternate<T>(this DbSet<T> thisp, string keyName, object keyValue, string keyName2, object keyValue2, string keyName3, object keyValue3) where T : class
        {
            // Find DbContext, entity type, and primary key.
            var context = ((IInfrastructure<IServiceProvider>)thisp).GetService<DbContext>();
            var entityType = context.Model.FindEntityType(typeof(T));
            // Build the lambda expression for the query: (TEntity entity) => AND( entity.keyProperty[i] == keyValues[i])
            var entityParameter = Expression.Parameter(typeof(T), "entity");
            Expression whereClause =
                Expression.And(
                    Expression.Equal(
                        Expression.Property(entityParameter, keyName),
                        Expression.Constant(keyValue)),
                    Expression.And(
                        Expression.Equal(
                            Expression.Property(entityParameter, keyName2),
                            Expression.Constant(keyValue2)),
                        Expression.Equal(
                            Expression.Property(entityParameter, keyName3),
                            Expression.Constant(keyValue3))));

            var lambdaExpression = (Expression<Func<T, bool>>)Expression.Lambda(whereClause, entityParameter);

            // Execute against the in-memory entities, which we get from ChangeTracker (but not filtering the state of the entities).
            var entries = context.ChangeTracker.Entries<T>().Select((EntityEntry e) => (T)e.Entity);
            T entity = entries.AsQueryable().Where(lambdaExpression).FirstOrDefault(); // First is what triggers the query execution.

            // If found in memory then we're done.
            if (entity != null) { return entity; }

            // Otherwise execute the query against the database.
            return thisp.Where(lambdaExpression).FirstOrDefault();
        }

        public static IQueryable<T> FindAlternates<T>(this DbSet<T> thisp, string keyName, object keyValue) where T : class
        {
            // Find DbContext, entity type, and primary key.
            var context = ((IInfrastructure<IServiceProvider>)thisp).GetService<DbContext>();
            var entityType = context.Model.FindEntityType(typeof(T));
            // Build the lambda expression for the query: (TEntity entity) => AND( entity.keyProperty[i] == keyValues[i])
            var entityParameter = Expression.Parameter(typeof(T), "entity");
            Expression whereClause = Expression.Equal(
                    Expression.Property(entityParameter, keyName),
                    Expression.Constant(keyValue));

            var lambdaExpression = (Expression<Func<T, bool>>)Expression.Lambda(whereClause, entityParameter);
            // Otherwise execute the query against the database.
            return thisp.Where(lambdaExpression);
        }

        public static IQueryable<T> FindAlternates<T>(this DbSet<T> thisp, string keyName, object keyValue, string keyName2, object keyValue2) where T : class
        {
            // Find DbContext, entity type, and primary key.
            var context = ((IInfrastructure<IServiceProvider>)thisp).GetService<DbContext>();
            var entityType = context.Model.FindEntityType(typeof(T));
            // Build the lambda expression for the query: (TEntity entity) => AND( entity.keyProperty[i] == keyValues[i])
            var entityParameter = Expression.Parameter(typeof(T), "entity");
            Expression whereClause = Expression.And(
                Expression.Equal(
                    Expression.Property(entityParameter, keyName),
                    Expression.Constant(keyValue)),
                Expression.Equal(
                    Expression.Property(entityParameter, keyName2),
                    Expression.Constant(keyValue2)));

            var lambdaExpression = (Expression<Func<T, bool>>)Expression.Lambda(whereClause, entityParameter);
            // Otherwise execute the query against the database.
            return thisp.Where(lambdaExpression);
        }
    }
}
