---
layout: post
title: Independently Executable Units
date: 2017-03-21 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/hexagons.jpg
---

Often people talk about their applications as Console Apps, Web Apps, Mobile Apps, etc. There is nothing wrong with using those terms for marketing purposes, but there is a major flaw if they are designed structurally with that idea. Creating an "X App" will make the resulting code rigid and non-portable. Instead, create independently executable units.

"X App" thinking is proliferated by many of the defaults and templates in our IDEs. It is very easy to start a new "ASP.NET MVC" application project. Most of the tutorials and guides start you off this way, and have you executing "Hello, World" in this style. This is fine for "Hello, World", but for a serious business application, <strong>the last thing you should do is couple your application code to its deployment mechanism!</strong> The most important thing is the functionality that your application provides. 

If you are writing a Coffee Shop Customer Self-Service application, then <strong>you are creating a Coffee Order App, not a Web App</strong>. If you app is correctly designed and structured, it should be reasonably easy to allow users to order coffee using their Browser, their Smartphone, their Windows PC, or for coffee-addicted developers, even using a RESTful Web Endpoint or a command-line interface.

<strong>Hexagonal Architecture is a paradigm that separates User Interface plugins and Data Communication plugins from the core behaviors of your application itself.</strong> Using this paradigm, we can create an ASP.NET WebAPI adapter for our Coffee Order App, along with a ReactJS Client that calls into our application. In fact, we can create any sorts of implementation adapters. The adapters will all be very lightweight classes that transform and route external requests into the method calls that our Coffee Order App objects require. 

<img src="/images/hexagonal-architecture-example-1.jpg" alt="" width="1280" height="589" class="aligncenter size-full" />

What is the most practical way to ensure that your application is built in a decoupled manner? <strong>Create independently executable units.</strong> Execute them without any of the deployment infrastructure that you know you will eventually need. If a piece of functionality is independently executable, then it is also independently developable and independently deployable. 

----

### Implementation Using Independently Executable Units

----

YucaBean has decided that coffee-addicted developers are the most important market demographic. Other teams have been tasked with building payment and order-building applications. You have been tasked with creating a command-line application that allows customers to query the available drinks and sizes for a particular YucaBean location. 

Having been burned in the past, you know better than to start by creating a Console Application. You are going to start by building an Available Beverages App, and later create a Console App adapter. <strong>In order to ensure that the code is always executable, you start with a simple unit test.</strong>

```
[Test]
public void Store_HasNoAvailableBeverages_BeveragesIsEmpty()
{
    var store = new FakeStore(1234);

    var beverages = store.Beverages();

    CollectionAssert.IsEmpty(beverages);
}
```

This test forces you to create a couple of simple, degenerate classes. Your code is now executing, and the one defined behavior is correct. Next, create some code that ensures an actual beverage can be returned by the store.

```
[Test]
public void Store_OneAvailableBeverage_BeverageIsCorrect()
{
    var beverage = new Beverage(73, "Hot Cocoa");
    var sizePrice = new SizePrice(BeverageSize.SixteenOz, 2.99);
    var store = new FakeStore(1234);
    store.AddBeverage(beverage, sizePrice);

    var beverages = store.Beverages();

    Assert.AreEqual(1, beverages.Count);
    var actual = beverages.First();
    Assert.AreEqual(store.Id, actual.Store);
    Assert.AreEqual(beverage.Name, actual.Name);
    Assert.AreEqual(sizePrice.GetBeverageSizeId(beverage), actual.Id);
    Assert.AreEqual(sizePrice.Size, actual.Size);
    Assert.AreEqual(sizePrice.Price, actual.Price);
}
```

Now, your app executes and expresses a lot of the critical business concepts. Given a particular Store, users can query the store for it's available beverages. The Store is capable of aggregating information from a variety of places, a list of beverage products, prices for different sizes of each beverage, a unique id for each beverage type and size and so forth. 

<strong>All of this functionality exists without the need to create a database, or call out to any external systems.</strong> Your app doesn't need to know anything about UI frameworks, web routing, command-parsing, service contracts, or databases. Those will all be plugins to the Available Beverages use case that we have created for our Coffee Ordering App. Note, that because we assembled just a single executable slice of functionality, our app is complete, without needed to know anything about Ordering, Payments, Customers, etc.

With the Available Beverages App fully complete (later we can plugin data sources), you can integrate with a command-line interface. To integrate, you need a way for coffee-crazed developers to pass their favorite Store Location ID into the application. You also need a way to nicely display the beverage information back to them. 

Starting with a new project `YucaBean.Console`, you create two simple classes. Your console text adapter:

```
public sealed class ConsoleBeverageText
{
    private readonly AvailableBeverage _bev;

    public ConsoleBeverageText(AvailableBeverage beverage)
    {
        _bev = beverage;
    }

    public override string ToString()
    {
        return $"{_bev.Id} - {_bev.Name}, {_bev.Size} - {_bev.Price}";
    }
}
```

Next, you've got to create one of those fancy console arg parsers. 

```
public static void Main(params string[] args)
{
    var stores = CreateInMemoryStoreFactory();
    if (args.Length == 2 && args[0].Equals("drinks"))
        PrintAvailableDrinks(storeFactory, args[1]);
    else
        Console.WriteLine("Expected command: yucabean drinks {storeId}";
}

private static void PrintAvailableDrinks(Stores stores, string storeId)
{
    try
    {
        stores
            .Get(int.Parse(storeId))
            .Beverages()
            .ForEach(x => Console.WriteLine(new ConsoleBeverageText(x)));
    }
    catch (Exception e)
    {
        Console.WriteLine($"Error: {e.Message}");
    }
}
```

That's it! You've created a simple command-line integration. YucaBean can now release their public beta. Your app is simple and easy to use.

```
λ yucabean drinks 1234
132 - Dark Roast, 12 oz. - $1.79
176 - Dark Roast, 16 oz. - $1.99
220 - Dark Roast, 20 oz. - $2.49
156 - Blonde Roast, 12 oz. - $1.79
208 - Blonde Roast, 16 oz. - $1.99
260 - Blonde Roast, 20 oz. - $2.49
80 - Peach-Mango Smoothie, 16 oz. - $3.99
120 - Peach-Mango Smoothie, 24 oz. - $4.49
84 - Hot Cocoa, 12 oz. - $2.25
112 - Hot Cocoa, 16 oz. - $2.49
140 - Hot Cocoa, 20 oz. - $2.99
```

All of your business applications should be created with this structure. <strong>Your code should emphasize the business problem (selling coffee), and defer decisions of how users will interact with your application, and how you will access business data.</strong> Using this structure ensures that adapting your system for various User Interfaces and Data Sources is trivial. 

How difficult would it be to add a different sort of command to your application? 
How hard would it be to host `YucaBean.AvailableBeverages` as a microservice? 

----

### Summary

----

As long as you can execute functionality independently, you can also develop independently and deploy independently. 

Your deployment integrations should not contain any business logic. They should simply plugin to the business functionality that you have already created. Create your business functionality first, in its own separate project. <strong>Create your deployment integrations separately!</strong> Make them as lightweight as possible. 

This is the only way to future-proof your application, keep it flexible, and maximize its portability!
