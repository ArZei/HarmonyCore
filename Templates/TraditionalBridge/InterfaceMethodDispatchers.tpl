<CODEGEN_FILENAME><INTERFACE_NAME>MethodDispachers.dbl</CODEGEN_FILENAME>
<REQUIRES_USERTOKEN>MODELS_NAMESPACE</REQUIRES_USERTOKEN>
<REQUIRES_CODEGEN_VERSION>5.3.3</REQUIRES_CODEGEN_VERSION>
;//****************************************************************************
;//
;// Title:       MethodDispachers.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Generates dispatcher classes for exposed methods
;//
;// Copyright (c) 2018, Synergex International, Inc. All rights reserved.
;//
;// Redistribution and use in source and binary forms, with or without
;// modification, are permitted provided that the following conditions are met:
;//
;// * Redistributions of source code must retain the above copyright notice,
;//   this list of conditions and the following disclaimer.
;//
;// * Redistributions in binary form must reproduce the above copyright notice,
;//   this list of conditions and the following disclaimer in the documentation
;//   and/or other materials provided with the distribution.
;//
;// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;// POSSIBILITY OF SUCH DAMAGE.
;//
;;*****************************************************************************
;;
;; Title:       <INTERFACE_NAME>MethodDispachers.dbl
;;
;; Type:        Classes
;;
;; Description: Dispatcher classes for exposed methods
;;
;;*****************************************************************************
;; WARNING
;;
;; This file was code generated. Avoid editing this file, as any changes that
;; you make will be lost of the file is re-generated.
;;
;;*****************************************************************************
;;
;; Copyright (c) 2018, Synergex International, Inc.
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;
;; * Redistributions of source code must retain the above copyright notice,
;;   this list of conditions and the following disclaimer.
;;
;; * Redistributions in binary form must reproduce the above copyright notice,
;;   this list of conditions and the following disclaimer in the documentation
;;   and/or other materials provided with the distribution.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;; POSSIBILITY OF SUCH DAMAGE.
;;
;;*****************************************************************************

import Json
import Harmony.TraditionalBridge
import System.Collections
import <MODELS_NAMESPACE>

namespace <NAMESPACE>.<INTERFACE_NAME>

	structure strFake
		,a1
	endstructure
<METHOD_LOOP>

	;;-------------------------------------------------------------------------
	;;; <summary>
	;;; Dispatcher for method <INTERFACE_NAME>.<METHOD_NAME>
	;;; </summary>
	public class <METHOD_NAME>_Dispatch extends RoutineStub

		<PARAMETER_LOOP>
		<IF STRUCTURE>
		<IF FIRST_INSTANCE_OF_STRUCTURE>
		private m<ParameterStructureNoplural>Metadata, @DataObjectMetadataBase
		</IF FIRST_INSTANCE_OF_STRUCTURE>
		</IF STRUCTURE>
		</PARAMETER_LOOP>

		public method <METHOD_NAME>_Dispatch
		proc
			;;Initialize the meta data for any data objects that are used by parameters to the method
			<PARAMETER_LOOP>
			<IF STRUCTURE>
			<IF FIRST_INSTANCE_OF_STRUCTURE>
			m<ParameterStructureNoplural>Metadata = DataObjectMetadataBase.LookupType("<ParameterStructureNoplural>")
			</IF FIRST_INSTANCE_OF_STRUCTURE>
			</IF STRUCTURE>
			</PARAMETER_LOOP>
		endmethod

		public override method Dispatch, void
			required in name,       string
			required in callFrame,  @JsonObject
			required in serializer, @ChannelSerializer
			required in dispatcher, @RoutineDispatcher
			record
				arguments,			@JsonArray
				argumentDefinition, @ArgumentDataDefinition
<COUNTER_1_RESET>
<PARAMETER_LOOP>
	<COUNTER_1_INCREMENT>
