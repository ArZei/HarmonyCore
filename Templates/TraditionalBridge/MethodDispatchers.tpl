<CODEGEN_FILENAME>MethodDispachers.dbl</CODEGEN_FILENAME>
<REQUIRES_USERTOKEN>MODELS_NAMESPACE</REQUIRES_USERTOKEN>
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
;; Title:       DispatcherMethods.dbl
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
import <MODELS_NAMESPACE>

namespace <NAMESPACE>
<METHOD_LOOP>

	public class <METHOD_ROUTINE>Dispatch extends RoutineStub

		<PARAMETER_LOOP>
		<IF STRUCTURE>
		<IF FIRST_INSTANCE_OF_STRUCTURE>
		private m<ParameterStructureNoplural>Metadata, @DataObjectMetadataBase
		</IF FIRST_INSTANCE_OF_STRUCTURE>
		</IF STRUCTURE>
		</PARAMETER_LOOP>

		public method <METHOD_ROUTINE>Dispatch
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
				arguments, @JsonArray
				<COUNTER_1_RESET>
				<COUNTER_2_RESET>
				<PARAMETER_LOOP>
				<COUNTER_1_INCREMENT>
				<IF STRUCTURE>
				<COUNTER_2_INCREMENT>
				<IF COUNTER_2_EQ_1>
				;;Data for structure-based arguments
				</IF COUNTER_2_EQ_1>
				<IF COLLECTION>
				arg<COUNTER_1_VALUE>Array, @JsonArray
				arg<COUNTER_1_VALUE>Handle, D_HANDLE
				arg<COUNTER_1_VALUE>HandlePos, int
				<IF COLLECTION_ARRAYLIST>
				arg<COUNTER_1_VALUE>List, @ArrayList
				</IF COLLECTION_ARRAYLIST>
				<ELSE>
				arg<COUNTER_1_VALUE>, @DataObjectBase
				arg<COUNTER_1_VALUE>Data, str<ParameterStructureNoplural>
				</IF COLLECTION>
				</IF STRUCTURE>
				</PARAMETER_LOOP>
				<IF FUNCTION>
				returnValue, <METHOD_RETURN_TYPE>
				</IF FUNCTION>
			endrecord
		proc

			;;Retrieve argument data

			arguments = (@JsonArray)callFrame.GetProperty("Arguments")

			<COUNTER_1_RESET>
			<COUNTER_2_RESET>
			<PARAMETER_LOOP>
			<COUNTER_1_INCREMENT>
			<IF STRUCTURE>
			<COUNTER_2_INCREMENT>
			<IF COUNTER_2_EQ_1>
			;;Prepare data for structure-based arguments

			</IF COUNTER_2_EQ_1>
;//Collection args
			<IF COLLECTION>
			arg<COUNTER_1_VALUE>Array = (@JsonArray)((@JsonObject)arguments.arrayValues[4]).GetProperty("PassedValue")
			arg<COUNTER_1_VALUE>Handle = %mem_proc(DM_ALLOC,^size(str<ParameterStructureNoplural>)*arg<COUNTER_1_VALUE>Array.arrayValues.Count)
			arg<COUNTER_1_VALUE>HandlePos = 1
			</IF COLLECTION>
			<IF COLLECTION_ARRAY>
			dispatcher.UnwrapObjectCollection(^m(arg<COUNTER_1_VALUE>Handle),^size(str<ParameterStructureNoplural>),arg<COUNTER_1_VALUE>HandlePos,arg<COUNTER_1_VALUE>Array)
			</IF COLLECTION_ARRAY>
			<IF COLLECTION_HANDLE>
			dispatcher.UnwrapObjectCollection(^m(arg<COUNTER_1_VALUE>Handle),^size(str<ParameterStructureNoplural>),arg<COUNTER_1_VALUE>HandlePos,arg<COUNTER_1_VALUE>Array)
			</IF COLLECTION_HANDLE>
			<IF COLLECTION_ARRAYLIST>
			arg<COUNTER_1_VALUE>List = new ArrayList()
			dispatcher.UnwrapObjectCollection(^m(arg<COUNTER_1_VALUE>Handle),^size(str<ParameterStructureNoplural>),arg<COUNTER_1_VALUE>HandlePos,arg<COUNTER_1_VALUE>Array,arg<COUNTER_1_VALUE>List)
			</IF COLLECTION_ARRAYLIST>
