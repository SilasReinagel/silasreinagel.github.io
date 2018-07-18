---
layout: post
title: Eight Projects You Shouldn't TDD
date: 2017-11-27 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/chemist-test.jpg
---

Test-driven development is still a hotly debated design methodology. Is it valuable? Is it harmful? Does it cost more than it saves? I will tell you which projects you should not develop test-first. 

<div class="container"><img src="/images/chemist-test.jpg" alt="Should I Test This?"  /></div>

From my experiences on a broad array of software projects, here are the types of projects where I have found test-driven development is harmful or wasteful. 

----

### 1. Projects that have no bugs

Tests are only helpful if your project has bugs or will have bugs in the future. If the code is perfect and the software always behaves as expected, tests don't offer much benefit. Keep writing flawless code and don't waste time with tests. 

----

### 2. One-shot projects that will not be maintained

When you are throwing together a piece of software for a very short contract, a hackathon, a game jam or similar project, the cost of tests isn't worth it. Just slap the code together, ship the product as fast as possible, and never touch it again. 

----

### 3. Solo projects that aren't going to be shown to others

If you are working all by yourself, then you don't need tests. When there are bugs, you will know the codebase well enough that you can find and fix them easily. Tests are valuable to communicate unexpected use cases and complex edge cases (such as a double discount on the third Wednesday of every odd-numbered month rule). No team? No need for tests. Besides, no one is ever going to see it. 

----

### 4. Projects that have no functionality

When your software does something entirely trivial like receive web requests and read/write directly to/from a database, there isn't much that can go wrong. Tests are more useful when there are various types of activities for your system to perform. Don't bother with tests. 

----

### 5. Visual projects that consist entirely of presentation

Creative projects that are designed to impress customers are primarily visual. Coloring, layouts, typeface selection, animations and flashy transition effects are gorgeous, but they are best left to a creative eye. Writing tests for visual experiences is challenging, and too constraining. Spend your time making it look as pretty as possible. 

----

### 6. Extremely small projects

If you can write the code for the whole project in a couple days, then the code is small enough that there aren't a lot of places for bugs to hide or complex logic to accumulate. You could rewrite the whole project in the time it would take you to write all those tests. Ship it. 

----

### 7. Research projects that will never be released to users

Software to analyze data for business consumption or test the feasibility of some new application can be invaluable. The purpose of these projects is to learn something, not to produce something. Unless you need tests to ensure that your logic is right, don't waste time testing. Focus your energies on exploring the problem and solution spaces.

----

### 8. Projects created by programmers who don't know design fundamentals

Without good design, software projects will age poorly and need to be replaced. If you are working on a project with a team that doesn't have a solid grasp of design fundamentals, any tests that are written will just become tech debt (in addition to the code itself). Spend your efforts on training instead. 

----

If your project is on the list above, then don't waste time with tests. You will be better served focusing on the primary value. 

**For all other projects, TDD is the best approach.** 
