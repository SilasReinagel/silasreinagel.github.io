---
layout: post
title: Make Your Interfaces Abstract
date: 2017-05-09 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/adapters.jpg
---

Abstractions are very much abused in software development. Frequently, I encounter supposedly abstract interfaces that reveal too much and can only realistically be implemented in one way. This violates the entire concept of abstractions! Let me show you what I mean.

<div class="container"><img src="/images/adapters.jpg" alt="Electric Cables With Various Connector Types" /></div>

Here are some ways to ensure that your interface are as concrete and unusable as possible:

----

### Anti-Pattern: However You Like - As Long It's My Way

----

Consider the following interface:

```
public interface IGetANumberGreaterThanSevenAndLessThanNine 
{
    int Get();
}
```

The concept behind this interface is terrible. **The name indicates a very particular expected behavior.** The `Get()` method could potentially return a wide variety of numbers, but the design of the interface has constrained it. A better design would be to simply store a constant somewhere.

There are many similar business code interfaces that are similarly restrictive and leaky. They share the expected implementation in their name. 

```
public interface ILookupAmazonProductPrices
{
    decimal GetBestPrice(string amazonProductName);
}

public interface IQueryStoreSalesTax
{
    decimal GetSalesTax(string storeId, decimal itemPrice, DateTime asOf);
}
```

Maybe these are necessary pieces of software functionality. But they are lousy interfaces. There is nothing abstract about them. They are putting the expected implementation up on a Jumbotron in neon lights. **A good interface has many possible implementations.**


----

### Anti-Pattern: Definitely Not A Data Structure

----

Here is another example of something that really isn't abstract:

```
public interface Address 
{
    string GetLine1();
    string GetLine2();
    string GetCity();
    string GetState();
    int GetZipCode();	
}
```

This looks suspiciously like a plain old data structure. Five values are all provided together. Is there any behavior? Probably not. 

If the interface provides nothing but getters and setters for a few pieces of data, **just let it be a concrete data structure.** There isn't a point in pretending this is some high-level component with interesting behavior that might need to be changed. 

If we are going to some external service or database, couldn't we get all the data at the same time, instead of implicitly sending a message over the network for each individual piece of data?

----

### Anti-Pattern: The Quest For Legendary Artifacts

----

This one also has strangely particular requirements:

```
public interface StringDisplay
{
    void DrawString(Font font, string text, Vector2 position, Color color);
    void DrawString(Font font, string text, Vector2 position, Color color, 
        float rotation, Vector2 origin, float scale, SpriteEffects effects, 
        float layerDepth);    
}
```

These are very particular arguments. **When something needs a bunch of specific details, there is a very high chance that it's not abstract.** There will probably be one and only one correct way to draw a string using this information. There isn't a lot of room for polymorphism. Something like this should just be kept as a concrete class. 

----

### How To Create Genuinely Abstract Interfaces

----

When you have just a single implementations, it's easy to think that it's abstract simply because you "created an interface". However, more often than not, such an interface is too specific to be reused. Using a leaky abstraction doesn't protect your system from new requirements. Instead, it makes it twice as hard to change, since all of the interfaces AND all of the implementations must be altered to add a new use case.

What is the best way to create interfaces that are genuinely abstract? There is only one highly effective way to ensure this. **You must have multiple different implementations.**

<div class="container"><img src="/images/usb-flash-drives.jpg" alt="USB Drives" /></div>

By fully satisfying multiple different use cases with the same interface, your program proves that the interface is reusable in different forms. The most abstract interfaces are the ones that can be used in the broadest range of scenarios. Reasonably abstract interfaces are ones that have a smaller scope, but effectively handle some range of application use cases. 

If you are struggling to find the abstraction, then don't create an interface yet. **Make your interfaces abstract!**
