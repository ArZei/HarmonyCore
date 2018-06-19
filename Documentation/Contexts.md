# Contexts
With synergy applications of any significant size and complexity, developers generally find it necessary to manage the lifetimes of non-memory resources. For maximum performance with Synergy data files, this means you should minimize opening and closing of these files. And for SQL Connection, it's better to reuse channels than reopen them. 

### Channel Basics
In the most basic case, you can just use a [file channel pool](Reference/IFileChannelManager.md) for Synergy data files. This takes care of opening a file channel in a given mode for a given filename. If a channel that matches the given parameters is available, it will be used. Otherwise, the channel pool will make a call to [OPEN](http://docs.synergyde.com/#lrm/lrmChap4OPEN.htm). When you are finished with a channel, you simply call `ReturnChannel` to put it back into the pool for the next request.

### Basic State
In addition to managing channels for Synergy data files, you might have other non-trivial setup that needs to be carried out prior to processing requests. This could involve reading configuration data or opening SQL Connection channels. If the resulting state can be placed into an object that implements [IContextBase](Reference/IContextBase.md), the library can pool it using a [free threaded context pool](Reference/FreeThreadedContextPool.md). This allows the state object to be created and initialized as needed and reused by later requests rather than being thrown away. If you need these state objects to be created per user session, you should also implement [ISessionStickyContext and ITimeoutContext](Reference/StickyContext.md). With this, your state object will stick with requests made by the same user when passed the same [cookie](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/app-state). `ITimeoutContext` is needed because HTTP(S) is a stateless protocol and a user can disappear at any time. With an `ITimeoutContext`, you can control how long you want the session to stay alive between requests.

### xfServer
If there isn't a significant load on your server, it's possible to use xfServer with a simple file channel pool (described above). However, if you need additional scaling beyond a single connection to xfServer, you will need to make a call to [s_server_thread_init](http://docs.synergyde.com/#lrm/lrmChap9SSERVERTHREADINIT.htm). Once you have called `s_server_thread_init`, channel management becomes significantly more complex. Channels opened on a given thread must only be used from that thread. This leads to the next evolution of the file channel pool: simply make a separate channel for each thread. Unfortunately, in most environments we aren't really in control of which thread the library is called on when asked to process a request. The library needs to be able to call `s_server_thread_shutdown` if the thread is being shut down, but the library doesn't control the lifetime of those threads. This is where a [threaded context pool](Reference/ThreadedContextPool.md) is useful. Rather than relying on ASP<span></span>.NET Core to choose which thread we should process our request on, we can force requests to be processed on a thread controlled by our context pool. Calling `IApplicationBuilder.UseEagerContext<MyContextTypeName>` with an instance of a `ThreadedContextPool` will take advantage of ASP<span></span>.NET Core middleware to ensure that if a controller has a dependency on a class that extends `ThreadedContextBase`, our request will be handled on a thread owned by the `ThreadedContextPool`. If configured, threads created by `ThreadedContextPool` will be called by `s_server_thread_init` and `s_server_thread_shutdown` when necessary. With this, you can make use of a per-thread `IFileChannelManager` without worrying about getting threads mixed up.

### Isolation
Using global data sections, commons, static records, static class fields, or hard-coded channel numbers results in code that cannot be run on multiple threads at the same time. Multi-threading is an important part of achieving reasonable scalability in ASP<span></span>.NET Core, so handling non-thread-safe code is equally as important. In the full .NET Framework, we can use an [AppDomain](https://msdn.microsoft.com/en-us/library/system.appdomain) to isolate running code from almost all side effects that might be caused by other running `AppDomains`. However, this will not isolate environment variable changes made within a process. In order to make `AppDomain` isolation simple and performant, you can use [AppDomainContextPool](Reference/AppDomainContextPool.md) to managed your context class that extends `AppDomainContextBase`. The way the isolation works, you can call your existing non-thread-safe code within your context class as though it were the only code running in the process. Consumers of your context class will get an instance from the `AppDomainContextPool` and interact with it as though the underlying code were actually thread-safe. An `AppDomain` can be created or unloaded on demand. Using an `AppDomain` within a non UI-application will result in taking an additional Synergy Runtime license.

.NET Core adds some additional complexity to isolation. `AppDomain` exists in .NET Core, but for the purpose of code isolation, it is non-functional. The recommended path is to use [AssemblyLoadContext](https://github.com/dotnet/coreclr/blob/master/Documentation/design-docs/assemblyloadcontext.md) instead. Unfortunately, `AssemblyLoadContext` doesn't exist in the full .NET Framework as of 4.7.2, so this solution is specific to .NET Core. There is currently one additional limitation: it is not possible to unload an `AssemblyLoadContext`, making it a requirement to pool and reuse them. There are some upsides to `AssemblyLoadContext`, it is significantly more lightweight and poses no performance cost when making calls from code running in one context to another. There is no marshaling of arguments and much less memory is taken up by a running `AssemblyLoadContext`. 

### Traditional Synergy
If you have logic written in traditional Synergy but one of the following conditions exits, you can make use of [IDynamicCallProvider](Reference/DynamicCallProvider.md) to invoke that logic, passing arguments and returning data.
* It cannot be compiled with Synergy .NET
* It must run on OpenVMS
* It must run on a remote system
* It must run in a separate process

As with most of the other concepts in this library, we can pool these using either `RemoteExternalContextPool` or `ProcessExternalContextPool`, depending on if we are communicating over SSH to a remote machine or creating a process locally. Because this scenario potentially involves multiple machines and at least separate processes, things can get more difficult to follow. 

For a local process, the flow is relatively straightforward. The TraditionalBridge project offers all of the generic support functionality that is needed: logging, JSON parsing, JSON writing, and basic routine dispatching. The code you want to run can be exposed one of two ways:
* If you have [xfServer+ routine attributes](http://docs.synergyde.com/index.htm#xfnl/xfnlChap2Usingattributestodefinesynergymethods.htm) or a [method catalog](http://docs.synergyde.com/index.htm#xfnl/xfnlChap2Smcoverview.htm), you can generate strongly-typed dispatch stubs with CodeGen. This is the most performant, featured, and ultimately reliable method of dispatching routines. 
* If you can't use CodeGen to create dispatch stubs, the generic routine dispatcher will do its best to map the arguments you pass to a function, subroutine or method with the following caveats: structures and class arguments must be wrapped by or derived from [DataObjectBase](DataObject.md), and arrays can only be passed as an [ArrayList](http://docs.synergyde.com/index.htm#lrm/lrmChap10SYSTEMCOLLECTIONSARRAYLIST.htm) that can contain only classes derived from `DataObjectBase` or primitives like string, a, d, and i. 

Compile your code into a DBR and add a reference to the TraditionalBridge project. The mainline of your DBR needs to look something like the following, where `MyDispatcher` is a class that you've code generated from a combination of repository structures and potentially xfServerPlus method catalog data:

```
main
	record
		dispatcher, @MyDispatcher
		ttChan, i4, 0
		jsonReader, @Json.Json
		jsonVal, @Json.JsonValue
proc
	xcall flags(0101010010)
	open(ttChan, O, "TT:")
	puts(ttChan, "READY" + %char(13)+ %char(10))
	dispatcher = new MyDispatcher()
	dispatcher.Dispatch(ttChan)
endmain
```

`ProcessExternalContextPool` will take care of creating, initializing, recycling, and destroying the spawned DBRs that will execute your logic. Spawned processes will each take a Synergy Runtime license, and it will be executed as the same user as the running web server.

For remote processes, the flow is identical once the remote process is started. But first we must make a connection and do any authentication. There are several possible security flows:

* A preconfigured username/password is stored in configuration data. (NOTE: This is insecure and is recommended only for development scenarios.)
* A preconfigured username/password is stored in a secure configuration store such as [app-secrets](https://docs.microsoft.com/en-us/aspnet/core/security/app-secrets?tabs=visual-studio) or [key-vault](https://azure.microsoft.com/en-us/services/key-vault/).
* SSH Private keys are stored in a secure configuration store, as described above.
* In a web service that is authenticated against an Azure Active Directory or Active Directory server, it is possible to pass the authentication token through the web service using JWT. When the request is made to create a process, the JWT from the request can be used to acquire AltSecurityIdentities from the AD account. These security credentials are then used to log into SSH and create the target process. This security flow generally precludes the use of a pool of pre-created processes/connections. Processes can be left running (and reused by the same user) for a predetermined amount of time. But because they cannot be shared or pre-created, this may negatively affect performance.

In any case, your interaction point with the library will be a [PasswordAuthenticationMethod or PrivateKeyAuthenticationMethod](https://github.com/sshnet/SSH.NET#multi-factor-authentication) passed to the constructor of your `RemoteExternalContextPool`. Once you're connected, the library runs the supplied command line remotely. This command line can do whatever environment setup is needed but should result in running `dbr` or `dbs` against the DBR you created earlier.
