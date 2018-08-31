---
layout: post
title: Factory Objects
date: 2018-08-31 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/factory-isometric.jpg
---

If you're familiar with software design patterns, you've probably encountered Factory Methods, Factory Classes, Abstract Factories and other creational patterns that are used to encapsulate details of the construction of a polymorphic object. All of these patterns are great, and solve very specific problems, but one of the flaws is that they always add indirection between you and the object that you actually want to use. I would like to introduce you to Factory Objects, which eliminates indirection completely.

<img src="/images/factory-isometric.jpg" alt="Cartoon-style factory exterior, with a delivery truck in front, loading up boxes of fresh goods."  />

One thing that makes code much easier to use and understand is [cutting out the middleman](/blog/2017/06/27/cut-out-the-middleman/). Recently, I was working with a business model where I noticed the same ternary operator used to instantiate the correct instance in a number of places in the midst of some procedures. 

```
... Some procedure steps ...

var earliest = maybeFixedTime.HasValue 
    ? new FixedEarliestStartDateTime(UnixUtcTime.From(maybeFixedTime.Value), localNow.TimeZone)
    : new ComputedEarliestStartDateTime(localNow, hoursInTransit)

... More procedure steps ...



// For Reference

public interface IEarliestCustomerScheduleDateTime
{
    LocalizedDateTime Value { get; }
}

public struct ComputedEarliestStartDateTime : IEarliestCustomerScheduleDateTime
{
    ...

    public ComputedEarliestStartDateTime(LocalizedDateTime currentLocalTime, int hoursInTransit) { ... }
}

public struct FixedEarliestStartDateTime : IEarliestCustomerScheduleDateTime
{
    public LocalizedDateTime Value { get; }

    public FixedEarliestStartDateTime(UnixUtcTime utcTime, TimeZone timeZone) =>
        Value = new LocalizedDateTime(utcTime, timeZone);
}
```

---- 

### Conventional Solutions

----

**Any time you see the same data manipulation happening in multiple different places using the exact same values, it's a clear indication that there is an undiscovered Object or Function.** It can be a maintenance nightmare, especially if there are a large number of places that include the same logic and manipulation. It's very easy to change just one of the places, and not the others. The conventional solution would be to create a factory method or a factory class to encapsulate the correct subtype selection.

**Factory Class**

```
var factory = new EarliestScheduleDateTimeFactory();
var earliest = factory.Create(maybeFixedTime, localNow, hoursInTransit);
```

**Factory Method**

```
var earliest = EarliestScheduleDateTimeFactory.Create(maybeFixedTime, localNow, hoursInTransit);
```

----

### Elegant Solution

----

In order to remove the indirection and encapsulate the decision-making inside an object, we can create a Factory Object who **both constructs and behaves as the Object that is needed** in the algorithm. 

```
var earliest = new EarliestStartDateTime(maybeFixedTime, localNow, hoursInTransit);
```

This is his implementation, nearly as [elegant](https://www.elegantobjects.org/) as can be:

```
public struct EarliestStartDateTime : IEarliestCustomerScheduleDateTime
{
    private readonly IEarliestCustomerScheduleDateTime _inner;

    public LocalizedDateTime Value => _inner.Value;
    
    public EarliestStartDateTime(DateTime? maybeFixedTime, LocalizedDateTime now, int hoursInTransit)
        : this(maybeFixedTime.HasValue 
            ? new FixedEarliestStartDateTime(UnixUtcTime.From(maybeFixedTime.Value), now.TimeZone.Id)
            : (IEarliestCustomerScheduleDateTime)new ComputedEarliestStartDateTime(now, hoursInTransit)) { }
    
    private EarliestStartDateTime(IEarliestCustomerScheduleDateTime inner) => _inner = inner;
}
```

His qualities:
1. Immutable
2. Every public member implements an interface method
3. He exposes only a single public member
4. Has only one primary constructor
