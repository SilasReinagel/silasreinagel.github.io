---
layout: post
title: The New Rule of New - Internal Objects
date: 2016-10-26 17:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/new-tag.jpg
---

One of the challenges in Object-Oriented Design is figuring out exactly when and where objects should be instantiated. Where is the best place to create a new instance of an object? Where is it critically important not to create new object instances? When should you return a new copy of an object, rather than an existing instance? What are the competing code attributes that must be balanced against each other?

Rather than walking through the process of discovery sequentially and then arriving at a conclusion, I am going to present the conclusion up front:

----

### The New Rule of New

----

1. Instances may be created anywhere internally, as long as they are perfectly encapsulated implementation details
2. Instances may be created to be returned, as long as they are immediately forgotten
3. Default instances may be created in secondary constructors

----

Now that this heuristic has been stated, let us see why this rule is important, what problems it solves, and how it shapes your code. 

----

### Dependency Inversion Principle (DIP)

----

The Dependency Inversion Principle, one of the well-known SOLID principles, states:

1. High-level modules should not depend on low-level modules. Both should depend on abstractions.
2. Abstractions should not depend on details. Details should depend on abstractions.

----

This post isn't about the proper scope of DIP and how it can be used to solve problems of excessive coupling, program rigidity, or also be mistakenly used to make programs needlessly complex by creating too many factories. Instead, we are interested in how to create flexible, decoupled objects. The most important element that sheds light on how and when to create instances is the idea that high-level policy should not be coupled to implementation details.

Consider the following code:

```
public class Users
{
    private IUserRepository repository;
	
    public Users()
    {
        this.repository = new LevelDbUserRepository();
    }
}
```

This class violates both the Dependency Inversion Principle and the New Rule of New. It violates DIP because the business concepts of `Users` is directly coupled to the use of the `LevelDb` implementation. This ensures that `Users` isn't testable without a real database, it isn't unit testable at all, and it isn't flexible enough to allow developers to switch to another datasource. This violates the first part of the New Rule of New, since the `LevelDbUserRepository` is not perfectly encapsulated within `Users`. This encapsulation is broken since the database exists even when the program is not running, and external changes to the database will impact the behavior of the `Users` object.

How can we change `Users` to make it conform to DIP and the New Rule of New? 

```
public class Users
{
    private IUserRepository repository;
	
    public Users(IUserRepository repository)
    {
        this.repository = repository;
    }
}
```


The Old Rule of New solves most of the same issues. I quote from Yegor Bugayenko's seminal book Elegant Objects, Vol 1:

----

### The Old Rule of New

----

<i>I suggest a simple rule that will ensure good design on all your objects: don't use "new" anywhere except in secondary constructors.... If you entirely prohibit yourself from using "new" anywhere else, your objects will be fully decoupled from each other, and their testability and maintainability will be much higher.</i>

----

This rule is genuinely excellent. If you follow this simple rule, your resulting designs will be highly decoupled, highly testable, while offering greater ease of use. 

Following Yegor's rule, it would be entirely reasonable to offer a secondary constructor with the ease of use afforded by the original design of `Users`, while maintaining the testability and flexibility of following the DIP (almost completely).

```
public class Users
{
    private IUserRepository repository;
	
    public Users()
    {
        this(new LevelDbUserRepository());
    }
	
    public Users(IUserRepository repository)
    {
        this.repository = repository;
    }
}
```

There is a small trade-off here. Since this source file directly references the module in which `LevelDbUserRepository` resides, if `LevelDb` is ever removed from the project or a different default is used, all clients of the `Users` class will need to be recompiled and redeployed. 

However, if the database isn't changed, this class is much easier to use and construct. This is a nicer design for small projects, APIs, and shared libraries. Most developers aren't going to be plugging in non-defaults. This reduces the cognitive overhead for them. Both the Old Rule of New, and the New Rule of New allow for this secondary convenience constructor. In larger projects

----

Let's take a look at another scenario, with an in-memory service health collection object.

```
public class ActiveServices
{
    private ExpiringSet<ServiceCheckIn> checkins = new ExpiringSet<>(Duration.ofDays(7));
    private ExpiringSet<ServiceHealth> healths = new ExpiringSet<>(Duration.ofDays(7));
	
	...
}
```

