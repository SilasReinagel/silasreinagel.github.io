---
layout: post
title: Elegant Event Triggers
date: 2018-12-10 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/rows-of-dominos.jpg
---

Often as you are working on a project, you will receive a request that incidentally impacts a large portion of your API. Maybe an email needs to be sent every time a customer takes certain actions. How can you implement this kind of feature without making changes to a large portion of your codebase?

<img src="/images/rows-of-dominos.jpg" alt="Colorful parallel rows of dominos, triggering controlled chain reactions." />

Suppose you are working with a Web Service that heavily caches its data for performance reasons. Certain administration actions that API supported would invalidate the data in the cache. The API presently exposes the following HTTP Endpoints:

```
GET /api/v2/experiments
GET /api/v2/{experimentId}/buckets
GET /api/v2/experimentDetails
POST /api/v2/experiments
POST /api/v2/{expirmentId}/buckets
``` 

You've got a elegant system that assembles all of the use cases in the Composition Root. You have [Web Controllers with single-line methods](https://www.silasreinagel.com/blog/2017/03/28/keep-your-asp-net-controllers-code-free/) that delegate the work to your [Application code](https://www.silasreinagel.com/blog/2017/03/21/independently-executable-units/). 

----

Now, the new requirements is that anytime an Experiment is added, and anytime Buckets are changed for an experiment, the application's cache should be refreshed. **How can you add this new behavior to your system in the most maintainable way?**

The conventional and obvious choices that are typically followed are one of:
1. Add new code to each of the impacted application Use Cases
2. Add new code in the Web Controllers for each of the impacted endpoints

You are well aware of the problems with both of these approaches, from your knowledge of the SOLID Principles and the rules of Elegant Objects. 

----

### Elegant Event Trigger Design

The most elegant design will be to [decorate](https://www.yegor256.com/2015/02/26/composable-decorators.html) the Use Cases with the new behavior in the Composition root. Implementing this requires three steps:

1. Create a new Cache Invalidation Decorator
2. Create a new Factory or Extension Method for composing the new behavior
3. Register the Decorated Use Case in the Composition Root

**1. Create Cache Invalidation Decorator**

``` 
public sealed class EvictCacheOnSuccess<TRequest, TId> : IPut<TRequest, TId>
{
    private readonly IPut<TRequest, TResponse> _inner;
    private readonly ServiceBus _serviceBus;

    ... ctor ...

    public async Task<Result<TId>> Put(TRequest req)
      => await (await _inner.Put(req))
        .Then(async () => await _serviceBus.Publish(new CacheEvictionEvent("ExperimentDataChanged"));
}
```

**2. Create Composition Extension Method**

```
public static class EvictCache
{
    public static IPut<TRequest, TId> WithCacheEvictionOnSuccess<TRequest, TId>(
      this IPut<TRequest, TId> inner, ServiceBus serviceBus)
        => new EvictCacheOnSuccess<TRequest, TId>(serviceBus, inner);
}
```

**3. Update the Composition Root**

```
public static void RegisterUseCases(IConfiguration config, IServiceCollection services)
{
  var serviceBus = new AzureServiceBus("...");
  services.AddScoped<IGet<ExperimentsResponse, GetExperimentsRequest>, GetExperiments>(); 
  services.AddScoped<IGet<IEnumerable<SingleBucketResponse>, GetBucketsRequest>, GetBuckets>();
  services.AddScoped<IGet<ExperimentDetailedResponse, GetExperimentRequest>, GetExperimentDetailsContext>();
  services.AddScoped<IPut<AddedExperimentResponse, AddExperimentRequest>>(x =>
      x.GetRequiredService<AddExperimentContext>()
          .WithCacheEvictionOnSuccess(serviceBus));
  services.AddScoped<IPut<AddedBucketsResponse, AddBucketsRequest>>(x =>
      x.GetRequiredService<AddBucketsContext>()
          .WithCacheEvictionOnSuccess(serviceBus));
}
```

----

### What are the benefits of this approach?
1. The application Use Cases are unchanged
2. The Web Controllers aren't coupled to any application behavior
3. A reusable, composable Cache Eviction behavior now exists
4. The syntax in the Composition Root is clean and declarative
5. Adding/removing from any number of Use Cases only requires changing one file 
6. There is no code duplication
7. There is no coupling between the existing behavior and the incidental new behavior

This is an elegant design! Whenever you need to connect application features with generic triggered events of any kind (emails, reports, metrics, logging, caching... etc), always do it via decoration, and always apply the decoration in the Composition Root. **This ensures that your application remains flexible and easy to maintain.**
