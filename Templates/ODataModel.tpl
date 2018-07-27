<CODEGEN_FILENAME><StructureNoplural>.dbl</CODEGEN_FILENAME>
<PROCESS_TEMPLATE>ODataMetaData</PROCESS_TEMPLATE>
<OPTIONAL_USERTOKEN>RPSDATAFILES= </OPTIONAL_USERTOKEN>
<REQUIRES_CODEGEN_VERSION>5.3.4</REQUIRES_CODEGEN_VERSION>
;//****************************************************************************
;//
;// Title:       ODataModel.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Template to define structure based Data Object with CLR types
;//
;// Copyright (c) 2012, Synergex International, Inc. All rights reserved.
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
;; Description: Data model representing data defined by the repository
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
;; Copyright (c) 2012, Synergex International, Inc.
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

import System
import System.Collections.Generic
import System.ComponentModel.DataAnnotations
import System.Text
import Harmony.Core
import Harmony.Core.Converters

namespace <NAMESPACE>

    public partial class <StructureNoplural> extends DataObjectBase

        ;;make the record available and a copy
        private mSynergyData, str<StructureNoplural> 
		private mOriginalSynergyData, str<StructureNoplural> 
		
		private static sMetadata, @<StructureNoplural>Metadata

.region "Constructors"

		static method <StructureNoplural>
		proc
			sMetadata = new <StructureNoplural>Metadata()
			DataObjectMetadataBase.MetadataLookup.TryAdd(^typeof(<StructureNoplural>), sMetadata)
		endmethod
		
        ;;; <summary>
        ;;;  Constructor, initialise the base fields
        ;;; </summary>
        public method <StructureNoplural>
            parent()
        proc
			init mSynergyData, mOriginalSynergyData
        endmethod

		;;; <summary>
		;;;  Alternate Constructor, accepts the structured data
		;;; </summary>
		public method <StructureNoplural>
			required in inData, str<StructureNoplural>
			parent()
		proc
			mSynergyData = mOriginalSynergyData = inData
		endmethod

.endregion

.region "Attributes of this entity"

		<COUNTER_1_RESET>
        <FIELD_LOOP>
		<IF CUSTOM_NOT_SYMPHONY_ARRAY_FIELD>
		;;; <summary>
		;;; <FIELD_DESC>
		;;; </summary>
		<IF PKSEGMENT>
		{Key}
		</IF PKSEGMENT>
		<IF REQUIRED>
		{Required(ErrorMessage="<FIELD_DESC> is required. ")}
		</IF REQUIRED>
		<IF ALPHA>
		{StringLength(<FIELD_SIZE>, ErrorMessage="<FIELD_DESC> cannot exceed <FIELD_SIZE> characters. ")}
		</IF ALPHA>
		<COUNTER_1_INCREMENT>
		public property <FieldSqlname>, <FIELD_CSTYPE>
			method get
			proc
				<IF ALPHA>
				mreturn (<FIELD_CSTYPE>)SynergyAlphaConverter.Convert(mSynergyData.<Field_name>, ^null, ^null, ^null)
				</IF ALPHA>
				<IF DATE>
				mreturn (<FIELD_CSTYPE>)SynergyDecimalDateConverter.Convert(mSynergyData.<Field_name>, ^null, ^null, ^null)
				</IF DATE>
				<IF TIME>
				<IF TIME_HHMM>
				mreturn Convert.ToDateTime(%string(mSynergyData.<Field_name>,"XX:XX"))
				</IF TIME_HHMM>
				<IF TIME_HHMMSS>
				mreturn Convert.ToDateTime(%string(mSynergyData.<Field_name>,"XX:XX:XX"))
				</IF TIME_HHMMSS>
				</IF TIME>
				<IF DECIMAL>
				<IF PRECISION>
				mreturn (<FIELD_CSTYPE>)SynergyImpliedDecimalConverter.Convert(mSynergyData.<Field_name>, ^null, "DECIMALPLACES#<FIELD_PRECISION>", ^null)
				<ELSE>
				mreturn (<FIELD_CSTYPE>)mSynergyData.<Field_name>
				</IF PRECISION>
				</IF DECIMAL>
				<IF INTEGER>
				mreturn (<FIELD_CSTYPE>)mSynergyData.<Field_name>
				</IF INTEGER>
            endmethod
			method set
			proc
				<IF ALPHA>
				mSynergyData.<Field_name> = (<FIELD_TYPE>)SynergyAlphaConverter.ConvertBack(value, ^null, ^null, ^null)
				</IF ALPHA>
				<IF DATE>
				mSynergyData.<Field_name> = (<FIELD_TYPE>)SynergyDecimalDateConverter.ConvertBack(value, ^null, ^null, ^null)
				</IF DATE>
				<IF TIME>
				<IF TIME_HHMM>
				mSynergyData.<Field_name> = (value.Hour * 100) + value.Minute
				</IF TIME_HHMM>
				<IF TIME_HHMMSS>
				mSynergyData.<Field_name> = (value.Hour * 10000) + (value.Minute * 100) + value.Second
				</IF TIME_HHMMSS>
				</IF TIME>
				<IF DECIMAL>
				mSynergyData.<Field_name> = value
				</IF DECIMAL>
				<IF INTEGER>
				mSynergyData.<Field_name> = value
				</IF INTEGER>
			endmethod
		endproperty

		</IF CUSTOM_NOT_SYMPHONY_ARRAY_FIELD>
        </FIELD_LOOP>
