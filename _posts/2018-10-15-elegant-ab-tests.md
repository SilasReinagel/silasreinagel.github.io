---
layout: post
title: Elegant A/B Tests
date: 2018-10-15 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/two-paths.jpg
---

Flexible software systems are a pleasure to modify. You know that you have a flexible system when you can change the behavior of the system without changing any existing code. Adding a new behavior should simply require adding new code. I will show you how to easily introduce A/B tests along with a new feature, without changing the existing code.

<img src="/images/two-paths.jpg" alt="Two game pawns heading through two different doors."  />

**A/B Tests and Feature Toggles are common fixtures in a post-continuous-deployment software world.** This makes it very important to know how to integrate them into your application in a clean way that doesn't cause archtitectural instability. However, often they are implemented in a very clumsy and haphazard way, which then ensures that cleaning them up after resolution will also be rather messy and perhaps error prone.

----

### The Conventional (Messy) Way

----

The conventional approach is to wedge them into the usage site procedure with some if/else logic, and a flag state provider, which might be nicely injected, or might be retrieved from a god-forsaken stateful static class somewhere.

```
public async Task<long> SaveTradeAsync(ITradeRepository tradeRepo, TradeModel tradeModel)
{
    tradeModel.UserId = tradeModel.UserId == Guid.Empty ? userId : tradeModel.UserId;
    tradeModel.Vehicle.EffectiveDate = DateTime.UtcNow;
    tradeModel.Vehicle.ExpirationDate = DateTime.UtcNow.AddDays(AppSettingsRepository.TradeInQuoteExpirationDays);

    UI.SetUserZipCode(tradeModel.Vehicle.DeliveryZip);

    if (tradeModel.TradeInSubmission == null)
    {
        throw new Exception("Unfortunately, an issue occurred with your trade-in submission.");
    }

    if (ExperimentRepository.GetCustomerBucket(tradeModel.UserId).Equals("useTradeAppraisalGateway"))
    {
        var tradeServiceGateway = new TradeServiceGateway();
        var response = await tradeServiceGateway.SaveAsync(Session.Trade);
        if (response?.StatusCode == HttpStatusCode.OK && response.Content?.TradeInId != null)
        {
            return response.Content.TradeInId.Value;
        }

        throw new Exception("Unfortunately, an issue occurred with your trade-in submission.");
    }

    tradeModel = tradeModel.TradeType == TradeType.New ? tradeRepo.SaveTradeIn(tradeModel, userId) : tradeRepo.UpdateTradeIn(tradeModel, userId);
    ExecuteInitializeTradeInApplicationCommand(tradeModel);
    return tradeModel.Vehicle.TradeInId;
}
```

This sort of design is horrendous! The code is messy and complex enough, and then -- buried in the middle of the method -- there is a surprise structural fork with an early return, and sometimes even an early exception thrown! Furthermore, even after the A/B Test is finished, **cleaning up this code is going to require going through this class with a surgical knife** and cutting out the correct bits of the code. It wouldn't be hard to remove the wrong part of the feature, or leave in a residual dependency. Which parts of the setup are needed for the new feature? Which are for the old feature? What a mess!

Also, if the business wants to introduce another A/B test in a similar area of the application, this code site is about to become a Rube Goldberg contraption of conditional logic. **At this point, you are thinking, there must be a better way!**

----

### Elegant A/B Tests

----

How can we have an elegant design that doesn't require wedging in new conditionals into existing code? **Build two new objects, and leave the original intact.** One new object will be the new way to perform the business operation. The other new object will encapsulate the A/B Selection for a given customer.


```
public sealed class FullCustomerDeliveryAddress
{
    private IRespository<CustomerAddress> _addresses;
    
    ... ctor ... 

    public string ForCustomer(CustomerId id)
        => Formatted(_addresses.For(id));
    
    private string Formatted(CustomerAddress address)
        => $"{address.Line1}, {address.City}, {address.State}, {address.Zip}";
}

public sealed class ShortCustomerDeliveryAddress
{
    private IRespository<CustomerAddress> _addresses;
    
    ... ctor ... 

    public string ForCustomer(CustomerId id)
        => Formatted(_addresses.For(id));
        
    private string Formatted(CustomerAddress address)
        => $"{address.Line1}, {address.City}";
}

public sealed class ShortAddressAbTest
{
    private FullCustomerDeliveryAddress _fullAddress;
    private ShortCustomerDeliveryAddress _shortAddress;
    private CustomerAbBucket _bucket;
    
    ... ctor ...
    
    public string ForCustomer(CustomerId id)
        => _bucket.For(id).Equals("useShortAddress") 
            ? _shortAddress.ForCustomer(id)
            : _fullAddress.ForCustomer(id);
}
```

**What makes this design more elegant?**
1. The original presentation code for Delivery Address is untouched
2. No presentation code is concerned with selection logic
3. The selection code isn't concerned with any presentation details
4. The cleanup story is very simple. Delete two of the three classes.

----

### Further Benefits and Opportunities

----

**What further refinements are possible once you structure your designs with independently-composable pieces?** Here are a few:
1. It's trivial to create a standard single general class to handle all A/B Test selections
2. Presentational representions can use a common interface
3. Each piece is trivial to independently unit test. There are no tricky logic branches that are hard to reach
4. It's easy to add AOP Elements like publishing an event each time one of the branches (A/B) is selected
5. The A/B Test and external behavior can be provided via a separate source code artifact

Whenever you are adding feature toggles or A/B tests to your applications, always add them by utilizing the Open-Closed Principle. Leave the existing code untouched as you implement them. **Keep your A/B Tests fixtures elegant and simple!**

What other possibilities can you envision when conditional logic is supplied in a modular and composable way? Tell me in the comments.
