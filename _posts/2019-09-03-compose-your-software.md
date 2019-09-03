---
layout: post
title: Compose Your Software
date: 2019-09-03 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/composing-hexagons.jpg
---

For any non-trivial program to grow in maintainable manner, it must be composed of structures, and small substructures, and even smaller substructures. There are several different prevailing paradigms about HOW you should compose your software. Here is a brief overview of the different types of software composition.

<img src="/images/composing-hexagons.jpg" alt="Interchangeable hexagons, representing software modularity." />

----

## 1. Uncomposed Software

----

Uncomposed software is really the only **wrong** way to build your software. 

Uncomposed software consists of very large files, classes, methods, functions, etc. 

In uncomposed software, there is no separations of concerns. There typically are problemmatic crossings of domain boundaries. Leaky abstrations. 

Things are connected, but not composed. 

The code of uncomposed software has many shapes, but all of them structurally look like a [Big Ball Of Mud](https://en.wikipedia.org/wiki/Big_ball_of_mud).

----

## 2. Procedural Composition

----

Procedural programming is giving a linear set of instructions to a computer. It's one of the most common ways software is composed, since it's closest to how the computer itself operates at a machine level.

Good procedural code has a clean separation of abstraction layers and reads like a good recipe.

Its shape is a top-to-bottom flat list.

<img src="/images/procedural-composition.JPG" alt="Procedurally composed code." />

It's a clean, ordered list, of high-level instructions. Each subroutine is also a clean, ordered list, of high-level instructions.

Any iterations are put in their own subroutines. 

Any control flow decisions are put into their own subroutines.

This is what good, clean Procedural Composed code looks like.

----

## 3. Functional Composition

----

Functional composition is about declaring the whole application as a single operation which takes one input and yields one output. The metaphor for function programming is a Pipe. It allows for unidirection data flow, while forbidding reassignments, mutations and side effects.

Good functional code has a clean separation of abstraction layers, lots of small, pure, well-named functions. Since it uses small scopes, often its variable names are shorter, since there is no ambiguity.

Without linebreaks for visual separation, its shape is a train with a number of cars connected.

<img src="/images/functional-composition-pipe.JPG" alt="Functional composed code." />

With linebreaks for visual separations, it looks different, but notice that each function is connected to the next function. The composed function (`CalculateDrivingDistance`) is declared as the final result of the chained sub-functions. 

<img src="/images/functional-composition-linebreaks.jpg" alt="Functionally composed code with line-breaks." />

It's a clean declaration of a higher-order functions, composed out of many smaller functions, most of which take 0, 1, 2, or 3 arguments. 

When multiple states are possible, functional code uses union types such as `Maybe` or `Result` to represent the possible states.

----

## 4. Object-Oriented Composition

----

Object-oriented composition is about declaring your application as a set of objects, each of whom fulfills contractual jobs as defined by their interfaces, and each of whom fully encapsulates its own data, sharing it with no other objects.

Good object-oriented code has clean, [small](https://www.silasreinagel.com/blog/2017/02/21/make-your-interfaces-small/), [abstract](https://www.silasreinagel.com/blog/2017/05/09/make-your-interfaces-abstract/) interfaces, strong domain language, is cleanly composable, and assigns each object simple and clear jobs.

Composed object-oriented code always looks like a slope or a diagonal line. 

<img src="/images/object-oriented-composition.JPG" alt="Object-oriented composed code." />

It's a clean composition of small objects, each with one clear job, as expressed by their names. 

Composing objects together in flexible ways requires clear abstract interfaces, and use of the [Decorator pattern](https://sourcemaking.com/design_patterns/decorator). 

Once an object is composed, he is simply given instructions to execute his job, often with a command like `Go` or, when he returns a result, with a query like `Get`. 

----

## Compose Your Software

----

Are you working with composable software?

The easiest way to tell is to look at the shape of the code. 

You can obviously see well-composed software since it almost exclusively is composed of straight lines. 

<img src="/images/all-types-of-composition.jpg" alt="Object-oriented composed code." />

- Good procedural composition looks like a vertical line.
- Good function composition looks like a horiztonal line.
- Good object composition looks like a diagonal line.

If you see other shapes, then it's likely that there are structural oddities in the code. You will likely find corresponding oddities in the business process, or in the discipline or understanding of the programmers. 

No matter which style of composition you and your team prefer: 

**Compose your software.**

**Compose it well.**

----

Do you see interesting shapes in your codebase? **Share them in the comments.**
