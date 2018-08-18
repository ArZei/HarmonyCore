<CODEGEN_FILENAME><StructurePlural>Controller.dbl</CODEGEN_FILENAME>
<REQUIRES_CODEGEN_VERSION>5.3.5</REQUIRES_CODEGEN_VERSION>
<REQUIRES_USERTOKEN>MODELS_NAMESPACE</REQUIRES_USERTOKEN>
<REQUIRES_USERTOKEN>SERVICES_NAMESPACE</REQUIRES_USERTOKEN>
;//****************************************************************************
;//
;// Title:       ODataController.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Used to create OData Controllers in a Harmony Core environment
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
;; Title:       <StructurePlural>Controller.dbl
;;
;; Type:        Class
;;
;; Description: OData controller for the <STRUCTURE_NOALIAS> structure.
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

import Microsoft.AspNetCore.JsonPatch
import Microsoft.AspNetCore.Mvc
import Microsoft.AspNet.OData
import Microsoft.AspNet.OData.Routing
import Microsoft.EntityFrameworkCore
import Microsoft.EntityFrameworkCore.Infrastructure
import Harmony.Core.EF.Extensions
<IF DEFINED_AUTHENTICATION>
import Microsoft.AspNetCore.Authorization
</IF DEFINED_AUTHENTICATION>
import <MODELS_NAMESPACE>

namespace <NAMESPACE>

<IF DEFINED_AUTHENTICATION>
	{Authorize}
</IF DEFINED_AUTHENTICATION>
	;;; <summary>
	;;; OData controller for <StructurePlural>
	;;; </summary>
	public class <StructurePlural>Controller extends ODataController
	
		public readwrite property DBContext, @<SERVICES_NAMESPACE>.DBContext

		;;; <summary>
		;;; Constructs a new instance of <StructurePlural>Controller
		;;; </summary>
		;;; <param name="dbContext">Database context</param>
		public method <StructurePlural>Controller
			dbContext, @<SERVICES_NAMESPACE>.DBContext
		proc
			this.DBContext = dbContext
		endmethod

.region "READ"

		{ODataRoute("<StructurePlural>")}
;//		{ProducesResponseType(^typeof(IEnumerable<<StructureNoplural>>), 200)}
		{EnableQuery}
		;{EnableQuery(MaxExpansionDepth=3, MaxSkip=10, MaxTop=5, PageSize=4)}
		;;; <summary>
		;;; Get all <StructurePlural>
		;;; </summary>
		;;; <returns>Returns an IActionResult indicating the status of the operation and containing any data that was returned.</returns>
		public method Get, @IActionResult
		proc
			mreturn Ok(DBContext.<StructurePlural>)
		endmethod

		<PRIMARY_KEY>
		{ODataRoute("<StructurePlural>(<SEGMENT_LOOP><SegmentName>={a<SegmentName>}<,></SEGMENT_LOOP>)")}
;//		{ProducesResponseType(^typeof(<StructureNoplural>), 200)}
		{EnableQuery}
		;;; <summary>
		;;; Get a single <StructureNoplural> by primary key.
		;;; </summary>
        <SEGMENT_LOOP>
		;;; <param name="a<SegmentName>"><FIELD_DESC></param>
        </SEGMENT_LOOP>
		;;; <returns>Returns an IActionResult indicating the status of the operation and containing any data that was returned.</returns>
		public method Get, @IActionResult
            <SEGMENT_LOOP>
			{FromODataUri}
            required in a<SegmentName>, <SEGMENT_SNTYPE>
            </SEGMENT_LOOP>
		proc
			data result = DBContext.<StructurePlural>.Find(<SEGMENT_LOOP>a<SegmentName><,></SEGMENT_LOOP>)

			if (result == ^null)
				mreturn NotFound()

			mreturn Ok(result)

		endmethod
		</PRIMARY_KEY>
		
		<ALTERNATE_KEY_LOOP>
		{ODataRoute("<StructurePlural>(<SEGMENT_LOOP><SegmentName>={a<SegmentName>}<,></SEGMENT_LOOP>)")}
;//		{ProducesResponseType(^typeof(<StructureNoplural>), 200)}
		{EnableQuery}
		;;; <summary>
		;;; Get a single <StructureNoplural> by key <KeyName>.
		;;; </summary>
		<SEGMENT_LOOP>
		;;; <param name="a<SegmentName>"><FIELD_DESC></param>
		</SEGMENT_LOOP>
		;;; <returns>Returns an IActionResult indicating the status of the operation and containing any data that was returned.</returns>
		public method GetByKey<KeyName>, @IActionResult
			<SEGMENT_LOOP>
			{FromODataUri}
			required in a<SegmentName>, <SEGMENT_SNTYPE>
			</SEGMENT_LOOP>
		proc
			data result = DBContext.<StructurePlural>.FindAlternate<IF DUPLICATES>s</IF DUPLICATES>(<SEGMENT_LOOP>"<SegmentName>",a<SegmentName><,></SEGMENT_LOOP>)

			if (result == ^null)
				mreturn NotFound()

			mreturn Ok(result)

		endmethod

		</ALTERNATE_KEY_LOOP>
.endregion

.region "CREATE"

