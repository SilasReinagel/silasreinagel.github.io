---
layout: post
title: The Practical Value of TDD
date: 2016-09-17 22:32
author: silas.reinagel@gmail.com
comments: true
categories: [Software Engineering, tdd]
---
Programming is a practical discipline. There are no silver bullets. The effectiveness of different techniques varies in usefulness, depending on the tools, the team, and the development environment.

Test-Driven Development (TDD) is still a controversial practice. For many developers, they dislike TDD because they lack discipline. They would rather just cobble together some code and mark their task complete. However, there are also a small number of experienced developers who have used TDD and find that it does not offer them much value. Their perception is usually accurate. For any practice, the practice itself is not what matters -- it is the value which the practice provides which matters. If TDD offers value, then what matters is the value it offers, not the mechanism by which we attain that value.

TDD offers two primary practical values.

----

### 1. TDD focuses on the Problem Space

----

The first law of TDD is: You may not write any production code until you have a failing unit test. What this means is that you first must write some code that calls the new functionality, before you can begin coding it. This forces you to decide how you will interact with your program.

Your first lines of test code define the API and usage syntax:

{% highlight java %}
GzipCompressor compressor = new GzipCompressor();
byte[] sBytes = compressor.compress("SampleLine".getBytes());
{% endhighlight %}

<strong>This is extremely valuable since it forces you, as a developer, to think about the problem you are solving, and not about how a computer works.</strong>

This paradigm is not natural to most programmers. Since programmers spend most of their mental energy focusing on solving the problem of getting the computer to do specific things, their minds are trained to think about problems bottom-up. This creates an intrinsic conceptual separation when the programmer tries to implement a feature. The client is trying to solve a business problem, such as how to track a multi-package shipment or display album information on their website, and the developer's mind immediately begins thinking about databases, data protocols, service interfaces, booleans, bytes, strings and arrays.

TDD offers a new mental frame. It teaches programmers to think about problems top-down. Since strict adherence to the laws of TDD means that you cannot begin thinking about specific code implementations until you have tests, you focus on what behavior the software will provide. This leads to much more clear, intuitive, and expressive code. It preempts the possibility of optimizing early or mindlessly applying certain design patterns.

----

### 2. TDD yields a Comprehensive Automated Test Suite

----

The other big benefit is the ability to ensure the behavior of your software. This offers the most value when you are working with a team or building anything larger than a small program. They are also extremely useful in a small program which is changed or improved frequently.

Following the laws of TDD will always result in a suite of tests that covers virtually every line and logic branch in your program. If you wrote them well, they will be simple, easy to read, reliable, and very fast. They will document precisely what your program is expected to do, what sorts of varying inputs are allowed, what sorts of errors may occur, and how your components are constructed.

Whenever you want to know for certain if your code handles all of the designed use cases, you can simply run your test suite and get rapid feedback.

* Add new functionality and want to ensure that you didn't break something elsewhere in the program? Run your tests.
* Merge with another commit and need to validate that you merged correctly? Run your tests.
* Experimenting with a better plugin or new library? Run your tests.
* Ready to release a new version? Run your tests and ship it.

Creating a test suite that you can trust isn't easy. It takes disciplines, dedication and hard work. But the result is that you and your team can ensure the quality of software with minimal effort.

To gain all of the benefits of Continuous Integration, you absolutely must have a comprehensive suite of automated tests. I know of no better practical way to end up with a trustworthy and comprehensive suite of tests than the discipline of TDD.

----

I'm a practical programmer. You probably are, too. The only useful programming practices and disciplines are the ones that offer practical value.

The two primary values of TDD are that it forces you to focus on the problem you are solving instead of the technological details of the solution, and that it yields a comprehensive automated test suite. These are certainly not the only benefits TDD offers, but they seem to be the most important ones.

Presently, Test-Driven Development seems to be the simplest and most efficient way to gain these two values.
