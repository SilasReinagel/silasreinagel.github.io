---
layout: post
title: Reactive Advantages - One Integration
date: 2019-03-18 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/main-river.jpg
---

One of the pains of working in a horizontal system is the number of integrations that must occur. Typically, this leads to bloated, fragile, and complex service configurations. There are ways to mitigate this pain (such as Service Discovery), but moving to a reactive architecture prevents this problem in a very different way.

With a reactive system, the emphasis is not on the objects, services, functions, and application that exist, nor is it about how they communicate. **Instead, in a reactive system, the emphasis is on the messages.** The objects in the system produce messages and consume messages. 

<img src="/images/main-river.jpg" alt="One river waters the whole plain" />

I will show you the way a typical system tends to evolve, and the way a reactive system tends to evolve. The reactive architecture makes the cost of new feature significantly smaller, and minimizes the fragility of the system, particularly because each system has one and only primary integration.

----

### Typical Horizontal Integrations

----

Services often accumulate more functionality and features. When this happens in a horizontal system, many of the new features require new integrations.

Suppose you have built a service that provides typical eCommerce Shopping Cart functionality. You've got a few basic cross-cutting integrations (Authentication, Log Aggregation, Health Reporting, etc), an integration with your database, and an integration with a Catalog Service.

Your minimal configuration has the following elements:

```
"AuthUrl": "..."
"LogAggregationUrl": "..."
"HealthReportingUrl": "..."
"CatalogApiUrl": "..."
"DbConnectionString": "..."
```

Before we go any further, let's consider the number of ways this Service could experience serious operational difficulties. There are three major points of failure, any of which would prevent the Cart Service from functioning correctly.

1. Authorization Service may be unreachable
2. Database is unreachable or overloaded
3. Catalog API is unreachable, overloaded or throwing errors

Now, a new business feature request comes in. *"Everytime a customer adds an item with a price of $500+, the Coupon Service should be notified."*

Satisfying the feature requires a new integration with configuration, a gateway, message schemas, additional internal logic, and makes the Cart Service dependent on the Coupon Service, to fully provide the required business functionality. Any changes to endpoints, configuration, message schemas, or logic will result in new changes needed in the Cart Service.

Our minimal configuration now looks like this:

```
"AuthUrl": "..."
"LogAggregationUrl": "..."
"HealthReportingUrl": "..."
"CatalogApiUrl": "..."
"DbConnectionString": "..."
"CouponApiUrl": "..."
```

Every new feature that requires communication within the enterprise increases the fragility of the system, and most new communications require new integrations. This is the natural evolution of a non-reactive horizontal system.

----

### Reactive Horizontal Integrations

----

In a reactive system, no messages are sent directly to any particular service. Instead, each object produces the messages related to its domain, and consumes messages from other business systems that it needs to fulfill its responsbilities. This means that conventionally, the message bus is secured, and all other features are integrated reactively.  

Again, for example, suppose you have built a service that provides typical eCommerce Shopping Cart functionality. You've got cross-cutting integrations (Log Aggregation, Health Reporting, etc), an integration with your database, and your service consumes Catalog Messages.

Your minimal configuration has the following elements:

```
"MessageBusConnectionString": "..."
"DbConnectionString": "..."
```

This integration now only has two points of failure. 

1. Message Bus may be unreachable
2. Database is unreachable or overloaded

Now, a new business feature request comes in. *"Everytime a customer adds an item with a price of $500+, the Coupon Service should be notified."*

Satisfying the feature requires just two changes: creating a new message schema for `ItemAddedToCart`, and the publishing that message whenever an item is added. There is no new logic (the Coupon Service itself can decide what price thresholds it cares about). There is no new endpoint. There is no new configuration needed. Cart Service does not take a dependency on the Coupon Service. No changes are needed in the application composition root. 

Our minimal configuration still looks like this:

```
"MessageBusConnectionString": "..."
"DbConnectionString": "..."
```

Adding this new feature is trivial. Produce one new message in the existing domain, and allow consumers to subcribe to it, and apply their own logic in their own service, where it belongs. The system has no new points of fragility. 

----

### Summary 

----

There are many advantages of reactive systems, and one-way messaging between objects. In this post, we have explored the way a business system grows in a reactive system and a non-reactive system. 

When a non-reactive system grows, new integrations are needed, new configuration is needed, new dependencies are added, new logic is incorporated, and new points of fragility are introduced.

When a reactive system component grows, no new integrations are needed, no additional configuration is required, no new dependencies are added, and no new points of fragility are introduced. 

A reactive system depending upon only one single core integration **makes the system easier to operate, easier to maintain, and easier to change.** This reason alone is enough to make it the very best choice for horizontal systems. 