;//		{ODataRoute("<StructurePlural>")}
;//		{ProducesResponseType(^typeof(void), 200)}
;//		;;; <summary>
;//		;;; Create a new <structureNoplural> (automatically assigned primary key).
;//		;;; </summary>
;//		;;; <returns>Returns an IActionResult indicating the status of the operation and containing any data that was returned.</returns>
;//		public method Post, @IActionResult
;//			{FromBody}
;//			required in a<StructureNoplural>, @<StructureNoplural>
;//		proc
;//			;; Validate inbound data
;//			if (!ModelState.IsValid)
;//				mreturn BadRequest(ModelState)
;//
;//			;TODO: How do we support the auto-generation of primary key in this scenario?
;//			DBContext.<StructurePlural>.Add(a<StructureNoplural>)
;//
;//			;TODO: Need to add a Location header
;//
;//			;;Commit the change
;//			DBContext.SaveChanges()
;//
;//			mreturn Ok()
;//
;//		endmethod
;//
		<PRIMARY_KEY>
		{ODataRoute("<StructurePlural>(<SEGMENT_LOOP><SegmentName>={a<SegmentName>}<,></SEGMENT_LOOP>)")}
;//		{ProducesResponseType(^typeof(void), 204)}
		;;; <summary>
		;;; Create (with a client-supplied primary key) or replace a <structureNoplural>.
		;;; </summary>
        <SEGMENT_LOOP>
		;;; <param name="a<SegmentName>"><FIELD_DESC></param>
        </SEGMENT_LOOP>
		;;; <returns>Returns an IActionResult indicating the status of the operation and containing any data that was returned.</returns>
		public method Put, @IActionResult
            <SEGMENT_LOOP>
			{FromODataUri}
            required in a<SegmentName>, <SEGMENT_SNTYPE>
            </SEGMENT_LOOP>
			{FromBody}
			required in a<StructureNoplural>, @<StructureNoplural>
		proc
			;; Validate inbound data
			if (!ModelState.IsValid)
				mreturn BadRequest(ModelState)

			;;Ensure that the key values in the URI win over any data that may be in the model object
            <SEGMENT_LOOP>
            a<StructureNoplural>.<FieldSqlname> = a<SegmentName>
            </SEGMENT_LOOP>

			try
			begin
				;;Add and commit
				data existing = DBContext.<StructurePlural>.Find(<SEGMENT_LOOP>a<SegmentName><,></SEGMENT_LOOP>)
				if(existing != ^null) then
				begin
					DBContext.<StructurePlural>.Update(a<StructureNoplural>)
				end
				else
				begin
					DBContext.<StructurePlural>.Add(a<StructureNoplural>)
				end
				DBContext.SaveChanges()
			end
			catch (e, @InvalidOperationException)
			begin
				mreturn BadRequest(e)
			end
			endtry

			mreturn NoContent()

		endmethod
		</PRIMARY_KEY>

.endregion

.region "UPDATE"

		<PRIMARY_KEY>
		{ODataRoute("<StructurePlural>(<SEGMENT_LOOP><SegmentName>={a<SegmentName>}<,></SEGMENT_LOOP>)")}
;//		{ProducesResponseType(^typeof(void), 204)}
		;;; <summary>
		;;; Patch  (partial update) a <structureNoplural>.
		;;; </summary>
        <SEGMENT_LOOP>
		;;; <param name="a<SegmentName>"><FIELD_DESC></param>
        </SEGMENT_LOOP>
		;;; <returns>Returns an IActionResult indicating the status of the operation and containing any data that was returned.</returns>
		public method Patch, @IActionResult
            <SEGMENT_LOOP>
			{FromODataUri}
            required in a<SegmentName>, <SEGMENT_SNTYPE>
            </SEGMENT_LOOP>
			{FromBody}
			required in a<StructureNoplural>, @JsonPatchDocument<<StructureNoplural>>
		proc
			;; Validate inbound data
			if (!ModelState.IsValid)
				mreturn BadRequest(ModelState)

			;;Patch the existing <structureNoplural>
			try
			begin
				;;Get the <structureNoplural> to be updated
				data <structureNoplural>ToUpdate = DBContext.<StructurePlural>.Find(<SEGMENT_LOOP>a<SegmentName><,></SEGMENT_LOOP>)

				;;Did we find it?
				if(<structureNoplural>ToUpdate == ^null)
					mreturn NotFound()

				;;Apply the changes to the <structureNoplural> we read
				a<StructureNoplural>.ApplyTo(<structureNoplural>ToUpdate)

				;;Update and commit
				DBContext.<StructurePlural>.Update(<structureNoplural>ToUpdate)
				DBContext.SaveChanges()
			end
			catch (e, @InvalidOperationException)
			begin
				mreturn BadRequest(e)
			end
			endtry

			mreturn NoContent()

		endmethod
		</PRIMARY_KEY>

.endregion

.region "DELETE"

		<PRIMARY_KEY>
		{ODataRoute("<StructurePlural>(<SEGMENT_LOOP><SegmentName>={a<SegmentName>}<,></SEGMENT_LOOP>)")}
;//		{ProducesResponseType(^typeof(void), 204)}
		;;; <summary>
		;;; Delete a <structureNoplural>.
		;;; </summary>
        <SEGMENT_LOOP>
		;;; <param name="a<SegmentName>"><FIELD_DESC></param>
        </SEGMENT_LOOP>
		;;; <returns>Returns an IActionResult indicating the status of the operation and containing any data that was returned.</returns>
		public method Delete, @IActionResult
            <SEGMENT_LOOP>
			{FromODataUri}
            required in a<SegmentName>, <SEGMENT_SNTYPE>
            </SEGMENT_LOOP>
		proc
			;;Get the <structureNoplural> to be deleted
			data <structureNoplural>ToRemove = DBContext.<StructurePlural>.Find(<SEGMENT_LOOP>a<SegmentName><,></SEGMENT_LOOP>)

			;;Did we find it?
			if (<structureNoplural>ToRemove == ^null)
				mreturn NotFound()

			;;Delete and commit
			DBContext.<StructurePlural>.Remove(<structureNoplural>ToRemove)
			DBContext.SaveChanges()

			mreturn NoContent()

		endmethod
		</PRIMARY_KEY>

.endregion

	endclass

endnamespace