---
layout: post
title: The Seven Aspects of Software Quality
date: 2016-11-15 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [Software Engineering]
---
Software engineering is a complex field. Good software engineers are capable of balancing opposing forces and working within constraints to create great software. Poor software developers (they really aren't engineers) are ones who are incapable of perceiving the trade-offs they are making and the implications of their design decisions (or lack thereof).

Every software engineer absolutely must know the seven aspects of software quality:

<ul>
<li>Reliability</li>
<li>Understandability</li>
<li>Modifiability</li>
<li>Usability</li>
<li>Testability</li>
<li>Portability</li>
<li>Efficiency</li>
</ul>

These seven aspects can be measured and judged for any software product. They apply to embedded systems, websites, mobile apps, video games, open-source APIs, internal services, and any other sort of software product. These aspects are entirely business domain independent. <strong>A software engineer's ability can be measured by the quality of the software he creates.</strong> Skilled engineers create high-quality software and source code.

For different projects, the prioritization of the aspects of quality will vary. Some projects should be focused on reliability, usability, and understandability, while other projects will place high importance on testability and efficiency. As a software engineer, <strong>you must know which aspects of quality are most important to your project</strong>. You must apply your best efforts towards the most critical aspects, and not spend excessive time on less important aspects.

<hr />

<strong>Reliability:</strong> Software is reliable if it behaves consistently. The functionality of a program should be predictable and repeatable. Errors should occur rarely or not at all. Errors that do occur should be handled gracefully and proactively. Users should never ask themselves whether the software will work correctly.

<strong>Understandability:</strong> The structure, components, and source code must be understandable. They must be clear. They must be well-organized. They must behave the way a developer would expect. Anything in the code that causes developers confusion reveals that the code is lacking in understandability. High-quality source code always appears simple and obvious.

<strong>Modifiability:</strong> It should be easy to add or change the behavior of a system. Flexible systems require changing very few lines of code to alter a behavior. For the expected dimensions of change, an application should have plugin points that allow the application to be used with different contextual elements. Tight coupling to an element that is expected to change is absolutely unacceptable.

<strong>Usability:</strong> Software products must be simple and easy to use. The common use cases should be as obvious and clearly presented as possible. Software should not require excessive configuration. Users should feel empowered by your software. They should not need internet searches to discover core application functionality.

<strong>Testability:</strong> The functionality of software must be verifiable. The process of testing the software must be easy. Each business use case should be directly testable. Clear verification metrics must be available. Highly testable software will ship with a comprehensive automated test suite.

<strong>Portability:</strong> Portable software is usable in different environments and contexts. It is highly reusable. Portable software is decoupled from specific operating systems, types of hardware, and deployment contexts. Extremely portable software is reusable across projects and problem domains.

<strong>Efficiency:</strong> Efficient software uses as few physical resources as possible. It is fast. It is memory-efficient. It consumes few CPU cycles. It uses little battery life. It makes few external service calls. It minimizes the number of database calls. Efficient software accomplishes as much as possible with the least amount of resources.

<hr />

As I said before, you absolutely must know these sevens aspects of software quality. You must know which of the seven aspects are most important and least important in your current projects. Your code reviews should reference these aspects. Your design meetings and discussions should explicitly involve these aspects. You must know when you are sacrificing one of these dimensions in order to improve another dimension. <strong>You must cultivate a deep awareness of software quality</strong>. It should inform and guide your designs.

Indeed, nearly all of the software practices, patterns, and methodologies that have been created in recent years are attempts to increase software quality in one or more of these dimensions. The best practices and methodologies are ones that improve multiple aspects (SOLID, TDD, XP, DDD). Those are means to an end. You must know the goal in order to adequately judge their effectiveness. Quality software is the goal.

In the complex field of software engineering, the seven aspects of software quality will be your guide. Learn them. Know them. Love them. As you work to improve in these dimensions, the quality of the software you create will consistently rise.