;//
;//=========================================================================================================================
;// Declare variables for arguments
;//
				;;Argument <COUNTER_1_VALUE> (<PARAMETER_REQUIRED> <PARAMETER_DIRECTION> <PARAMETER_NAME> <IF COLLECTION_ARRAY>[*]</IF COLLECTION_ARRAY><IF COLLECTION_HANDLE>memory handle collection of </IF COLLECTION_HANDLE><IF COLLECTION_ARRAYLIST>ArrayList collection of </IF COLLECTION_ARRAYLIST><IF STRUCTURE>structure </IF STRUCTURE><IF ENUM>enum </IF ENUM><IF STRUCTURE>@<ParameterStructureNoplural><ELSE><PARAMETER_DEFINITION></IF STRUCTURE><IF DATE> <PARAMETER_DATE_FORMAT> date</IF DATE><IF TIME> <PARAMETER_DATE_FORMAT> time</IF TIME><IF REFERENCE> passed by REFERENCE</IF REFERENCE><IF VALUE> passed by VALUE</IF VALUE><IF DATATABLE> returned as DataTable</IF DATATABLE>)
	<IF COLLECTION>
		<IF IN_OR_INOUT>
				arg<COUNTER_1_VALUE>Array,			@JsonArray
		</IF IN_OR_INOUT>
		<IF COLLECTION_ARRAY>
				arg<COUNTER_1_VALUE>Handle,			D_HANDLE
				arg<COUNTER_1_VALUE>HandlePos,		int
		</IF COLLECTION_ARRAY>
		<IF COLLECTION_HANDLE>
				arg<COUNTER_1_VALUE>Handle,			D_HANDLE
				arg<COUNTER_1_VALUE>HandlePos,		int
		</IF COLLECTION_HANDLE>
		<IF COLLECTION_ARRAYLIST>
				arg<COUNTER_1_VALUE>,				@ArrayList
		</IF COLLECTION_ARRAYLIST>
	<ELSE>
		<IF STRUCTURE>
				arg<COUNTER_1_VALUE>DataObject, @DataObjectBase
				arg<COUNTER_1_VALUE>, str<ParameterStructureNoplural>
		<ELSE>
				arg<COUNTER_1_VALUE>,				<parameter_definition>
		</IF STRUCTURE>
	</IF COLLECTION>
</PARAMETER_LOOP>
;//
;//=========================================================================================================================
;// Declare variable for function return value
;//
<IF FUNCTION>
				returnValue,		<METHOD_RETURN_TYPE>
</IF FUNCTION>
;//=========================================================================================================================
			endrecord
		proc
;//
;//=========================================================================================================================
;// Assign values to argument variables
;//
<COUNTER_1_RESET>
<PARAMETER_LOOP>
	<IF IN_OR_INOUT>
		<COUNTER_1_INCREMENT>
	</IF IN_OR_INOUT>
</PARAMETER_LOOP>
;//

			;;------------------------------------------------------------
			;;Process inbound arguments

<IF COUNTER_1>
			arguments = (@JsonArray)callFrame.GetProperty("Arguments")
<ELSE>
			;;There are no inbound arguments to process
</IF COUNTER_1>
;//
<COUNTER_1_RESET>
<PARAMETER_LOOP>
	<COUNTER_1_INCREMENT>
	<IF IN_OR_INOUT>

			;;Argument 1 (<PARAMETER_REQUIRED> <PARAMETER_DIRECTION> <PARAMETER_NAME> <IF COLLECTION_ARRAY>[*]</IF COLLECTION_ARRAY><IF COLLECTION_HANDLE>memory handle collection of </IF COLLECTION_HANDLE><IF COLLECTION_ARRAYLIST>ArrayList collection of </IF COLLECTION_ARRAYLIST><IF STRUCTURE>structure </IF STRUCTURE><IF ENUM>enum </IF ENUM><IF STRUCTURE>@<ParameterStructureNoplural><ELSE><PARAMETER_DEFINITION></IF STRUCTURE><IF DATE> <PARAMETER_DATE_FORMAT> date</IF DATE><IF TIME> <PARAMETER_DATE_FORMAT> time</IF TIME><IF REFERENCE> passed by REFERENCE</IF REFERENCE><IF VALUE> passed by VALUE</IF VALUE><IF DATATABLE> returned as DataTable</IF DATATABLE>)
	<IF COLLECTION>
