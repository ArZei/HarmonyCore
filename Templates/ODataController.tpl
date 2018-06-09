<CODEGEN_FILENAME><StructureName>sController.dbl</CODEGEN_FILENAME>
;//****************************************************************************
;//
;// Title:       ODataController.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Used to create OData Controllers in a Harmony Core environment
;//
;// Author:      Steve Ives, Synergex Professional Services Group
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
;; Title:       <StructureName>sController.dbl
;;
;; Type:        Class
;;
;; Description: OData controller for the <STRUCTURE_NOALIAS> structure.
;;
;;*****************************************************************************
;; WARNING
;;
;; This file was code generated. Avoid editing this file, as any changes that you
;; make will be lost of the file is re-generated.
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

;TODO: Need to figure out what imports we need

namespace <NAMESPACE>

	public class <StructureName>sController extends ODataController
	
		public readwrite property DBContext, @ControllerDBContext

		public method <StructureName>sController
			dbContext, @ControllerDBContext
		proc
			this.DBContext = dbContext
		endmethod

		{ODataRoute("<StructureName>s")}
		{EnableQuery(MaxExpansionDepth=3, MaxSkip=10, MaxTop=5, PageSize=4)}
		public method Get, @IActionResult
		proc
			mreturn Ok(DBContext.<StructureName>s)
		endmethod

		{ODataRoute("<StructureName>s({id})")}
		public method Get, @IActionResult
			{FromODataUri}
			id, int
		proc
			data found<StructureName> = DBContext.<StructureName>s.Find(id)
			mreturn Ok(found<StructureName>)
		endmethod

		{ODataRoute("<StructureName>s({id})")}
		public method Post, @IActionResult
			{FromODataUri}
			id, int
		proc
			data found<StructureName> = DBContext.<StructureName>s.Find(id)
			DBContext.SaveChanges()
			mreturn Ok(found<StructureName>)
		endmethod

	endclass

endnamespace