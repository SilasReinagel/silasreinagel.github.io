---
layout: post
title: Type Erasure is a Failed Experiment - Type Integrity
date: 2016-10-17 14:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/pink-eraser.jpg
---

In part one, we introduced the topic of Type Erasure, looked at an imaginary conversation with C# and the same conversation with Java, and delved into some of the problems with Java Generics. If you haven't read that, go back and read it before you read this post.  

As someone who loves generics, I like to be able to abstractly solve general problems. It's nice to work with a language which empowers that paradigm. C# does it very well. Java, because of the peculiar experiment with Type Erasure, forgets too much. It doesn't fail fast, and it doesn't keep your data types pure in various scenarios. There are ways to get around some of these big problems, but Java forces its developers to consider and deal with the complexity, rather than encapsulating all those concerns and offering clean syntax and a reliable implementation for generics. 

---- 

### Types, Casting, and Collection Content Integrity

----

Consider the following Java code:

```
List<String> names = new ArrayList<>();
names.add("Bob");
String bob = names.get(0); 
```

The above example looks clean. You create a List of Strings, and then add and retrieve the string "Bob". It works great. The syntax is very reasonable. 

However, it's a big lie! The apparent functionality that the code above describes is very different than what it compiles to. Indeed, most of it is syntactic compile-time sugar provided by Java. Here's the equivalent compiled code:

```
List names = new ArrayList();
names.add("Bob");
String bob = (String)names.get(0);
```

Ummm... what? Why is there casting? Why does List not have a type of contents? You can thank Java's Type Erasure. At compile time, Java will restrict methods based on generic types, but at runtime, there is no such protection. Every time you instantiate a List, (or any other generic object), Java immediately forgets about any types you have specified. It is only capable of using typed objects by casting them when they are retrieved. 

That means that there is literally no runtime difference between the following objects: `List<String>`, `List`, `List<RpcRequestHandler>`, `List<Object>`

Because of this, we can do some pretty crazy things, such as putting an Integer into a (conceptually) List of Strings.

```
List<String> names = new ArrayList<>();
names.add("Bob");
List namesAsUntypedList = (List)names;
namesAsUntypedList.add(5);
```

As counterintuitive as this seems, it will compile and execute perfectly. To give Java some credit, you will get a compiler warning: "Unchecked call to 'add(E)' as member of raw type 'java.util.List'". You could say this is a fault of the programmer, who is writing code with compiler warnings. But, you also could say that if Java wasn't so forgetful, this scenario would be impossible or would at least throw a runtime exception. 

Conceptually, it would be much nicer if a List of String was actually a List of String, and not just a List who is temporarily constrained to work with Strings.

For single-computer applications that have no external data sources and follow proper coding practices, this isn't a big problem. Just follow the compiler rules and everything will work great. 

----

### Serialization

----

It gets more complicated if you have external data sources, differing versions of external libraries, or service calls with serialization (especially binary serialization). 

We'll use some very simple examples here, but you can picture us using arbitrarily complex generic objects in an enterprise service-oriented application suite. Suppose we are writing a client gateway for a service with the following data response object. 

```
public class LoginResponse
{
    public String SessionToken ...
	public List<Long> Permissions ...
}
```

Suppose that the Login Team decides to move the evaluation logic to the client-side and expose hashed strings for the permissions.

```
public class LoginResponse
{
    public String SessionToken ...
	public List<String> Permissions ...
}
```

With the service change, you would think that if someone forgot to update their Client application, they would get a nice exception when deserializing the LoginResponse. List<Long> and List<String> are incompatible. You cannot deserialize a String to a Long, and you cannot deserialize a List<String> to List<Long>.

### C# Server/Client Mismatch

```
// v1.1 Server Serialization
var permissions = new List<string> { "180-514895645-3156" };
var permissionBytes = ToBytes(permissions);

// v1.0 Client Deserialization
var permissionLongs = FromBytes<List<long>>(permissionBytes);
```

As expected, when the client attempts to get the List<long>, the following exception is thrown: `System.InvalidCastException: Unable to cast object of type 'System.Collections.Generic.List'1[System.String]' to type 'System.Collections.Generic.List'1[System.Int64]'.`

### Java Server/Client Mismatch

```
// v1.1 Server Serialization
List<String> permissions = new ArrayList<>();
permissions.add("180-514895645-3156");
byte[] permissionBytes = toBytes(permissions);

// v1.0 Client Deserialization
List<Long> permissionLongs = fromBytes(permissionBytes);
```

The above code will execute without an exception. The object will be deserialized. The client application will not realize there is anything wrong until a bit later. Once the client application tries to access a Permission element, the application will blow up.

```
long firstPermission = permissionLongs.get(0);
```

The following error will be logged: `java.lang.ClassCastException: java.lang.String cannot be cast to java.lang.Long`. Why didn't it fail when we received the invalid object, rather than waiting until we went to use it? Because of Type Erasure. So much for the fail-fast philosophy.

----

### Summary

----

The primary benefit of statically-typed languages is that one can use pure logic to reason about Types. Type Erasure works at cross-purposes to that goal, by forgetting about things that we need to reason about. It's nice to know for certain that a List<Sandwich> will contain only Sandwiches and objects that are subtypes of Sandwiches. In Java, most of the time you can still safely assume it, but you never know for certain that a List<Sandwich> doesn't have a MonkeyWrench in it -- you just don't know for sure. 

Between this and the previous look at Type Erasure, it's obvious that Type Erasure is a terrible idea. The fact that Java retains zero runtime information about generic types makes it harder to reason about types, harder to use generics correctly, harder to ensure that your external data is accurate, harder to create reusable generic patterns, and harder to use generics with serialization correctly. 

There are solutions to all of these complications, and ways to avoid each pitfall. In all fairness, most of the solutions will force you to be a better programmer and avoid certain problematic programming patterns. However, they definitely offer needless complexity and force the programmer to solve these sorts of problems, rather than offloading that complexity by encapsulating it. Type Erasure is a failed experiment. Type Erasure completely violates the implicit contract of a statically-typed language. 