<CODEGEN_FILENAME>Startup.dbl</CODEGEN_FILENAME>
<REQUIRES_USERTOKEN>MODELS_NAMESPACE</REQUIRES_USERTOKEN>
;//****************************************************************************
;//
;// Title:       ODataEdmBuilder.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Creates a Startup class for an OData / Web API hosting environment
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
;; Title:       Startup.dbl
;;
;; Type:        Class
;;
;; Description: Startup class for an OData / Web API hosting environment
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

import Harmony.Core.Context
import Harmony.Core.FileIO
import Harmony.Core.Utility
import Harmony.AspNetCore.Context
import Microsoft.Extensions.DependencyInjection
import Microsoft.EntityFrameworkCore
import Microsoft.AspNet.OData.Extensions
import Microsoft.AspNetCore.Builder
import Microsoft.AspNetCore.Hosting
import <MODELS_NAMESPACE>

namespace SampleServices.Test

	public class Startup

		public method ConfigureServices, void
			services, @IServiceCollection 
		proc
			;services.AddTransient<PrimeService>()
			data channelManager = new FileChannelManager() 
			data objectProvider = new DataObjectProvider(channelManager)
			<STRUCTURE_LOOP>
			objectProvider.AddDataObjectMapping<<StructureNoplural>>("<FILE_NAME>", <IF STRUCTURE_ISAM>FileOpenMode.UpdateIndexed</IF STRUCTURE_ISAM><IF STRUCTURE_RELATIVE>FileOpenMode.UpdateRelative</IF STRUCTURE_RELATIVE>)
			</STRUCTURE_LOOP>
			services.AddSingleton<FileChannelManager>(channelManager)
			services.AddSingleton<IDataObjectProvider>(objectProvider)
			services.AddSingleton<DbContextOptions<DBContext>>(new DbContextOptions<DBContext>())
			services.AddSingleton<DBContext, DBContext>()
			services.AddOData()
			services.AddMvcCore()
		endmethod

		public method Configure, void
			app, @IApplicationBuilder
			env, @IHostingEnvironment
		proc
			data model = EdmBuilder.GetEdmModel()

			lambda MVCBuilder(builder)
			begin
				builder.Select().Expand().Filter().OrderBy().MaxTop(100).Count()
				builder.MapODataServiceRoute("odata", "odata", model)
			end
			app.UseLogging(DebugLogSession.Logging)
			app.UseMvc(MVCBuilder)
		endmethod
	endclass

endnamespace