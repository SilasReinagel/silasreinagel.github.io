---
layout: post
title: You Must Not Admit a Single Null!
date: 2018-07-02 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/Biohazard.jpg
---

There are some principles in software development that offer benefits anywhere they are used, even in just some parts of the code. For others, they must be applied everywhere to be useful. The rule against never passing null must be applied everywhere for one major reason. 

<img src="http://silasreinagel.com/wp-content/uploads/2018/07/Biohazard.jpg" alt="Biohazard substance" width="700" height="400" class="aligncenter size-full wp-image-384" />

Most programmers generally know about the [problems](https://www.yegor256.com/2014/05/13/why-null-is-bad.html) [with](http://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare) [null](https://sidburn.github.io/blog/2016/03/20/null-is-evil). But many still think, *"I can be generally against null, and still make some exceptions here and there."* 

**For nulls, this thinking is entirely wrong!**

With many of the principles of SOLID, Clean Code, and Elegant Objects, the benefits can be gained even if only a portion of the codebase uses it. If some methods are readable, and others aren't, the codebase won't naturally become more unreadable. If some classes are designed to handle only one use case, and some classes are giant classes of death, the codebase won't necessarily trend towards large uncohesive classes. However, with null, **it is a cancer that spreads** to surrounding areas and starts to infect the whole codebase.

The reason is trust. **Once trust is gone, the codebase begins to take another shape entirely.**

----

### Objects should Trust other Objects

----

Once the codebase starts accepting nulls, then as the team writes new classes and Objects, they no longer trust that they will receive valid, fully-formed Objects. This ruins developer trust in the codebase, and leads to defensive programming styles, which are wasteful and verbose. Then you will find null checks and null-coalescing operators start to appear in every constructor. The developers don't trust the other developers, and so the Objects stop trusting other Objects. 

The second problem is what allowing nulls into the code communicates. It starts with passing just a single optional parameter using null. Developers will think this is the correct pattern to emulate. Then you will find many classes in your codebase with ctors like this: 

```
public ContractsController() : this(null, null, null, null, null, null, null) {}
```

I haven't found similar statistics for C# applications, but in Java land, the most frequent cause of Application crashes is still [NullPointerExceptions](https://blog.samebug.io/which-java-exceptions-are-the-most-frequent-f830b113c37f). 

----

### How To Supply Defaults Without Null

----

Recently, I received a PR with a test that looked like this:

```
[TestMethod]
public void Shipment_EarliestStartDateTime_IsAsOfDateWhenEarliestBeforeAsOf()
{
    var now = Clock.UnixUtcNow;
    var earliest = Clock.UnixUtcNow.Minus(2.Days());
    
    var shipment = new Shipment(now, earliest, null, null);
    
    Assert.AreEqual(now, shipment.EarliestStartDateTime);
}
```

This is a fairly clean test. However, the Shipment is being constructed with 2 nulls. That immediately raises a big red flag!

There are a few test design problems here:
1. From reading the test, it's impossible to determine the type of the third and fourth arguments
2. The test knows too much about the implementation of the Object under test, since it knows that null is an acceptable value
3. For the next developer who reads the tests as documentation on the Object, he will rightly assume that this is a null-friendly Object

As expected, the ctor for the Object looked like this:

```
public Shipment(UnixUtcTime asOf, UnixUtcTime earliest, 
    IEnumerable<UnixUtcTime> blockedTimes, Product product)
{
    BlockedTimes = blockedTimes ?? new List<UnixUtcTime>();
    Product = product ?? new Product("None");
    EarliestStartDateTime = earliest < asOf
        ? asOf
        : earliest;
}
```

Providing defaults is fine, but it's better to provide a clear contract that defines what is required and what is optional. Using secondary ctors is a perfect way to express an Object's requirements:

```
public Shipment(UnixUtcTime asOf, UnixUtcTime earliest)
    : this (asOf, earliest, new List<UnixUtcTime>(), new Product("None")) { }
        
public Shipment(UnixUtcTime asOf, UnixUtcTime earliest, 
    IEnumerable<UnixUtcTime> blockedTimes, Product product)
{
    BlockedTimes = blockedTimes;
    Product = product;
    EarliestStartDateTime = earliest < asOf
        ? asOf
        : earliest;
}
```

This is the correct way to provide sensible defaults to an Object. 

----

**Teach your Objects not to accept a single null value!** 

Let your Objects trust their collaborators, rather than forcing them to be paranoid about every argument. 

