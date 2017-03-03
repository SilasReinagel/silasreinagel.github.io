---
layout: post
title: The New Rule of New - Internal Objects
date: 2016-10-26 17:00
author: silas.reinagel@gmail.com
comments: true
categories: [Object Oriented Design, Object Thinking, Software Engineering]
---
One of the challenges in Object-Oriented Design is figuring out exactly when and where objects should be instantiated. Where is the best place to create a new instance of an object? Where is it critically important not to create new object instances? When should you return a new copy of an object, rather than an existing instance? What are the competing code attributes that must be balanced against each other?

Rather than walking through the process of discovery sequentially and then arriving at a conclusion, I am going to present the conclusion up front:

<hr />

<h3>The New Rule of New</h3>

<hr />

<ol>
<li>Instances may be created anywhere internally, as long as they are perfectly encapsulated implementation details</li>
<li>Instances may be created to be returned, as long as they are immediately forgotten</li>
<li>Default instances may be created in secondary constructors</li>
</ol>

<hr />

Now that this heuristic has been stated, let us see why this rule is important, what problems it solves, and how it shapes your code.

<hr />

<h3>Dependency Inversion Principle (DIP)</h3>

<hr />

The Dependency Inversion Principle, one of the well-known SOLID principles, states:

<ol>
<li>High-level modules should not depend on low-level modules. Both should depend on abstractions.</li>
<li>Abstractions should not depend on details. Details should depend on abstractions.</li>
</ol>

<hr />

This post isn't about the proper scope of DIP and how it can be used to solve problems of excessive coupling, program rigidity, or also be mistakenly used to make programs needlessly complex by creating too many factories. Instead, we are interested in how to create flexible, decoupled objects. The most important element that sheds light on how and when to create instances is the idea that high-level policy should not be coupled to implementation details.

Consider the following code:

<pre><code>public class Users
{
    private IUserRepository repository;

    public Users()
    {
        this.repository = new LevelDbUserRepository();
    }
}
</code></pre>

This class violates both the Dependency Inversion Principle and the New Rule of New. It violates DIP because the business concepts of <code>Users</code> is directly coupled to the use of the <code>LevelDb</code> implementation. This ensures that <code>Users</code> isn't testable without a real database, it isn't unit testable at all, and it isn't flexible enough to allow developers to switch to another datasource. This violates the first part of the New Rule of New, since the <code>LevelDbUserRepository</code> is not perfectly encapsulated within <code>Users</code>. This encapsulation is broken since the database exists even when the program is not running, and external changes to the database will impact the behavior of the <code>Users</code> object.

How can we change <code>Users</code> to make it conform to DIP and the New Rule of New?

<pre><code>public class Users
{
    private IUserRepository repository;

    public Users(IUserRepository repository)
    {
        this.repository = repository;
    }
}
</code></pre>

The Old Rule of New solves most of the same issues. I quote from Yegor Bugayenko's seminal book Elegant Objects, Vol 1:

<hr />

<h3>The Old Rule of New</h3>

<hr />

<blockquote>I suggest a simple rule that will ensure good design on all your objects: don't use "new" anywhere except in secondary constructors.... If you entirely prohibit yourself from using "new" anywhere else, your objects will be fully decoupled from each other, and their testability and maintainability will be much higher.</blockquote>

<hr />

This rule is genuinely excellent. If you follow this simple rule, your resulting designs will be highly decoupled, highly testable, while offering greater ease of use.

Following Yegor's rule, it would be entirely reasonable to offer a secondary constructor with the ease of use afforded by the original design of <code>Users</code>, while maintaining the testability and flexibility of following the DIP (almost completely).

<pre><code>public class Users
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
</code></pre>

There is a small trade-off here. Since this source file directly references the module in which <code>LevelDbUserRepository</code> resides, if <code>LevelDb</code> is ever removed from the project or a different default is used, all clients of the <code>Users</code> class will need to be recompiled and redeployed.

However, if the database isn't changed, this class is much easier to use and construct. This is a nicer design for small projects, APIs, and shared libraries. Most developers aren't going to be plugging in non-defaults. This reduces the cognitive overhead for them. Both the Old Rule of New, and the New Rule of New allow for this secondary convenience constructor. In larger projects

<hr />

Let's take a look at another scenario, with an in-memory service health collection object.

<pre><code>public class ActiveServices
{
    private ExpiringSet&lt;ServiceCheckIn&gt; checkins = new ExpiringSet&lt;&gt;(Duration.ofDays(7));
    private ExpiringSet&lt;ServiceHealth&gt; healths = new ExpiringSet&lt;&gt;(Duration.ofDays(7));

    ...
}
</code></pre>