;//
			argumentDefinition = dispatcher.GetArgumentDataDefForCollection((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
			arg<COUNTER_1_VALUE>Array = (@JsonArray)((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>]).GetProperty("PassedValue")
;//
		<IF COLLECTION_ARRAY>
			arg<COUNTER_1_VALUE>Handle = %mem_proc(DM_ALLOC,argumentDefinition.ElementSize*arg<COUNTER_1_VALUE>Array.arrayValues.Count)
			arg<COUNTER_1_VALUE>HandlePos = 1
			dispatcher.UnwrapObjectCollection(^m(arg<COUNTER_1_VALUE>Handle),argumentDefinition,arg<COUNTER_1_VALUE>HandlePos,arg<COUNTER_1_VALUE>Array)
		</IF COLLECTION_ARRAY>
;//
		<IF COLLECTION_HANDLE>
			arg<COUNTER_1_VALUE>Handle = %mem_proc(DM_ALLOC,argumentDefinition.ElementSize*arg<COUNTER_1_VALUE>Array.arrayValues.Count)
			arg<COUNTER_1_VALUE>HandlePos = 1
			dispatcher.UnwrapObjectCollection(^m(arg<COUNTER_1_VALUE>Handle),argumentDefinition,arg<COUNTER_1_VALUE>HandlePos,arg<COUNTER_1_VALUE>Array)
		</IF COLLECTION_HANDLE>
;//
		<IF COLLECTION_ARRAYLIST>
			arg<COUNTER_1_VALUE> = new ArrayList()
			dispatcher.UnwrapObjectCollection(argumentDefinition,arg<COUNTER_1_VALUE>Array,arg<COUNTER_1_VALUE>)
		</IF COLLECTION_ARRAYLIST>
	<ELSE>
;//
		<IF ALPHA>
			arg<COUNTER_1_VALUE> = dispatcher.GetText((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
		</IF ALPHA>
;//
		<IF DECIMAL>
			arg<COUNTER_1_VALUE> = dispatcher.GetDecimal((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
		</IF DECIMAL>
;//
		<IF IMPLIED>
			arg<COUNTER_1_VALUE> = dispatcher.GetImplied((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
		</IF IMPLIED>
;//
		<IF INTEGER>
			arg<COUNTER_1_VALUE> = dispatcher.GetInt((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
		</IF INTEGER>
;//
		<IF ENUM>
			arg<COUNTER_1_VALUE> = (<PARAMETER_ENUM>)dispatcher.GetInt((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
		</IF ENUM>
;//
		<IF DATE>
			arg<COUNTER_1_VALUE> = dispatcher.GetDecimal((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
		</IF DATE>
;//
		<IF TIME>
			arg<COUNTER_1_VALUE> = dispatcher.GetDecimal((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
		</IF TIME>
;//
		<IF HANDLE>
			;TODO: Template needs code for HANDLE arguments!
			arg<COUNTER_1_VALUE> = 
		</IF HANDLE>
;//
		<IF BINARY_HANDLE>
			;TODO: Template needs code for BINARY HANDLE arguments!
			arg<COUNTER_1_VALUE> =
		</IF BINARY_HANDLE>
;//
		<IF STRING>
			arg<COUNTER_1_VALUE> = dispatcher.GetText((@JsonObject)arguments.arrayValues[<COUNTER_1_VALUE>])
		</IF STRING>
;//
		<IF STRUCTURE>
			;;Structure argument. Get the data object then get the record from it
			arg<COUNTER_1_VALUE>DataObject = dispatcher.DeserializeObject((@JsonObject)arguments.arrayValues[3],m<ParameterStructureNoplural>Metadata)
			arg<COUNTER_1_VALUE> = arg<COUNTER_1_VALUE>DataObject.SynergyRecord
		</IF STRUCTURE>
;//
	</IF COLLECTION>
	</IF IN_OR_INOUT>
</PARAMETER_LOOP>
;//
;//=========================================================================================================================
;// Make the method call
;//

			;;------------------------------------------------------------
			;; Call the underlying routine

			<IF SUBROUTINE>xcall <ELSE>returnValue = %</IF SUBROUTINE><METHOD_ROUTINE>(<COUNTER_1_RESET><PARAMETER_LOOP><COUNTER_1_INCREMENT><IF COLLECTION><IF COLLECTION_ARRAY>^m(<IF STRUCTURE>str<ParameterStructureNoplural><ELSE>strFake(1:<PARAMETER_SIZE>)</IF STRUCTURE>,arg<COUNTER_1_VALUE>Handle)<,></IF COLLECTION_ARRAY><IF COLLECTION_HANDLE>arg<COUNTER_1_VALUE>Handle<,></IF COLLECTION_HANDLE><IF COLLECTION_ARRAYLIST>arg<COUNTER_1_VALUE><,></IF COLLECTION_ARRAYLIST><ELSE>arg<COUNTER_1_VALUE><,></IF COLLECTION></PARAMETER_LOOP>)
;//
;//=========================================================================================================================
;// Build the JSON response
;//

			;;------------------------------------------------------------
			;;Build the JSON response

			serializer.MapOpen()
			serializer.String("IsError")
			serializer.Bool(false)
			serializer.String("Result")
			serializer.MapOpen()
			serializer.String("ReturnParameters")
			serializer.ArrayOpen()
<IF FUNCTION>

			;;Function return value

			serializer.MapOpen()
			serializer.String("Position")
			serializer.Integer(0)
			serializer.String("Value")
			serializer.MapOpen()
			serializer.String("DataType")
			;TODO: Needs to handle all the valid function return types
			serializer.Integer(FieldDataType.EnumField)
			serializer.String("PassedValue")
			serializer.Integer(returnValue)
			serializer.MapClose()
			serializer.MapClose()
</IF FUNCTION>
;//
;//Argument processing
;//
<COUNTER_1_RESET>
<PARAMETER_LOOP>
<COUNTER_1_INCREMENT>
<IF OUT_OR_INOUT>

			;;--------------------------------------------------------------------------------
			;;Argument <COUNTER_1_VALUE> (<PARAMETER_REQUIRED> <PARAMETER_DIRECTION> <PARAMETER_NAME> <IF COLLECTION_ARRAY>[*]</IF COLLECTION_ARRAY><IF COLLECTION_HANDLE>memory handle collection of </IF COLLECTION_HANDLE><IF COLLECTION_ARRAYLIST>ArrayList collection of </IF COLLECTION_ARRAYLIST><IF STRUCTURE>structure </IF STRUCTURE><IF ENUM>enum </IF ENUM><IF STRUCTURE>@<ParameterStructureNoplural><ELSE><PARAMETER_DEFINITION></IF STRUCTURE><IF DATE> <PARAMETER_DATE_FORMAT> date</IF DATE><IF TIME> <PARAMETER_DATE_FORMAT> time</IF TIME><IF REFERENCE> passed by REFERENCE</IF REFERENCE><IF VALUE> passed by VALUE</IF VALUE><IF DATATABLE> returned as DataTable</IF DATATABLE>)

			serializer.MapOpen()
			serializer.String("Position")
			serializer.Integer(<COUNTER_1_VALUE>)
			serializer.String("Value")
			serializer.MapOpen()
			serializer.String("DataType")
;//
	<IF ALPHA>
		<IF COLLECTION>
			serializer.Integer(FieldDataType.AlphaArrayField)
			serializer.String("PassedValue")
			serializer.ArrayOpen()

			serializer.ArrayClose()
		<ELSE>
			serializer.Integer(FieldDataType.AlphaField)
			serializer.String("PassedValue")
			serializer.String(%atrim(arg<COUNTER_1_VALUE>))
		</IF COLLECTION>
	</IF ALPHA>
;//
	<IF DECIMAL>
		<IF COLLECTION>
			;TODO: Need to add support for collection of decimal
		<ELSE>
			serializer.Integer(FieldDataType.DecimalField)
			serializer.String("PassedValue")
			serializer.Integer(arg<COUNTER_1_VALUE>)
		</IF COLLECTION>
	</IF DECIMAL>
;//
	<IF IMPLIED>
		<IF COLLECTION>
			;TODO: Need to add support for collection of implied decimal
		<ELSE>
			serializer.Integer(FieldDataType.ImpliedDecimal)
			serializer.String("PassedValue")
			serializer.Double(arg<COUNTER_1_VALUE>)
		</IF COLLECTION>
	</IF IMPLIED>
;//
	<IF INTEGER>
		<IF COLLECTION>
			;TODO: Need to add support for collection of integer
		<ELSE>
			serializer.Integer(FieldDataType.IntegerField)
			serializer.String("PassedValue")
			serializer.Integer(arg<COUNTER_1_VALUE>)
		</IF COLLECTION>
	</IF INTEGER>
;//
	<IF ENUM>
			;TODO: Do we need custom processing for enum fields beyond the integer value?
			serializer.Integer(FieldDataType.IntegerField)
			serializer.String("PassedValue")
			serializer.Integer(arg<COUNTER_1_VALUE>)
	</IF ENUM>
;//
	<IF DATE>
		<IF COLLECTION>
			;TODO: Need to add support for collection of date
		<ELSE>
			;TODO: Do we need custom processing for date fields beyond the decimal value?
			serializer.Integer(FieldDataType.DecimalField)
			serializer.String("PassedValue")
			serializer.Integer(arg<COUNTER_1_VALUE>)
		</IF COLLECTION>
	</IF DATE>
;//
	<IF TIME>
		<IF COLLECTION>
			;TODO: Need to add support for collection of time
		<ELSE>
			;TODO: Do we need custom processing for time fields beyond the decimal value?
			serializer.Integer(FieldDataType.DecimalField)
			serializer.String("PassedValue")
			serializer.Integer(arg<COUNTER_1_VALUE>)
		</IF COLLECTION>
	</IF TIME>
;//
	<IF HANDLE>
			serializer.Integer(FieldDataType.HandleField)
			serializer.String("PassedValue")
			;TODO: Handle support is incomplete and will FAIL!!!
	</IF HANDLE>
;//
	<IF BINARY_HANDLE>
			serializer.Integer(FieldDataType.BinaryHandleField)
			serializer.String("PassedValue")
			;TODO: Binary Handle support is incomplete and will FAIL!!!
	</IF BINARY_HANDLE>
;//
	<IF STRING>
			serializer.Integer(FieldDataType.StringField)
			serializer.String("PassedValue")
		<IF COLLECTION>
			;TODO: Need to add support for collection of string
		<ELSE>
			;TODO: Need to add support for string
		</IF COLLECTION>
	</IF STRING>
;//
;//Start of structure parameter processing
;//
	<IF STRUCTURE>
		<IF COLLECTION>
;//
;//Structure collection processing
;//
			serializer.Integer(FieldDataType.DataObjectCollectionField)
			serializer.String("PassedValue")
			serializer.ArrayOpen()
;//
;//Structure array processing
;//
		<IF COLLECTION_ARRAY>
			;TODO: Need to add support for array of structure
		</IF COLLECTION_ARRAY>
;//
;//Structure memory handle collection processing
;//
		<IF COLLECTION_HANDLE>
			;TODO: Need to add support for memory handle collection of structure
		</IF COLLECTION_HANDLE>
;//
;//Structure ArrayList processing
;//
		<IF COLLECTION_ARRAYLIST>
			begin
				data this<ParameterStructureNoplural>, @str<ParameterStructureNoplural>
				foreach this<ParameterStructureNoplural> in arg<COUNTER_1_VALUE>
					new <ParameterStructureNoplural>((str<ParameterStructureNoplural>)this<ParameterStructureNoplural>).Serialize(serializer)
			end
		</IF COLLECTION_ARRAYLIST>
;//
;//End of structure collection processing
;//
			serializer.ArrayClose()
		<ELSE>
;//
;//Single structure processing
;//
			;;Argument <COUNTER_1_VALUE>: Single <ParameterStructureNoplural> record
			serializer.Integer(FieldDataType.DataObjectField)
			serializer.String("PassedValue")
			;TODO: Support for single structure is incomplete
		</IF COLLECTION>
;//
	</IF STRUCTURE>
			serializer.MapClose()
			serializer.MapClose()
</IF OUT_OR_INOUT>
</PARAMETER_LOOP>

			;;Terminate the "ReturnParameters" array
			serializer.ArrayClose()

			;;Terminate the "Result" object
			serializer.MapClose()

			;;Terminate the response object
			begin
				;;Structured this way to assist with debugging
				data protocolMessage, string
				serializer.MapClose(protocolMessage)
				nop
			end

		endmethod

	endclass
</METHOD_LOOP>

endnamespace