;//Non-collection args
			<IF COLLECTION>
			<ELSE>
			;;Get the data object
			arg<COUNTER_1_VALUE> = dispatcher.DeserializeObject((@JsonObject)arguments.arrayValues[3],m<ParameterStructureNoplural>Metadata)
			;;Get the record from the DO
			arg<COUNTER_1_VALUE>Data = arg<COUNTER_1_VALUE>.SynergyRecord
			</IF COLLECTION>
			</IF STRUCTURE>
			</PARAMETER_LOOP>

			;;Now call the method

;// Call a subroutine
;//
			<IF SUBROUTINE>
			xcall <METHOD_ROUTINE>(
			</IF SUBROUTINE>
;//
;// Call a function
;//
			<IF FUNCTION>
			returnValue = %<METHOD_ROUTINE>(
			</IF FUNCTION>
;//
<COUNTER_1_RESET>
<COUNTER_2_RESET>
<PARAMETER_LOOP>
<COUNTER_1_INCREMENT>
;// arguments.arrayValues is a JSON array of JsonValue types
;// For simple types the value is a JsonObject and we can use obj.PassedValue to get to the data.
;// The data is always in the same format, regardless of the ultimate target type here.
;// Code here needs to move that data into appropriate storage (with the help of dispatcher.Get???(value))
;//
;//
;//
;//
;//
;//
;//
;//
<IF COLLECTION>
;//
;// Collection parameters (Includes ARRAY, HANDLE collections and ArrayList collections, or any supported type)
;//
			<IF ALPHA>
			&	<,>
			</IF ALPHA>
			<IF DECIMAL>
			&	<,>
			</IF DECIMAL>
			<IF IMPLIED>
			&	<,>
			</IF IMPLIED>
			<IF INTEGER>
			&	<,>
			</IF INTEGER>
			<IF DATE>
			&	<,>
			</IF DATE>
			<IF TIME>
			&	<,>
			</IF TIME>
			<IF STRING>
			&	<,>
			</IF STRING>
			<IF STRUCTURE>
			<IF COLLECTION_ARRAY>
			&	^m(str<ParameterStructureNoplural>,arg<COUNTER_1_VALUE>Handle)<,>
			</IF COLLECTION_ARRAY>
			<IF COLLECTION_HANDLE>
			&	arg<COUNTER_1_VALUE>Handle<,>
			</IF COLLECTION_HANDLE>
			<IF COLLECTION_ARRAYLIST>
			&	arg<COUNTER_1_VALUE>List<,>
			</IF COLLECTION_ARRAYLIST>
			</IF STRUCTURE>
;//
<ELSE>
;//
;// Non-collection parameters
;//
			<IF ALPHA>
			&	dispatcher.GetText((@JsonObject)arguments.arrayValues[<COUNTER_2_VALUE>])<,>
			</IF ALPHA>
			<IF DECIMAL>
			&	dispatcher.GetDecimal((@JsonObject)arguments.arrayValues[<COUNTER_2_VALUE>])<,>
			</IF DECIMAL>
			<IF IMPLIED>
			&	dispatcher.GetImplied((@JsonObject)arguments.arrayValues[<COUNTER_2_VALUE>])<,>
			</IF IMPLIED>
			<IF INTEGER>
			&	dispatcher.GetInt((@JsonObject)arguments.arrayValues[<COUNTER_2_VALUE>])<,>
			</IF INTEGER>
			<IF ENUM>
			&	dispatcher.GetInt((@JsonObject)arguments.arrayValues[<COUNTER_2_VALUE>])<,>
			</IF ENUM>
			<IF DATE>
			&	dispatcher.GetDecimal((@JsonObject)arguments.arrayValues[<COUNTER_2_VALUE>])<,>
			</IF DATE>
			<IF TIME>
			&	dispatcher.GetDecimal((@JsonObject)arguments.arrayValues[<COUNTER_2_VALUE>])<,>
			</IF TIME>
			<IF HANDLE>
			&	<,>
			</IF HANDLE>
			<IF BINARY_HANDLE>
			&	<,>
			</IF BINARY_HANDLE>
			<IF STRING>
			&	<,>
			</IF STRING>
			<IF STRUCTURE>
			&	arg<COUNTER_1_VALUE>Data,
			</IF STRUCTURE>
;//
</IF COLLECTION>
<COUNTER_2_INCREMENT>
</PARAMETER_LOOP>			
			& )

			serializer.MapOpen()
			serializer.String("IsError")
			serializer.Bool(false)
			serializer.String("Result")
			serializer.MapOpen()
			serializer.MapClose()
			serializer.MapClose()

		endmethod

	endclass
	</METHOD_LOOP>

endnamespace