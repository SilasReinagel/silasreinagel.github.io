---
layout: post
title: Messaging Conceptual Fundamentals
date: 2019-02-04 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/messages.jpg
---

Message-centric systems are naturally flexible, since they focus on the communication patterns of a system instead of concrete behaviors, they are loosely coupled, and they expose the information needed to trace data flows and replace or enrich behavioral components of the system. Building well-designed message-driven systems requires a strong understanding of general messaging patterns and message types. What are the messaging fundamentals?

<img src="/images/messages.jpg" alt="Abstract Messages Picture" />

----

## 1. Messaging Basics

----

**What is a message?**

A message is any communication of information between one sender and one intended receiver. 

A message with a single intended receiver may still be received by others, either due to relaying the message, or due to the nature of the medium.

**What is the value of a message?**

Messages are inherently flexible, replicable, and asynchronous. They are the foundations of all communication. 

**What are the chief limitations of messages?**

Messages require a shared communication protocol, and shared context. 

**How many types of message exist?**

There are a near infinite number of subtypes of messages, but only two fundamental message types.

----

## 2. High-Level Message Types

----

### Event Notification Messages

A message created solely as a one-way means of providing information. No expectations are attached. Recipients are allowed to interpret the message as they see fit. No acknowledgement is required. 

When a subtype or subcategory of Event is used, this is a means of providing additional context to the recipient. Message headers are another means of providing message context.

**Examples:**
- Sign with text: "Store Hours: 9am-5pm, M-F"
- Company email: "Donuts are available in the breakroom downstairs. First come, first serve."
- Text message to friend: "Really bad traffic... running 15 mins late."
- Void method signatures: ```void OnAppStartup(AppInfo info)```

**Aliases:** `Event`, `Notification`, `Document`
**Popular Subcategories:** `Log Events`, `Alerts`, `Warnings`, `Information`, `Event State Transfer`, `Push Notifications`
**Popular Protocols:** `UDP`

----

### Request / Response Messages

A request is a message sent with the expectation of a response message sent back to the sender. The content of the message contains the context needed to differentiate the type of response desired. 

A response is expected to be either the requested information, information about the requested information, or a reason why the request could not be satisfied. Strictly speaking, the response message is a Event Notification to the sender that the Request has been processed.

**Examples:**
- HTTP Request/Response Pair: "GET https://www.silasreinagel.com" -> SilasReinagel Blog Page
- Greeting to passing friend: "How's it going?" -> "Great!"
- Question to a vendor: "How much for 2 donuts?" -> "They are 1 dollar each"
- Function signatures: ```int Add(int first, int second)```

**Aliases:** `Query`, `Reply`
**Popular Subcategories:** `Ping`, `Transaction`
**Popular Protocols**: `TCP`, `HTTP`, `SOAP`, `RPC`, `POP3`

----

### 2b. Hybrid Message Types

----

#### Reliable-Delivery Event Notifications

In systems that aren't concerned with how recipients process messages, but that wish to ensure the message was successfully delivered, Event Notification Messages are sent as a the content of a Request Message, with the expectation of an Acknowledgement Response from the recipent, or an Error Response if the message could not be delivered to the recipient. 

In most modern communication systems, Event Notifications are sent using some form of Reliable Delivery. Pure one-way communication is rare. Conceptually, this distinction occurs at the transport level and doesn't affect the high-level messaging design. It makes it easier to reason about a system, since dropped messages don't have to be considered.

**Examples:**
- Exactly-once delivery Message Queues
- Read receipts on Messaging Applications
- To roommate: "I'm going out for the evening. Steak is thawing on the counter for dinner." -> "Ok"

----

#### Command Requests

A request sent to a recipient with the expectation of some action being taken or work performed. No response (or simply an Acknowledge Response) is expected if the work can be performed. If the work cannot be performed, then an Error Response is generally expected.

Typically, the work for any given command is expected to performed no more than once.

**Example:**
- To new recruit: "Drop and give me 50 pushups" -> "Yes, sir!"
- At donut shop: "Give me two chocolate old-fashioned donuts. Here's $2" -> Donuts + Receipt
- Database call: `void Deactivate(UserId id)` -> `throw new DbException("UserId 37 not found")`

----

## 3. Fundamental Design Tension

----

The fundamental tension that you will wrestle with in Message-Driven architectures is choosing between One-Way and Two-Way messaging patterns. The basic tradeoff is this:

----

### One-Way (Eventing)

**Pros:**
  - More robust
  - More flexible
  - More performant
  - Less data coupling

**Cons:**
  - Less traceable
  - Fewer transport guarantees
  - Difficult to resync
  - Harder to troubleshoot


----

### Two-Way (Request/Response)

**Pros:**
  - Easier to reason about
  - More traceability
  - More network robustness
  - Few data sync issues

**Cons:**
  - Fragile integrations
  - Rigid integrations
  - Less performant
  - Requires more fault-tolerance engineering
  - Client/server must evolve simultaneously

