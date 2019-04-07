---
layout: post
title: Consequences Of Project Success
date: 2019-04-08 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/mountaintop.jpg
---

Most software engineers really enjoy the building process. They love to create new things -- they enjoy the early phases of a project when everything is new, fresh, and exciting. Experienced developers must be equally good at the later phases of a project. Finishing building a project is a rewarding process, yet it is not the end! It brings with it a new phase. A successful project brings its own new challenges.

<img src="/images/mountaintop.jpg" alt="Man on mountaintop, celebrating him successful climb" />

There are different levels of success for a project.
- When you succeed at building a small tool, it meets your needs, and you can change it as needed.
- When you succeed at building something for an internal client, it meets the needs of a few, and more people are dependent on it.
- When you succeed at building a product for the market, it meets the needs of many, and many people and companies become dependent on it.

Some of the consequences of completing a successful project which empowers other people are:

1. New Feature Requests
2. Questions about Various Features
3. Lots of Bug Reports
4. More Stringent Operational Requirements
5. Real-time Support Issues

Some developers shy away from these new rewards. They prefer building things to dealing with people, working hard at developing effective communication, and polishing/supporting the project. Quitting early can hamstring a project and prevent it from reaching its full potential. **Embracing this phase and leaning into it is the key to exponential returns.**

I will share with you some of my techniques for effectively handling each of these consequences of success.

----

### 1. New Feature Requests

----

Once a project gains some good traction, you will begin to receive a flood of feature requests from well-meaning clients and stakeholders. 

- Some of them are for things that the software already does
- Some of them are for things that make the software more usable
- Some of them are for things that will dilute the software and increase its complexity
- Some of them are for things that will genuinely increase the value of the software

The most important thing to do with new feature requests is to use a formal intake process, and properly consider the direction of the software, the cost of the feature, and the expected business value. **It's generally better to not develop new features.** However, there may be some gems that offer a valuable new opportunity. 

For new feature requests, filter them heavily, and prioritize them ruthlessly, after analysis.

----

### 2. Questions about Various Features

----

Often times, clients and stakeholders will reach out to you or a team member personally, typically using direct messages, emails, or sometimes even coming to speak to you in person. 

In order to build and maintain rapport, you want to encourage these questions and the inquirer for expressing interest. **However, generally the fact that these questions are being asked is an indication of a technical lack.** Needing to ask a person directly means that the technical information they needed isn't readily available and easily discoverable. 

Every time you receive a question about a feature informally, you should do something to improve the discoverability of the information that you give out. Use this as an opportunity to create documentation, expand documentation, make documentation more prominent, add an FAQ, etc. **There should always be a new artifact generated for every informal question about a project.**

----

### 3. Lots of Bug Reports

----

As you have a significantly increased number of users, you and your team will receive many bug reports. 

People will complain about all sort of issues:
- The software doesn't behave quite the way they expect it to
- They get different numbers when they use your software, compared to another tool
- One time, they got an error they didn't like
- With one specific set of inputs, the software doesn't generate the output they expect
- Bug requests in the form of a "harmless question" (i.e. is this supposed to happen?)
- The software doesn't do something they want it to do

There are many different shapes and forms of bug reports. Many of them are not bug reports at all. For things that aren't bugs, it's important to redirect the bug reporter to the correct process, using techniques like the following:
- "Here is the documentation on how X feature is supposed to behave" (Write this documentation on the spot, if needed)
- "Here is the unit test demonstrating the expected output, which is described by the documentation"
- "Our software doesn't currently perform X. Would you like me to open a feature request for X?"

When you do have a genuine bug report, open a ticket and include all the information the reporter just gave you.
- "We have opened a bug ticket for that error. We will prioritize it appropriately. Here is a link to the ticket."

Most bugs are not urgent. Many bugs are not worth fixing. **Be intentional about recording them and getting into the prioritization process.** Never over-react or jump to immediately fix non-critical bugs. **Always supply a link to the requester.**

----

### 4. More Stringent Operational Requirements

----

When your software project is widely used, other people and companies will come to depend on it. Sometimes you will have people say things like:
- "We need your software to have faster response times."
- "Your software isn't handling all our requests. We need more throughput." 
- "Your software returned some Error, causing an outage for us."

**This is a key moment to both improve and define the performance characteristics of your software.** Do you know how your software should be expected to perform? Do you know what improvements would be needed to reach higher operational thresholds? Do you know what the bottlenecks in your system are?

This is a prime opportunity to use your engineering skills to optimize your system. Learn to effectively use profilers, benchmarking tools, load testing, and other operational tools and techniques to bring your system to the operational level you desire. 

Furthermore, this is the perfect opportunity to provide public communication about the state of your system and its operational characteristics, through publishing SLAs, and providing public health endpoints and dashboards. Work with other engineers to ensure their systems are appropriately fault-tolerant. 

----

### 5. Real-Time Support Issues

----

These often differ from bug reports, in that often they are time-sensitive issues. Being a good team player often means working to resolve the issue in the moment. However, working through the issue isn't enough.

**The emergence of an issue typically means that other work is needed.** It's crucial to properly capture the other needed work after resolving the issue. After resolving an issue, take the time to think through the cause of the issue and possible resolutions that could have prevented your involvement.

- Is there documentation that the support person was unaware of, which would have resolved the issue? Make the documentation more prominent. Train people.
- Is there a bug in the software that hasn't been addressed? Open a bug ticket.
- Could a new feature be added to the software that empowers support people to fix the issue themselves? Open a feature request.
- Was this issue caused by an operational deficiency? Look into improving the system, or building more fault-tolerance into integrations. 

Always take the opportunity to improve the project to prevent issues from a occurring, and make it easier for people to correct issues without development team intervention.

----

### Summary

----

Handling the initial success of a project well is at least as important as the ability to create successful projects. It makes the difference between something that will last a long time, and something that may burn bright and then quickly fizzle.

If you have worked on successful projects at this phase, I hope a few of these techniques will be useful to you.
If you have not worked on a project that reached this phase of success, be mindful that it is a very different phase in the lifecycle of a software project. Adjust your expectations, so that you are ready to fully embrace the phase and bring your project to full maturity. 

The most important thing to remember is that the key skills needed during the initial success phase are:
1. **Build a disciplined process about evolving the project**
2. **Be disciplined and consistent in communicating with clients/stakeholders**
3. **Work hard to make it easier for clients to find the information they need without involving development team effort**

What other consequences of success have you experienced in your projects? What techniques do you use for them? Tell me in the comments.
