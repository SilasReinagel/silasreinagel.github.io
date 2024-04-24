---
layout: post
title: "Working" Gets You 20% There
date: 2024-18-04 15:30
author: silas.reinagel@gmail.com
comments: true
categories: []
featured-img: /images/code-completion.jpg
---

In the realm of software development, there's a pervasive myth that once a feature is up and running, you're almost at the finish line. This couldn't be further from the truth. The initial thrill of seeing code compile and execute as intended is just the beginning. The real challenge lies in the details and the product definition that is needed after the first requirements are satisfed. This phenomenon is not just a quirky observation but a principle that can significantly impact project management and development strategies.

---
<img src="/images/code-completion.jpg" alt="Code on a computer screen with completion status bar showing 80%"/>

There is a great excitement that comes when the programmer finish the first key user story and now has the a software feature "working." However, in any non-trivial system, there is the illusion that "it works" means that it's almost done, or almost usable. 

The real challenge lies in the details that typically are implicit and unspecified.

I have two stories about to share. Both of them illustrate how the myth of "working" can set people up for disappointment, especially when they are trying to build fast.

---

Story #1:

This happened to me this past weekend and inspired me to write this post. I led a medium-size team to build a video game, and I was in the role of Lead Designer (not programmer). We built a top-down adventure game about exploring a dungeon and solving a variety of puzzles. For one of the early puzzles, we introduced a game mechanic where we want to have a large stone block that could be pushed by the player in any cardinal direction (up, down, left, or right). 

As designer, I added a ticket to the programming kanban board specifying what I wanted: "Player should be able to push the stone block in any cardinal direction." A few hours later, the programmers merged the code implemented this feature, and I was delighted! It worked perfectly. Players could now push the stone block in any of the four directions. The requirements I had specified were met, and so I could now implement all the puzzles that utilized this design.

However, not long after we added block-pushing puzzles to the game, we discovered missing requirements in the specifications. 

- Blocks could be pushed into walls
- Blocks could be pushed into or through other blocks or objects
- Blocks could be pushed accidentally if you just brushed by their corners
- Some blocks would be pushed in a different direction than the player was moving
- Some blocks could be moved to places where the player would become permanently trapped
- When a block was being pushed, the player could be launched in the opposite direction
- When a block was being pushed, the player movement could beome extremely choppy

All of these are "obvious" and "common-sense" things, but the programmers were working quickly as directed, and had intentionally not spent large amount of time doing anything that wasn't specified.

This is an example of a feature that was "working" at first and implemented according the specification, but that was not fully usable. "Working" was just the first step of a series of work needed for the feature to be sufficiently functional.

---

Story #2:

I led a software team in implementing a payment solution for an eCommerce software platform. We were requested to integrated a minimal implementation in as little time as possible that satisfied the following requirements:

- Accept Credit Card Payments
- Accept ACH Payments
- Track and Record the Statuses of those Payments
- Avoid storing or receiving any sensitive financial information

We successfully built the minimal payment integration in 2 weeks, using a specific smaller third-party payment processor solution. 

Of course, you can easily imagine which things weren't yet implemented. The long list of unimplemented essentials accrued a big pile of product debt. Here's what needed to be implemented later:

- Full refunds of payments
- Partial refunds of payments
- Not permitting over-payment of an invoice
- Multiple partial payment using different payment methods
- Handling statuses for undelivered payment webhooks
- Handling payments that the provider said failed but the customer says they were charged for
- Handling conflicting mutually-exclusive terminal payment statuses
- Retrying failed payments
- Allowing changing billing addresses
- Changing some of the payment failure messages to help non-payment-saavy users to understand them
- Voiding previously successful but reverted payments

Sometimes this process of evolving a solution from "working" to "working well" requires significant investment and iteration. It's very easy to get "working" at first, but the real challenge lies in the details and the product definition that is needed after the first requirements are satisfed.

---

All of this is well-known, academically, but it's very easy for all of us to forget. On the next project we think, "oh that's sounds simple, we can build it very quickly." There is in fact a popular principle that express this concept, which is fantastic for ensuring that we keep the right expections and set the right expectation with everyone around us, even while we work to build things quickly and efficiently.

## The 80/20 Rule

The 80/20 rule, also known as the Pareto Principle, suggests that 80% of effects come from 20% of causes. In software development, this translates to the idea that the bulk of the work (80%) is accomplished with the initial 20% of effort—getting a feature to work. However, making it work *well*—optimizing, debugging, refining—constitutes the remaining 80% of the effort.

---



