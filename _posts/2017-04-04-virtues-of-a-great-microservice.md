---
layout: post
title: Virtues of a Great Microservice
date: 2017-04-04 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/BakeryCounter.jpg
---

Microservices are becoming very popular because they solve problems horizontally. They make it easy to deliver new business functionality swiftly, flexibly, and with no possibility of breaking existing functionality. What virtues guarantee these business values? I will tell you.

To me, microservices are one of the most exciting paradigm developments in software engineering since the birth of Object-Oriented Programming. The reason for this is that <strong>microservices make it easier to deliver higher-quality software faster, with less risk, less organizational inefficiency, and less need for senior developers</strong>. As long as a few core virtues are upheld, this approach to software delivery sets everyone up for success, and protects the team and consumers from several categories of costly mistakes. 

Previously, I have written about the [Seven Aspects of Software Quality](http://silasreinagel.com/2016/11/15/the-seven-aspects-of-software-quality/). When we work to deliver high-quality microservices, the following traits make it effortless to deliver high marks in each of those qualities:

1. It's very small
2. It solves exactly one problem
3. It has a crisp, cohesive contract
4. It is owned and operated by it's developers
5. It is fully encapsulated

<img src="/images/BakeryCounter.jpg" alt="" width="700" height="400" class="aligncenter size-full" />

----

### 1. It's very small

----

Small software solutions have a huge advantage over large ones. Small source codebases are naturally portable, understandable, and modifiable. They are easier to test, faster to deploy, and contain fewer possible bugs. I could write a lot about why [small solutions are superior](http://silasreinagel.com/2017/01/10/make-it-small/). 

Your microservice should live up to its name and be actually <strong>micro</strong>. Resist the urge to add more functionality to an existing microservice!

----

### 2. It solves exactly one problem

----

A great microservice solves exactly one problem. It does not solve two problems (or heavens forbid, more!). Elegance is lost and additional complexity is added anytime multiple problems are solved in the same place, using the same code. 

If you have a microservice that handles User Account Identity, it should not also provide functionality for public User Profile customization. Solve one problem well. When you have solved your problem well, others will not need to solve the problem or adapt your solution. 

----

### 3. It has a crisp, cohesive contract

----

A microservice is only useful if it is easy to use. Great microservices have clean, concise contracts. <strong>They should be well-documented and easy to understand.</strong> Required inputs and outputs should be simple and clear. Provide code samples to consumers.

When a service is difficult to use or poorly documented, other developers will typically find another solution. A great microservice is highly usable. 

----

### 4. It is owned and operated by its developers

----

At many companies there is an unhealthy division between Operations and Development. This is inefficient, and typically leads to a disconnect of responsbility. The developers who create a microservice should be responsible for administering it. When developers own and operate their own microservices, then they will have a strong interest in ensuring that the services are reliable and performant. 

Engineers who get calls at 3am in the morning when their service is down are motivated engineers. The team who created the microservice are the ones providing a business service. Using microservices is simply *how they provide it*. 

----

### 5. It is fully encapsulated

----

Microservices should expose nothing other than their public interface. They must not provide external access to their source code, their data sources, or their internal data models. Sharing any of these will compromise all of the gains! 

Encapsulation is what ensures that data access can change for business or technical reasons. This is what ensures that consumers will never be impacted by implementation changes. Developers must be fanatical about protecting the service internals!

----

Let your microservices uphold these virtues. <strong>Make your microservices great!</strong>
