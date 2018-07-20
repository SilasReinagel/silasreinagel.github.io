---
layout: post
title: Your Configs Are Totally Wrong
date: 2018-02-27 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/pile-of-tech.jpg
---

One of the major pain points in working with Enterprise software is dealing with config files. They don't have to be a pain. But everyone is doing them absolutely wrong. 

---

### A Terrible Config

You've seen the giant files with numerous fragile and frequently changed values. They look something like this:

<img src="/images/pile-of-tech.jpg" alt="Pile of Tech Waste" width="625" height="357" class="aligncenter size-large" />

```
<configuration>
  <configSections>
	... Lots of stuff...
  </configSections>
  <connectionStrings>
	... Lots of stuff...
  </connectionStrings>
  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.6" />
  </startup>
  <appSettings
    ... Lots ...
    ... and Lots ...
    ... and Lots ...
    ... of Stuff ...	
  </appSettings>
  <log4net>
	... Tons of logging configuration. Gotta output those strings correctly...
  </log4net>
  <system.serviceModel>
    <bindings>
      <basicHttpBinding>
		... Lots of stuff...
      </basicHttpBinding>
      <netTcpBinding>
		... More stuff...
      </netTcpBinding>
      <netTcpRelayBinding>
		... More configuration and settings of the stuff above...
      </netTcpRelayBinding>
    </bindings>
    <client>
		... Guess what I found here? ...
    </client>
    <behaviors>
      <endpointBehaviors>
		... More stuff ...
      </endpointBehaviors>
    </behaviors>
    <extensions>
		... Yet more tons of stuff ...
    </extensions>
  </system.serviceModel>
  ... Some custom sections with extra stuff ...
  <runtime>
	... Magical dependency bindings that aren't handled by the actual project...
  </runtime>
  <entityFramework>
    <defaultConnectionFactory type="System.Data.Entity.Infrastructure.LocalDbConnectionFactory, EntityFramework">
      <parameters>
        <parameter value="mssqllocaldb" />
      </parameters>
    </defaultConnectionFactory>
    <providers>
      <provider invariantName="System.Data.SqlClient" type="System.Data.Entity.SqlServer.SqlProviderServices, EntityFramework.SqlServer" />
    </providers>
  </entityFramework>
</configuration>
```

This is completely wrong! Totally wrong! I'll tell you the reasons why in a minute. 

---

### A Good Config

```
<configuration>  
  <connectionStrings>    
	<add name="SourceOfTruthDatabase" connectionString="Server=myServerAddress;Database=myDataBase;User Id=myUsername;Password=myPassword;" />
  </connectionStrings>
</configuration>
```

**Your configuration should have just one piece of information.** Maybe two, if the first piece of information is encrypted. If it needs anything more, then there is something seriously wrong with the libraries/frameworks you are using, or you are misusing configuration files. 

A configuration file has exactly one purpose. **It exists to supply the information that cannot be known by your application at compile time, and cannot be acquired after launch.** If something is known before compilation, then it should be compiled into the application. If something changes while the application is running or is chosen by a user, then it should be supplied as a runtime dependency. What information falls outside of those two types of information? The one piece of data that you need to get access to the remainder of that information, the data source.

Therefore, your configuration should contain just the means to connect your application to its source of data, and nothing else. **Everything else should be compiled into the application or provided by the source of data.**

That's it. If the above makes sense to you, then don't read anything further. 

<img src="/images/ethernet-cable.jpg" alt="Single Ethernet Cable" width="625" height="357" class="aligncenter size-large" />

---

## Why you should NOT put anything else in the config files

---

### 1. Only code and build tooling should live in source control

Source control should manage the source code of your application. Source control should know nothing about your deployment environment. Open source developers know this fact intimately, since it's a major security risk to ever put a piece of information about their environment in their repositories. The same principle is applicable to closed-source development.

---

### 2. Settings change for different reasons than the software

The source code for an application typically changes as features are added/removed/changed. This work is done by developers. Business people care about A/B tests, feature flags, and the impact to the bottom line. Operations people care about changing connection strings, credentials, encryption certificates, and deployment templates. Since these change for different reasons, there should be no need to go through the development pipeline to make these non-software changes. 

---

### 3. Minimize the impact of outages

Your system should be setup so that outages in any environment can be addressed rapidly. Switching to an alternative service instance or database server must be quick and painless. It shouldn't necessitate going through the entire development pipeline. The ideal is to change a single value in your deployment environment and reboot the application instances. 

---

### 4. Merge detection does not work well with many configs

This is one of my personal reasons for hating Enterprise configs. Merge tools often cannot correctly determine what constitutes a changed config section, and so it detects many more merge collisions than actually exist. When you have 6+ config transforms, this is a huge time sink. It costs the business piles of money, and significantly hurts developer morale. 

---

### 5. Compliance/auditing/traceability

The risk of changing configuration values, connections, certificates, credentials and so forth is a very different kind of risk than the risk of changing the behavior of the software. If your company follows proper change control procedures, then software changes must be tracked and approved. By having the added noise of source code changes for non-behavior changes, and the hidden coupling of changing behavior and operations integrations simultaneously, change control is diluted substantially. 

---

I definitely encourage you to make your applications configurable. It should be easy for each stakeholder and user to easily change the things that are important to them. Just don't put any of those in the config files. Your config file should only provide your application with something it couldn't know before compile time and can't get after launching. 

Save yourself a lot of pain and your company a lot of money. 

**Your config file should contain exactly one piece of data.**