.endregion

.define INCLUDE_RELATIONS
.ifdef INCLUDE_RELATIONS
.region "Relationships to other entities"

		<IF STRUCTURE_RELATIONS>
		<RELATION_LOOP>
		<COUNTER_1_INCREMENT>
		<IF MANY_TO_ONE_TO_MANY>
		;;; <summary>
		;;; Relationship (Type A)
		;;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (one) --> (many) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
		;;; </summary>
		public readwrite property REL_<RelationFromkey>, @<RelationTostructureNoplural>
		</IF MANY_TO_ONE_TO_MANY>
		<IF ONE_TO_ONE_TO_ONE>
		;;; <summary>
		;;; Relationship (Type B)
		;;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (one) --> (one) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
		;;; </summary>
		public readwrite property REL_<RelationFromkey>, @<RelationTostructureNoplural>
		</IF ONE_TO_ONE_TO_ONE>
		<IF ONE_TO_ONE>
		;;; <summary>
		;;; Relationship (Type C)
		;;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (one) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
		;;; </summary>
		public readwrite property REL_<RelationFromkey>, @<RelationTostructureNoplural>
		</IF ONE_TO_ONE>
		<IF ONE_TO_MANY_TO_ONE>
		;;; <summary>
		;;; Relationship (Type D)
		;;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) <-> (many) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
		;;; </summary>
		public readwrite property REL_<RelationTostructurePlural>, @ICollection<<RelationTostructureNoplural>>
		</IF ONE_TO_MANY_TO_ONE>
		<IF ONE_TO_MANY>
		;;; <summary>
		;;; Relationship (Type E)
		;;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (many) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
		;;; </summary>
		public readwrite property REL_<RelationTostructurePlural>, @ICollection<<RelationTostructureNoplural>>
		</IF ONE_TO_MANY>

		</RELATION_LOOP>
		</IF STRUCTURE_RELATIONS>
.endregion
.endc

<IF STRUCTURE_RELATIONS>
.region "Properties to represent literal key segments"

<RELATION_LOOP>
<COUNTER_1_RESET>
<FROM_KEY_SEGMENT_LOOP>
<IF SEG_TYPE_LITERAL>
	;;; <summary>
	;;; 
	;;; </summary>
	public readwrite property <RelationFromkey>Literal<COUNTER_1_INCREMENT><COUNTER_1_VALUE>, <LITERAL_SEGMENT_CSTYPE>, <LITERAL_SEGMENT_VALUE>

</IF SEG_TYPE_LITERAL>
</FROM_KEY_SEGMENT_LOOP>
</RELATION_LOOP>
.endregion

</IF STRUCTURE_RELATIONS>
.region "Other attributes"

        ;;; <summary>
        ;;; Expose the complete synergy record
        ;;; </summary>
		public override property SynergyRecord, a
            method get
            proc
                mreturn mSynergyData
            endmethod
        endproperty
		
		;;; <summary>
        ;;; Expose the complete original synergy record
        ;;; </summary>
		public override property OriginalSynergyRecord, a
            method get
            proc
                mreturn mOriginalSynergyData
            endmethod
        endproperty

		;;; <summary>
        ;;; Metadata describing the public field properties
        ;;; </summary>
		public override property Metadata, @DataObjectMetadataBase
			method get
			proc
				mreturn sMetadata
			endmethod
		endproperty

.endregion

.region "Public methods"

		;;; <summary>
		;;; 
		;;; </summary>
		public override method InternalSynergyRecord, void
			targetMethod, @AlphaAction
		proc
			targetMethod(mSynergyData, mGlobalRFA)
		endmethod
		
		;;; <summary>
		;;; Allow the host to validate all fields. Each field will fire the validation method.
		;;; </summary>
		public override method InitialValidateData, void
		proc
		endmethod
		
		;;; <summary>
		;;; 
		;;; </summary>
		public override method InternalGetValues, [#]@object
		proc
			;;TODO: This should be returning boxed values for each of our fields
			mreturn new Object[<COUNTER_1_VALUE>]
		endmethod

.endregion

	endclass
	
endnamespace