There are two things going on here that we need to look at. First, we have a DIP violation, since the business rule of "Only services active within the past 7 days should be kept in memory" is directly coupled to the tracking of services. Second, we are directly instantiating a new `ExpiringSet` instance, and it is not happening in a secondary constructor. Is this a problem? Is there a better design? Let's try some alternatives.

```
public class ActiveServices
{
    private Set<ServiceCheckIn> checkins;
    private Set<ServiceHealth> healths;
	
    public ActiveServices(Set<ServiceCheckIn> checkins, Set<ServiceHealth> healths)
    {
        this.checkins = checkins;
        this.healths = healths;
    }
}
```

This now conforms to DIP as well as the Old Rule of New. Any sort of `Set` can be plugged in and used. However, this moves the business logic of active service expiration times somewhere else in the application. Also, this forces users of `ActiveServices` to know that a `Set` or something like a `Set` is used internally for tracking state -- the constructor seems to violate encapsulation by exposing so much of the implementation details. It also permits the introduction of contaminated state. This doesn't feel like a very good solution.

```
public class ActiveServices
{
    private ExpiringSet<ServiceCheckIn> checkins;
    private ExpiringSet<ServiceHealth> healths;
	
    public ActiveServices(Duration timeBeforeInactive)
    {
        this(new ExpiringSet<>(timeBeforeInactive), new ExpiringSet<>(timeBeforeInactive));
    }
	
    public ActiveServices(ExpiringSet<ServiceCheckIn> activeService, ExpiringSet<ServiceHealth> healths)
    {
        this.checkins = checkins;
        this.healths = healths;
    }
}
```

This is somewhat better. The most user-friendly secondary constructor now expresses the business rule and allows it to be easily modified. `ActiveServices` is now capable of constructing his own internal collection objects using that same constructor. The only potential issue is that there appear to be two different public constructors, while users and unit tests only need one of them. We can remedy that issue by making the primary constructor private.

```
public class ActiveServices
{
    private ExpiringSet<ServiceCheckIn> checkins;
    private ExpiringSet<ServiceHealth> healths;
	
    public ActiveServices(Duration timeBeforeInactive)
    {
        this(new ExpiringSet<>(timeBeforeInactive), new ExpiringSet<>(timeBeforeInactive));
    }
	
    private ActiveServices(ExpiringSet<ServiceCheckIn> activeService, ExpiringSet<ServiceHealth> healths)
    {
        this.checkins = checkins;
        this.healths = healths;
    }
}
```

This class now conforms to DIP and the Old Rule of New. However, it feels a bit wasteful to have a secondary constructor solely for the purpose being able to instantiate the `ExpiringSets` (no "new" outside of secondary constructors). We have gained testability, duration decoupling, and fully encapsulated internal fields. It came at the cost of an extra constructor and a few more lines of source code. Not bad, but I think we can do better. Let's apply the New Rule of New instead of the Old Rule of New.

```
public class ActiveServices
{
    private ExpiringSet<ServiceCheckIn> checkins;
    private ExpiringSet<ServiceHealth> healths;
	
    public ActiveServices(Duration timeBeforeInactive)
    {
        this.checkins = new ExpiringSet<>(timeBeforeInactive);
        this.healths = new ExpiringSet<>(timeBeforeInactive);
    }
}
```

This now looks extremely elegant. It offers us loose coupling, no direct dependence on the precise business rule, implementation detail encapsulation, and a highly usable constructor, while not being particularly verbose (at least for Java). It provides precisely the same functionality as the previous version, except by using the New Rule of New instead of the Old Rule of New, we reduce the class complexity slightly, without losing any desired attributes. 

One of the main differences between the Old Rule of New and the New Rule of New is that the new rule allows for instantiating purely internal objects whenever needed. Objects should not be instantiated internally if they connect to resources external to a program, or make it difficult to change business logic. Those should always be injected. They may be injected in a secondary constructor, but never in the primary constructor.

----

So far, I have postulated my heuristic for when and where to instantiate instances of objects in accordance with OO best practices. We journeyed through some code and looked at how to balance various code concerns. We also compared the New Rule of New with the Old Rule of New. In my next post, I will discuss the value and importance of the 2nd part of the New Rule of New: Instances may be created to be returned immediately, as long as they are immediately forgotten. 