There are two things going on here that we need to look at. First, we have a DIP violation, since the business rule of "Only services active within the past 7 days should be kept in memory" is directly coupled to the tracking of services. Second, we are directly instantiating a new <code>ExpiringSet</code> instance, and it is not happening in a secondary constructor. Is this a problem? Is there a better design? Let's try some alternatives.

<pre><code>public class ActiveServices
{
    private Set&lt;ServiceCheckIn&gt; checkins;
    private Set&lt;ServiceHealth&gt; healths;

    public ActiveServices(Set&lt;ServiceCheckIn&gt; checkins, Set&lt;ServiceHealth&gt; healths)
    {
        this.checkins = checkins;
        this.healths = healths;
    }
}
</code></pre>

This now conforms to DIP as well as the Old Rule of New. Any sort of <code>Set</code> can be plugged in and used. However, this moves the business logic of active service expiration times somewhere else in the application. Also, this forces users of <code>ActiveServices</code> to know that a <code>Set</code> or something like a <code>Set</code> is used internally for tracking state -- the constructor seems to violate encapsulation by exposing so much of the implementation details. It also permits the introduction of contaminated state. This doesn't feel like a very good solution.

<pre><code>public class ActiveServices
{
    private ExpiringSet&lt;ServiceCheckIn&gt; checkins;
    private ExpiringSet&lt;ServiceHealth&gt; healths;

    public ActiveServices(Duration timeBeforeInactive)
    {
        this(new ExpiringSet&lt;&gt;(timeBeforeInactive), new ExpiringSet&lt;&gt;(timeBeforeInactive));
    }

    public ActiveServices(ExpiringSet&lt;ServiceCheckIn&gt; activeService, ExpiringSet&lt;ServiceHealth&gt; healths)
    {
        this.checkins = checkins;
        this.healths = healths;
    }
}
</code></pre>

This is somewhat better. The most user-friendly secondary constructor now expresses the business rule and allows it to be easily modified. <code>ActiveServices</code> is now capable of constructing his own internal collection objects using that same constructor. The only potential issue is that there appear to be two different public constructors, while users and unit tests only need one of them. We can remedy that issue by making the primary constructor private.

<pre><code>public class ActiveServices
{
    private ExpiringSet&lt;ServiceCheckIn&gt; checkins;
    private ExpiringSet&lt;ServiceHealth&gt; healths;

    public ActiveServices(Duration timeBeforeInactive)
    {
        this(new ExpiringSet&lt;&gt;(timeBeforeInactive), new ExpiringSet&lt;&gt;(timeBeforeInactive));
    }

    private ActiveServices(ExpiringSet&lt;ServiceCheckIn&gt; activeService, ExpiringSet&lt;ServiceHealth&gt; healths)
    {
        this.checkins = checkins;
        this.healths = healths;
    }
}
</code></pre>

This class now conforms to DIP and the Old Rule of New. However, it feels a bit wasteful to have a secondary constructor solely for the purpose being able to instantiate the <code>ExpiringSets</code> (no "new" outside of secondary constructors). We have gained testability, duration decoupling, and fully encapsulated internal fields. It came at the cost of an extra constructor and a few more lines of source code. Not bad, but I think we can do better. Let's apply the New Rule of New instead of the Old Rule of New.

<pre><code>public class ActiveServices
{
    private ExpiringSet&lt;ServiceCheckIn&gt; checkins;
    private ExpiringSet&lt;ServiceHealth&gt; healths;

    public ActiveServices(Duration timeBeforeInactive)
    {
        this.checkins = new ExpiringSet&lt;&gt;(timeBeforeInactive);
        this.healths = new ExpiringSet&lt;&gt;(timeBeforeInactive);
    }
}
</code></pre>

This now looks extremely elegant. It offers us loose coupling, no direct dependence on the precise business rule, implementation detail encapsulation, and a highly usable constructor, while not being particularly verbose (at least for Java). It provides precisely the same functionality as the previous version, except by using the New Rule of New instead of the Old Rule of New, we reduce the class complexity slightly, without losing any desired attributes.

One of the main differences between the Old Rule of New and the New Rule of New is that the new rule allows for instantiating purely internal objects whenever needed. Objects should not be instantiated internally if they connect to resources external to a program, or make it difficult to change business logic. Those should always be injected. They may be injected in a secondary constructor, but never in the primary constructor.

<hr />

So far, I have postulated my heuristic for when and where to instantiate instances of objects in accordance with OO best practices. We journeyed through some code and looked at how to balance various code concerns. We also compared the New Rule of New with the Old Rule of New. In my next post, I will discuss the value and importance of the 2nd part of the New Rule of New: Instances may be created to be returned immediately, as long as they are immediately forgotten.
