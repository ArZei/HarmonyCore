<CODEGEN_FILENAME>UnitTestEnvironment.dbl</CODEGEN_FILENAME>
<REQUIRES_USERTOKEN>SERVICES_NAMESPACE</REQUIRES_USERTOKEN>
;//****************************************************************************
;//
;// Title:       ODataUnitTestEnvironment.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Generates a class that configures an environment in which unit
;//              tests can operate with a known initial data state.
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
;; Title:       UnitTestEnvironment.dbl
;;
;; Type:        Class
;;
;; Description: Configures an environment in which unit tests can operate
;;              with a known initial data state.
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

import Microsoft.AspNetCore
import Microsoft.AspNetCore.Hosting
import Microsoft.AspNetCore.TestHost
import Microsoft.VisualStudio.TestTools.UnitTesting
import System.Collections.Generic
import System.IO
import System.Text
import <SERVICES_NAMESPACE>

main UnitTestEnvironment
proc
	;For debugging!

	UnitTestEnvironment.AssemblyInitialize(^null)

	;data tester = new CustomerTests()
	;tester.GetAllCustomers()

	WebHost.CreateDefaultBuilder(new string[0]).UseStartup<Startup>().Build().Run()

	UnitTestEnvironment.AssemblyCleanup()

endmain

namespace <NAMESPACE>

	{TestClass}
	public class UnitTestEnvironment

		public static Server, @TestServer 

		{AssemblyInitialize}
		public static method AssemblyInitialize, void
			required in context, @TestContext
		proc
			Encoding.RegisterProvider(CodePagesEncodingProvider.Instance)

			;;Set the logical names that will be used to access the data files
			TestEnvironment.SetLogicals()

			;;Make sure the files don't already exist
			TestEnvironment.DeleteFiles()

			;;Create the data files
			TestEnvironment.CreateFiles()

			;;Create a TestServer to host the Web API services
			Server = new TestServer(new WebHostBuilder().UseStartup<Startup>())

		endmethod

		{AssemblyCleanup}
		public static method AssemblyCleanup, void
		proc
			;;Clean up the test host
			Server.Dispose()
			Server = ^null

			;;Delete the data files
			TestEnvironment.DeleteFiles()

		endmethod

	endclass

endnamespace
