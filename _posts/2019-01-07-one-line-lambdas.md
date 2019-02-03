---
layout: post
title: Always Use Single Line Named Lambdas
date: 2019-01-06 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/rows-of-dominos.jpg
---

The best functions are simple, terse, and composable. When working with low-level languages, many functions are necessarily verbose and imperative. However, with today's high-level languages, there are very few reasons why any well-written function should be longer than a single line. Whenever possible, implement all your functions with just a single-line of code.

Robert Martin, in his book [Clean Code](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882/ref=sr_1_3?s=books&ie=UTF8&qid=1546801839&sr=1-3&keywords=clean+code), writes the timeless words: *"The first rule of functions is that they should be small. The second rule of functions is that they should be smaller than that."* Yegor Bugayenko has a [slightly different heuristic](https://www.yegor256.com/2014/11/03/empty-line-code-smell) on functions: *"An empty line, used as a separator of instructions in an object method, is a code smell."* When I first learned this concept, I was working at a company where most functions were 10-30 lines long. Most of the programmers seemed happy with these functions (longer ones got a fair bit of flak), and many of the programmers felt particularly proud of themselves if a method was smaller than 10 lines. 

When I first learned these rules, I wondered if perhaps aiming for just 10 lines was a bit of a cop-out. Can't functions be even smaller than that? What if 3-6 lines is the ideal function length? 


