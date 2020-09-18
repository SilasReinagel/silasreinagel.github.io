---
layout: post
title: Software At Scale - Constraints
date: 2020-09-18 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/billions-of-stars.jpg
---

When you're working with software that services millions or billions of requests per day, you must solve different problems than simply making a given feature behave correctly. It needs to be fast, resilient, and flexibly deployable/scalable. There are three key constraints you must juggle.

<img src="/images/billions-of-stars.jpg" alt="A sky with billions of stars." />

You may already be familiar with the CAP Theorem. The CAP Theorem, which applies to distributed data stores, says that you can fundamentally choose to prioritize any two of Consistency, Availability, and Partition Tolerance.

The modern microservice application faces a similar set of tradeoffs, which will impact your success at various types of scaling. Those key resources are **Compute, Memory and Network** resources.

----

## The Three Key Resource Constraints

### Compute:
If you have complex calculations, and you want to calculate things in real-time (one request = one calculation), then you need compute power. You can better utilize your compute power by writing efficient algorithms and using optimal data structures.

If you find that you are using more CPU than you wish to allocate, you can trade some memory or network for your compute power.

By pre-calculating something and storing it in memory, you no longer need to run the expensive computations when an incoming request comes in, and so you reduce your compute load.

Alternatively, you can potentially trade compute for a network resource. If you can move the calculation out to separate system, then you no longer need to run the computations, but now you are bound to a network call and network latency.

### Memory:
Memory serves both as a scratch space for working computations, and also as a highly-efficient data store. Most enterprise data is kept in a database. If you live-query the database for every incoming request, and only use that data around for the current operation, then you have a low memory footprint, but you are constrained by your network resource (the database).

You can reduce your network resource usage by storing data in-memory. The advantage of this is that your request processing will be much faster, but at the expense of a higher memory footprint. You also suffer either a loss in consistency, due to stale data, or more complex engineering needed around cache invalidation.

You can reduce your compute usage by memoizing parts of calculations already made, and storing them in efficient data structures. This faces the same challenges as offloading your network usage, since you may have less consistency, or complex invalidation policies.

### Network:
Your service will likely rely on one or more databases, and perhaps one or more external services. Network resources are often the hardest to manage effectively, due to latency, availability, and connection methods.

In particular, you may struggle with number of concurrent connections allowed to your database, number of ports utilized in the hosting environment, or varying latency of external service integrations.

Anything you can do to reduce your throughtput to external network resources will generally improve your service resilience and performance. However, there is always an upper limit. There will always be something that you need to access externally.

You can reduce your network usage through batching, better data architectures, caching, localizing calculations or datasets, or by adding other network resources (such as Redis caching) into your architecture.

----

These are the 3 key constraints that you need to juggle to effectively architect your microservices at scale.

You can make tradeoffs between these three types of resources in order to achieve services that scale in the way you want.

Vertical scaling happens when you auto-scale the amount of resources your service uses (more compute/more memory).

Horizontal scaling happens when you scale the number of running instances, but not the amount of resources used by an instance.

Your hosting mechanism will usually determine which scaling model will be most beneficial for your services.

