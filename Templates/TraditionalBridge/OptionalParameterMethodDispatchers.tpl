<CODEGEN_FILENAME><INTERFACE_NAME>MethodDispachers.dbl</CODEGEN_FILENAME>
<REQUIRES_USERTOKEN>MODELS_NAMESPACE</REQUIRES_USERTOKEN>
<REQUIRES_CODEGEN_VERSION>5.3.15</REQUIRES_CODEGEN_VERSION>
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
;; Description: Dispatcher classes for exposed methods
;;
;;*****************************************************************************
;; WARNING: GENERATED CODE!
;; This file was generated by CodeGen. Avoid editing the file if possible.
;; Any changes you make will be lost of the file is re-generated.
;;*****************************************************************************

import Json
import Harmony.TraditionalBridge
import System.Collections
import <MODELS_NAMESPACE>

namespace <NAMESPACE>.<INTERFACE_NAME>

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

		private mRcbid, D_HANDLE

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

		protected override method DispatchInternal, void
			required in name,       string
			required in callFrame,  @JsonObject
			required in serializer, @DispatchSerializer
			required in dispatcher, @RoutineDispatcher
			record
				requestId,			int
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
				returnValue,		<IF HATVAL>i4<ELSE><METHOD_RETURN_TYPE></IF HATVAL>
</IF FUNCTION>
;//=========================================================================================================================
			endrecord

		<COUNTER_1_RESET>
		<PARAMETER_LOOP>
			<COUNTER_1_INCREMENT>
			<IF COLLECTION_ARRAY>
			;;Temp structure tempstr<COUNTER_1_VALUE>
			structure tempstr<COUNTER_1_VALUE>
				arry, <IF STRUCTURE>@<ParameterStructureNoplural><ELSE>[1]<PARAMETER_DEFINITION></IF STRUCTURE>
			endstructure

			</IF COLLECTION_ARRAY>
		</PARAMETER_LOOP>

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
			arguments = (@JsonArray)callFrame.GetProperty("params")
<ELSE>
			;;There are no inbound arguments to process
</IF COUNTER_1>
;//

			RCBInit(name, <COUNTER_1>, mRcbid)
<COUNTER_1_RESET>

<IF COUNTER_1>
			<PARAMETER_LOOP>
			<COUNTER_1_INCREMENT>
			
			RCBArg(<COUNTER_1_VALUE>, ^as(arguments[<COUNTER_1_VALUE>], @JsonObject), FieldDataType.<PARAMETER_TYPE>Field, arg<COUNTER_1_VALUE>, mRcbid)

			</PARAMETER_LOOP>
<ELSE>
			;;There are no inbound arguments to process
</IF COUNTER_1>
			%rcb_call(rcbid)

			<PARAMETER_LOOP>
			<COUNTER_1_INCREMENT>
			<IF OUT_OR_INOUT>
			RCBSerializeArg(<COUNTER_1_VALUE>, FieldDataType.<PARAMETER_TYPE>Field, arg<COUNTER_1_VALUE>, <PARAMETER_SIZE>, 0<PARAMETER_PRECISION>, serializer)
			</IF OUT_OR_INOUT>
			</PARAMETER_LOOP>

		endmethod

	endclass
</METHOD_LOOP>

endnamespace