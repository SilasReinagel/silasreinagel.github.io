---
layout: post
title: Type Erasure Is A Failed Experiment - Interface Segregation
date: 2016-10-11 09:00
author: silas.reinagel@gmail.com
comments: true
categories: [Java, Software Engineering]
---
Generics are amazing! There is something immensely satisfying about solving an entire class of similar problems, rather than just solving a single instance of a problem. Why figure out how to cache this one database call, when I could figure out how to cache an arbitrary number of varying database calls? Why merely solve authenticating one web request, when a solution to authenticating all web requests is within reach? The scope of engineering problems vary, but my tendency does not. I would rather solve something abstractly, than concretely. Creating simple, elegant, portable solutions to particular type of problems is immensely satisfying.

Unfortunately, Java's generics are sorely lacking. They work in some scenarios. They help me solve some of the things I wish to do. But they also create problems. This is primarily because of the failed experiment of Type Erasure. Type erasure means that during runtime, information concerning generic parameters is forgotten. Type information generally only exists at compile time. It isn't quite as simple as that, but that's the simplest way I can express it. This creates some very interesting and problematic scenarios.

Before we get into some code, here is an imaginary conversation I have with two different programming languages.

<h4>Imaginary C# conversation</h4>

`var basket = new Basket<EasterEgg>();`
<blockquote>Dev: Hey C#, how many eggs are in the basket?<br>
C#: 5<br>
Dev: What kind of items are in this basket?<br>
C#: EasterEggs<br>
Dev: Great. Thank you.</blockquote>

<h4>Same conversation in Java</h4>

`Basket<EasterEgg> basket = new Basket<>();`
<blockquote>Dev: Hey Java, how many eggs are in the basket?<br>
Java: Do you mean items?<br>
Dev: Sure, How many items are in the basket?<br>
Java: 5<br>
Dev: Java, what kind of items are in the basket?<br>
Java: I don't know.<br>
Dev: What do you mean you don't know?<br>
Java: I forgot<br>
Dev: Java, that's a basket of eggs, ok?<br>
Java: Ok<br>
Dev: What kind of items are in the basket?<br>
Java: I don't know.<br>
Dev: What do you mean you don't know? I just told you.<br>
Java: I forgot.<br>
Dev: Hey Java, can you get me a Flower out of the basket?<br>
Java: Sure. Here's a Flower<br>
Dev: What on earth! This is an Easter Egg! Why did you tell me it was a Flower?<br>
Java: You asked for a Flower. That's your problem.</blockquote>

<hr />

<h3>Interface Segregation Troubles</h3>

<hr />

Consider the following. Suppose we are creating an application that reports on the contents of Easter Egg Hunt findings.

{% highlight java %}
public class EasterCollectionReport
{
    private List<String> reportLines = new ArrayList<>();

    public void add(EasterEgg egg)
    {
        reportLines.add("Easter Egg: " + egg.toString());
    }

    public void add(Candy candy)
    {
        reportLines.add("Candy: " + candy.toString());
    }
}    
{% endhighlight %}

This compiles just fine. No problems. Now, let us suppose we want to interface segregate this Report, such that Candy does not know that this report may contain information about EasterEggs and vice versa. The clients say that sometimes they want to format the Candy report and the EasterEgg report differently, but other times they want a single simple report. So, we create a simple generic interface:

``` java
public interface Report<T>
{
    void add(T obj);
}
```

Now, the EasterCollectionReport should implement this interface twice, since we can presently add Candy or Easter Eggs to this report.

<pre><code>public class EasterCollectionReport implements Report&lt;Candy&gt;, Report&lt;EasterEgg&gt; { ... }
</code></pre>

This no longer compiles. Your IDE will tell you that you cannot implement <code>Report</code> twice. It is a duplicate implementation. Why? Because of Type Erasure. Even though Java can use dynamic method dispatch to figure out whether the <code>add(candy)</code> or the <code>add(egg)</code> method are called, it cannot distinguish between a Report of Candy and a Report of EasterEgg.

That's ok, we are engineers! Surely we can easily solve this minor problem! Maybe let's try giving the reports concrete names.

<pre><code>public interface CandyReport extends Report&lt;Candy&gt; { ... }
public interface EasterEggReport extends Report&lt;EasterEgg&gt; { ... }

public class EasterCollectionReport implements CandyReport, EasterEggReport { ... }
</code></pre>

Nope. That doesn't work. Our helpful IDE tells us "'Report' cannot be implemented with different type arguments, 'Candy' and 'EasterEgg'". Okay, let's try something else. Maybe we can make a new interface for Report that contains two different types.

<pre><code>public interface Report2&lt;T1, T2&gt;
{
    void add(T1 obj);
    void add(T2 obj);
}
</code></pre>

Nope. That doesn't compile either. "'add(T1)' clashes with 'add(T2)'; Both methods have the same erasure". That's unfortunate. That wasn't even going to be a particularly good solution, since it would lead to proliferating other interfaces like <code>Report3</code>, <code>Report4</code>, and <code>ReportX</code>. Well... What can we do? I guess we could go back to the last idea, and make things even more concrete.

<pre><code>public interface CandyReport
{
    void add(Candy candy);
}

public interface EasterEggReport
{
    void add(EasterEgg egg);
}

public class EasterCollectionReport implements CandyReport, EasterEggReport { ... }
</code></pre>

Finally! We got it to compile. Now CandyReport is interface segregated from EasterEggReport. However, this solution really doesn't feel very satisfying, nor does it appear very scalable. I have a sneaking suspicion that this approach will force us to create a lot of very-specific degenerate interfaces in the future.

Needless to say, type erasure and generic interfaces don't play nicely together when the goal is to create abstract patterns and problem solutions. There are some ways this can be circumvented, but type erasure certainly is a bit of a minefield. In my next piece I will explain how type erasure negatively impacts Serialization and Representational State Transfer.
