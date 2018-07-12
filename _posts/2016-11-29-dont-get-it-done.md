---
layout: post
title: Don't "Get It Done"
date: 2016-11-19 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/MismatchPuzzlePieces.jpg
---

Software development is far from a purely technical field. Good developers always have an acute awareness that software is about people. Great software is that which effectively meets the needs of its users. Programmers who do not consider their responsibilities to their users and to their team are incapable of providing high value.

There is a deadly, costly idea that is very popular in software development companies these days. This idea is the "Get It Done" philosophy. The "Get It Done" philosophy is seductive. It has just enough truth to be persuasive and hard to resist. It is very appealing to managers, business, marketing, sales and even a large number of developers. However, it contains a deadly inaccuracy that has the potential to poison software products, erode intercompany relationships, and grind feature development to a halt.

----

<strong>The Truth:</strong> There is a tension between Speed, Cost, and Quality in software engineering. It is accurate that tradeoffs can be made between these dimensions. The conventional heuristic that you can "Choose any 2 of the 3" is a reasonable short-term mental model. This has been reliably observed by numerous teams and developers.

<strong>The Lie:</strong> The lie is that these tradeoffs won't affect the option to later choose a different two elements. Often, companies take the approach "We need to get this product to our customers quickly, and then later we will improve the quality and make it robust."

<img src="/images/WeGotItDone.jpg" alt="We Got It Done" width="520" height="388" class="aligncenter size-full" />

<strong>The Practice:</strong> At the beginning of a software product's lifecycle, the "Get It Done" philosophy usually results in the ability to move very quickly initially and ship a product or feature with a moderate speed gain. It also results in accumulating a sizable amount of Technical Debt. When the next planned feature begins development, the "Get It Done" philosophy is still the core driver for development. Therefore, rather than adapting the program to integrate nicely with the recently shipped feature, the structural flaws are reinforced.

When used later on in a software product's lifecycle, the "Get It Done" philosophy is an attempt to solve a technical problem by trying to alleviate cultural symptoms. Typically product owners feel that features, bugfixes and changes are taking too long (they are correct), and that the solution is to "work harder" and focus on "finishing things faster." This compounds the problem! By reinforcing the focus on the symptom of slow development speed rather than the cause (an inflexible and overly-complex codebase), developers are encouraged to continue adding to the growing pile of Technical Debt in order to ship one more feature.

----

<strong>The Solution:</strong> There is a much better software development philosophy. Better software paradigms are ones that look at the upstream causes of development difficulties rather than the downstream symptoms that reveal flaws in the process. A strong software development culture will have a philosophy that sounds more like this:

<strong>"Make It Great"</strong>

Since "Make It Great" is multidimensional, speed and efficiency are valuable factors properly held in tension alongside the other dimensions of software development. The best projects are not ones that are _merely_ delivered swiftly. The best projects are ones that <strong>deliver high-quality software, ahead of schedule, and below cost.</strong> This never happens when the focus is wrong, and it certainly never happens when critical steps are skipped. The three dimensions are interdependent -- they greatly affect each other!

When you architect your software well, you will find that you will be able to code quickly, make changes swiftly, and add new features without much pain. Those benefits require an emphasis on code structure and quality, and a good amount of work. <strong>There are no shortcuts</strong>. If you want to be able to get things done, you need to "Make It Great". Otherwise, you will find that the rotting code drags the team down into development hell.

Furthermore, when you are focused on a larger goal than simply completing tasks, you have time to consider the usability of your creations. Your APIs should be intuitive and simple for team members and other developers to use. Your user interfaces should be crisp, clear, and elegant. Refining those interactions takes effort. Those aren't possible when the goal is to ship the feature quickly and move on to the next one. 

<strong>Don't "Get It Done". Instead, "Make It Great".</strong>