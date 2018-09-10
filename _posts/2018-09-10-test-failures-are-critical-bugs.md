---
layout: post
title: Test Failures Are Critical Bugs
date: 2018-09-10 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/critical-failure.jpg
---

In a mature software project, tests are what enable risk-free, rapid development. They are the only thing that truly enables Continuous Integration and Continuous Delivery for software that is deployed directly to end users. In order to keep delivering, those tests must be kept pristine, and any failure represents a critical flaw which must be immediately addressed. Every test failure that happens outside of new feature development on a developer's box, must result in a Bug Ticket. No exceptions!

<img src="/images/critical-failure.jpg" alt="Smoke billowing out of a laboratory door, fire seen through the door's window."  />

----

### Tests Are The Defensive Layer That Enables Your Developers To Move Fast

----

The key to going fast on a project is to minimize the amount of overhead for each new feature delivered. A trustworthy suite of tests substantially reduces the fear and uncertainty that a developer has as he prepares to deliver a new feature. When the test suite is robust and extensive then *"When the tests pass, we ship"* is the only necessary check for deploying a new feature to production. Without a comprehensive test suite, the risk will be passed on to the users, or the company must pay for lots of expensive and slow manual testing. 

**The usefulness of a test suite is only as strong as its weakest link.** If the tests frequently fail for an extended period of time, people will tune them out, and no-one will notice when the tests indicate a real problem. If the tests usually pass, but intermittently and inconsistently fail, then trust in the suite will fall, people will often simply re-queue the tests, cross their fingers and hope that they will pass the next time. 

Even if most of the tests consistenty pass, **if just a few of them result in the whole test suite returning a failure, people will lose faith in the tests, leaving your defenses down.** Therefore, every test failure that happens outside a developer's box (development and testing environments included), must result in a ticket. Every single one!

----

### What kind of bug ticket should be created?

**A test failure always represents one or more of:**

1. A bug in the software
2. A flaw in the test itself
3. Incorrect or mismatched business requirement
4. A build-server or deployment environment problem
5. An unknown emergent behavior of the system

When the cause of the failure is known, then just include the failure context, and assign it directly to the appropriate engineers. 
If the cause of the failure isn't known, then create a ticket to investigate the cause of the failure.

Every failure should result in improvements to the system, however small.

----

### Does the test pass in one environment but not another?

This inconsistency reveals that the software will experience other environmental inconsistencies.

Often times I have found major cross-OS bugs which were illuminated by failing tests. 
- Sometimes path resolutions work on Windows, but not on Linux/Mac
- Sometimes OS API Bindings don't fully support framework features 
- Sometimes a web page loads correctly on one browser, but not on another
- Sometimes date-time handling doesn't work on build servers using UTC time

Environment inconsistencies reveal things that otherwise might go undetected for quite a long time. 

----

### Does an environment have hardware or network troubles intermittently?

All deployment environments may experience transient non-software faults. 

- External integrations should not assume that resources will always be available
- Resilient software and tests should gracefully handle these failures
- Circuit breaker pattern and retry logic can be used to reduce the impact of outages
- Tests should return an *Inconclusive* result, when a system behavior cannot be tested
- Replace or upgrade unreliable hardware or cloud resources in an environment

Developers and testers should have access to metrics and analytics that can easily help them identify failures causes.

----

### Does the software perform correctly under light load, but suffer under heavy load, or with more parallel usage?

These results should be compared to the performance requirements for the software.

- Performance aspects that are underperforming should be benchmarked
- Performance-critical systems should have load-tests as part of the delivery pipeline
- KPIs should be tracked and plugged in to notification and alerting systems

When tests fail due to system performance, the system performance must be upgraded.

----

<img src="/images/shields-up.jpg" alt="Female warrior, defensively holding her shield."  />

**For every reason that a test might fail, there is one or more specific deficiencies in the software system.** These deficiencies should be reported, tracked, prioritized, and usually addressed. Sometimes, it's as simple as deciding that a certain tested characteristic is not required. Sometimes, code will be substantially altered to support more browsers/operating systems/environment failures. **Keep your test suite comprehensive and reliable. Keep your defenses up by treating every test failure as a critical bug!**
