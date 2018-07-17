---
layout: post
title: Marker Interfaces Are Evil
date: 2018-04-24 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/note-on-shirt.jpg
---

Have you seen interfaces which have no methods in a project you were working on? Every time you see one of those, it should raise a mental red flag. Marker interfaces are a terrible design choice! I will explain why and what to do instead.

<div class="container"><img src="/images/note-on-shirt.jpg" alt="Note taped to back of man&#039;s shirt that reads &quot;Kick Me&quot;" width="700" height="400"/></div>

----

### 1) Marker interfaces conceal, rather than reveal intent

When someone new to a codebase looks at an empty interface, he will always be puzzled. 

```
public interface ILoginViewModel 
{
}
```

Does this mean that nothing is displayed for the LoginView? No, it just means the data and/or behavior is hidden somewhere instead of revealed. The number one most important quality of team code is Understandability. Code that hides its intent is not understandable. You just forced the next programmer to do a bit of detective work to discover how this interface works.

### What to do instead? 
Include in your interface all of the functionality that an object provides. **Don't leave any detail out.**

----

### 2) Marker interfaces require further coding evil

Every time a marker interface is used, it is always paired with at least one more terrible design choice.

Maybe there will be some type-checking and casting involved. 

```
private void LogRequest(IRequest request)
{
    if (request is PlaceOrderRequest)
    {
        var placeOrderRequest = (PlaceOrderRequest)request;
        Log.Info(... log some properties ...);
    }
}
```

Maybe it will involve reflection scanning your assemblies and auto-magically wiring some stuff up. 

```
private void AutowireNotificationsType(IServiceCollection services)
{
    services.Scan(scan => scan
        .FromAssembliesOf(typeof(MyNotificationAssembly))
        .AddClasses(classes => classes.AssignableTo(typeof(INotification)))
        .AsImplementedInterfaces()
        .WithScopedLifetime();
}
```

Maybe it will be some other problematic design. 

Sometimes in programming, it makes sense to write one piece of quick and dirty code in order to deliver business value sooner. But if one choice leads to another terrible design choice, then that path is too costly. It will damage your system a LOT. 

### What to do instead? 
The moment you realize that one bad design decision will lead to another, **find a different design immediately.** This is the moment where you can save or doom your system, perhaps permanently. 

----

### 3) Marker interfaces make integrations/disentanglements harder

Libraries and frameworks that utilize Marker Interfaces tend to require you to include them all over your codebase. You'll take a nice clean data structure and then find yourself adding any number of Marker Interfaces implementations, which will change as you add/remove integrations.

```
public sealed class ServerDownNotification : IBinarySerializable, 
    INotification, IShouldBeRegisteredOnStartup, ILikeToLiveInDatabases
{
    public string Title => "Server Went Down"
    public string Detail { get; set; }
}
```

When you have a lot of classes who need markers, it becomes very tedious to add/remove or find classes who are missing a marker interface that they needed. Sometimes old marker interfaces are left cluttering up the codebase even after their reason for being added is gone. 

#### What to do instead? 
**Don't use invasive libraries or frameworks** that require you to use Marker Interfaces. Find or create alternatives. 

----

### 4) Marker interfaces provide a false sense of type-system safety

In a project I was working on, my team would add a unique marker interface to each View Model data structure that we stored in MongoDB. Then, when they were later read by another application, the factory seemed to imply a very type-safe design:

```
var repository = new RepositoryFactory<FinanceDealsViewModel>().Create();
```

But, it was all a lie. What was written to Mongo was always `object` and what was read was always `dynamic`. The Marker Interface? That was simply stringified and used as the Collection Name. There was no real type safety at all. **Since a marker interface is a contract who requires no behavior, he can never provide type-safety.** He can be added or removed from any object without changing the apparent behavior of the system. This makes type errors HARDER to catch, not easier. We experienced a LOT of hard to discover bugs because of this very design choice. 

### What to do instead?
If the operations you are performing can be performed on `object` then don't use interfaces. **Just send/receive `object.`**

----

<div class="container"><img src="/images/mired.jpg" alt="Struggling Man Bogged Down In Quicksand" width="700" height="400" /></div>

### Marker interfaces are evil. 

- They significantly harm the understandability and maintainability of your code 
- They hide the real behaviors of your system
- They always take you deeper than you planned to go, by requiring further terrible design choices. 
- They clutter your code and increase the cost of integrations or disentanglements. 
- They provide a false sense of type-safety while ensuring that you experience elusive bugs. 

Don't use them! Don't use libraries that use them! 
