<CODEGEN_FILENAME><StructureNoplural>.dbl</CODEGEN_FILENAME>
<PROCESS_TEMPLATE>DataObjectMetaData</PROCESS_TEMPLATE>
;//****************************************************************************
;//
;// Title:       DataObject.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Template to define structure based Data Object with DBL types
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
;; Title:       <StructureNoplural>.dbl
;;
;; Type:        Class
;;
;; Description: Data object representing data defined by the repository
;;              structure <STRUCTURE_NOALIAS> and from the data file <FILE_NAME>.
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

import Harmony.TraditionalBridge

namespace <NAMESPACE>

	public partial class <StructureNoplural> extends DataObjectBase

		;; Metadata, current record state, and a copy of the original state
		public static sMetadata, @<StructureNoplural>Metadata
		private m<StructureNoplural>, str<StructureNoplural> 
		private mOriginal<StructureNoplural>, str<StructureNoplural> 
		
		;;; <summary>
		;;;  Construct an empty <StructureNoplural> object
		;;; </summary>
		public method <StructureNoplural>
			parent()
		proc
			init m<StructureNoplural>, mOriginal<StructureNoplural>
		endmethod

		;;; <summary>
		;;;  Construct a <StructureNoplural> object containing data from a record
		;;; </summary>
		public method <StructureNoplural>
			required in inData, str<StructureNoplural>
			parent()
		proc
			m<StructureNoplural> = mOriginal<StructureNoplural> = inData
		endmethod

		public override method InternalSynergyRecord, void
			targetMethod, @AlphaAction
		proc
			targetMethod.Run(m<StructureNoplural>, mGlobalRFA)
		endmethod
		
		<FIELD_LOOP>
		<IF CUSTOM_NOT_SYMPHONY_ARRAY_FIELD>
		;;; <summary>
		;;; <FIELD_DESC>
		;;; </summary>
		public property <FieldSqlname>, <field_type>
			method get
			proc
				mreturn m<StructureNoplural>.<field_name>				
			endmethod
			method set
			proc
				m<StructureNoplural>.<field_name> = value
			endmethod
		endproperty

		</IF CUSTOM_NOT_SYMPHONY_ARRAY_FIELD>
		</FIELD_LOOP>
		;;; <summary>
		;;; Expose the complete synergy record
		;;; </summary>
		public override property SynergyRecord, a
			method get
			proc
				mreturn m<StructureNoplural>
			endmethod
		endproperty
		
		;;; <summary>
		;;; Expose the complete original synergy record
		;;; </summary>
		public override property OriginalSynergyRecord, a
			method get
			proc
				mreturn mOriginal<StructureNoplural>
			endmethod
		endproperty

		;;; <summary>
		;;; Allow the host to validate all fields. Each field will fire the validation method.
		;;; </summary>
		public override method InitialValidateData, void
		proc
		endmethod
		
		public override property Metadata, @DataObjectMetadataBase
			method get
			proc
				if(sMetadata == ^null)
					sMetadata = new <StructureNoplural>Metadata()
				mreturn sMetadata
			endmethod
		endproperty

	endclass

endnamespace