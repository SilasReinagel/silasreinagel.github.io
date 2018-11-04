---
layout: post
title: Using ORMs and DTOs Elegantly
date: 2019-11-06 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/pipeworks.jpg
---

There has been a lot of backlash against Data Transfer structures and using Data Mapping libraries in recent years. Many have argued that neither of these have any place in a modern, elegantly-designed application. Having worked extensively with many different approaches of external data intergrations, I find that it is rather easy to use these tools correctly, while avoiding many of the downsides. I will show you to use ORMs and DTOs elegantly. 

----

### The Problem With ORMs and DTOs

----

There has been a lot of writing about the problems with [data containers](https://www.driver733.com/2018/10/08/entity-and-dto.html), [the evils of DTOs](https://www.yegor256.com/2016/07/06/data-transfer-object.html), [the separation of data and behavior](https://www.silasreinagel.com/blog/2017/07/18/put-the-logic-with-the-data/), [how to effectively create SQL-speaking objects](https://www.yegor256.com/2014/12/01/orm-offensive-anti-pattern.html), and many various approaches at how to solve this problem.

The chief arguments against ORM and DTOs are as follows:
1. Data structures and mappings are not Object-Oriented
2. Applications which use DTOs and ORMs typically are rigid and fragile
3. Healthy applications should be behavior-centric, not data-centric
4. Many common data access patterns are very bad for performance

All of these critiques and complaints are entirely valid. **These are all pitfalls that absolutely must be avoided when you create flexible, maintainable software designs.**  

However, all of these critiques do not mean that ORMs and DTOs are bad. They are simply misunderstood and misused. They still serve a vital purpose. There is presently no simpler and easier mechanism for clearly communicating data between two applications. Many of the libraries that are ideal for service-to-database integrations and service-to-service messaging use data mapping and reflection extensively. 

----

### Conceptual Clarification

----

A very serious problem with ORM and DTOs is conceptual. DTO stands for Data Transfer Object. Yet, a true Object is a behavioral entity who responds to messages and encapsulates data. A DTO is a structure who holds data, and exposes that data. Therefore, he is not an Object. He is a data container. A better name for him would be a Data Structure or a Data Container. 

Similarly, ORM stands for Object-Relational Mapper. Since ORMs almost exclusively work with mutable data structures, they are almost never used to give birth to objects. They would be better called Data Mappers, or Data Structure Mappers. 

Much of the problems and confusion around the correct usage of ORMs and DTOs would go away if this concept were clearly corrected. Whenever you hear those terms, remind yourself that you are dealing with Data Structures, and not with Objects. 

----

### Applications Should Be Composed of Objects

----

A healthy application is focused around the desired software behaviors. It should be about Customers Placing Orders, Characters Running and Jumping, Hand-Painting Lines onto Images, Adding Calendar Events with Reminders, and so forth. It should be action-oriented. Implementing these behaviors may require using data, but the data is not the important part, the application's behaviors are the important part. The data is part of the implementation. The how is less important than the what. 

Therefore, when designing your software, the Objects that are interacting, and the behaviors they are performing should be central. They should exist in your software at as high a level as possible. Your core application should not know about any external data integrations, or the shapes of the data that is sent to or from them. 

If you have an application that requires certain permissions for users to perform various actions, this can be modelled as a User Entity.

```
public sealed class User 
{
	private readonly HashSet<Permission> _permissions;
	private readonly UserId _id;
	
	... ctor ...
	
	public Response Execute(IUserCommand cmd)
		=>_permissions.Any(cmd.RequiredPermissions)
			? cmd.Execute(_id);
			: Response.Forbidden($"User {_id} does not have permission to perform {cmd}");
}
```

This is a very high-level model. It's agnostic about where User data is stored. It allows for a very high-level sort of Permission granularity and matching, implemented using `Equals` and `GetHashCode`.  It allows for great flexibility where each command implementation can specify which Permissions are required. Now that we have a clean model that exposes only behavior and encapsulates data, in order to implement this, we need a persistent data source for both Users and Permissions.

----

### Elegant Database Integration Using ORMs and DTOs

----

Data modelling heuristics and application modelling heuristics often are very different. Sometimes data needs to be kept separate, but the application will want to use separate pieces of data cohesively. In the Infrastructure components of your application, feel free to focus on simplest way to meet your application's use cases. Don't try to make the implementations match the database schema and tables if you don't need them modelled that way.

For the use case we are trying to satisfy, we don't actually need to know any information about a User except for his permissions. Your application might have other information about the User, like emails addresses, passwords, usernames, and so forth, but this piece of behavior doesn't need to know anything about those pieces of metadata.

Here is an example integration using [Dapper](https://github.com/StackExchange/Dapper), a beautiful high-performance ORM, created by the developers at StackOverflow, and using a integration based on [Responses instead of Exceptions](https://www.silasreinagel.com/blog/2018/06/18/result-vs-exception/).

```
public sealed class SqlUsers : IExternal<UserId, User>
{
	private readonly SqlDb _db;
	
	public async Task<Response<User>> Get(UserId id)
	{
		const string sql = @"
			SELECT PermissionName 
			FROM UserPermissions 
			WHERE UserID = @userId";
			
		return (await _db.Query<UserPermissionsRecord>(sql, new { userId = id.AsInt() }))
			.IfSucceeded(records => new User(id, new Permissions(records.Select(r => r.AsPermission());
	}
	
	private class UserPermissionsRecord 
	{
		public string PermissionName { get; set; }
		
		public Permission AsPermission()
			=> new Permission(PermissionName);
	}
}
```

The important things about this design are:
1. The Data Structure is private, and not permitted into the application
2. The SQL-Speaking Object uses ORM
3. The integration communicates only using Domain Objects











