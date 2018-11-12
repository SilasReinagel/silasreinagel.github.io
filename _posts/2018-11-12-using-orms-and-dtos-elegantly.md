---
layout: post
title: Using ORMs and DTOs Elegantly
date: 2018-11-12 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/data-highway.jpg
---

There has been a lot of backlash against Data Transfer structures and using Data Mapping libraries in recent years. Many have argued that neither of these have any place in a modern, elegantly-designed application. Having worked extensively with many different approaches of external data intergrations, I find that it is rather easy to use these tools correctly, while avoiding many of the downsides. I will show you how to use ORMs and DTOs elegantly. 

<img src="/images/data-highway.jpg" alt="Data travelling at high speeds along a digital highway."  />

----

### The Problem With ORMs and DTOs

----

There has been a lot of writing about the problems with [data containers](https://www.driver733.com/2018/10/08/entity-and-dto.html), [the evils of DTOs](https://www.yegor256.com/2016/07/06/data-transfer-object.html), [the problem with separating data and behavior](https://www.silasreinagel.com/blog/2017/07/18/put-the-logic-with-the-data/), and many various approaches for solving these problems, such as by using [SQL-speaking objects](https://www.yegor256.com/2014/12/01/orm-offensive-anti-pattern.html).

The chief arguments against ORM and DTOs are as follows:
1. Data structures and mappings are not Object-Oriented
2. Applications which use DTOs and ORMs typically are rigid and fragile
3. Healthy applications should be behavior-centric, not data-centric
4. Many common data access patterns are very bad for performance

All of these critiques and complaints are entirely valid. **These are all pitfalls that absolutely must be avoided when you create flexible, maintainable software designs.**  

However, all of these critiques do not mean that ORMs and DTOs are bad. They are simply misunderstood and misused. They still serve a vital purpose. **There is presently no simpler and easier mechanism for clearly communicating data between two applications.** Many of the libraries that are ideal for service-to-database integrations and service-to-service messaging use data mapping and reflection extensively. 

----

### Conceptual Clarification

----

A very serious problem with ORM and DTOs is conceptual. DTO stands for Data Transfer Object. Yet, a true Object is a behavioral entity who responds to messages and encapsulates data. A DTO is a structure who holds data, and exposes that data. Therefore, he is not an Object. He is a data container. A better name for him would be a Data Structure or a Data Container. 

Similarly, ORM stands for Object-Relational Mapper. Since ORMs almost exclusively work with mutable data structures, they are almost never used to give birth to objects. They would be better called Data Mappers, or Data Structure Mappers. 

Much of the problems and confusion around the correct usage of ORMs and DTOs would go away if this concept were clearly corrected. Whenever you hear those terms, remind yourself that you are dealing with Data Structures, and not with Objects. 

----

### Applications Should Be Composed of Objects

----

A healthy application is focused around the desired software behaviors. It should be about Customers Placing Orders, Characters Running and Jumping, Hand-Painting Lines onto Images, Adding Calendar Events with Reminders, and so forth. It should be action-oriented. Implementing these behaviors may require using data, but the data is not the important part, the behaviors are the important part. The data is part of the implementation. The how is less important than the what. 

Therefore, when designing your software, the Objects that are interacting and the behaviors they are performing should be central. They should exist in your software at as high a level as possible. **Your core application should not know about any external data integrations, or the shapes of the data that is sent to and from them.** 

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

This is a very high-level model. It's agnostic about where User data is stored. It allows for a very high-level sort of Permission granularity and matching, implemented using `Equals` and `GetHashCode`.  It allows for great flexibility where each command implementation can specify which Permissions are required. Now that we have a clean model that exposes only behavior and encapsulates data, for the implementation we need a persistent data source for both Users and Permissions.

----

### Elegant Database Integration Using ORMs and DTOs

----

Data modelling heuristics and application modelling heuristics often are very different. Sometimes data needs to be kept separate, but the application will want to use separate pieces of data cohesively. In the Infrastructure components of your application, feel free to focus on simplest way to meet the use cases of your application. Don't try to make the implementations match the database schema and tables if you don't need them modelled that way.

For the use case we are trying to satisfy, we don't actually need to know any information about a User except for his permissions. Your application might have other information about the User, like emails addresses, passwords, usernames, and so forth, but this piece of behavior doesn't need to know anything about those pieces of metadata.

Here is an example integration using [Dapper](https://github.com/StackExchange/Dapper), a beautiful high-performance ORM, created by the developers at StackOverflow, and using a integration based on [Results instead of Exceptions](https://www.silasreinagel.com/blog/2018/06/18/result-vs-exception/).

```
public sealed class SqlUsers : IExternal<UserId, User>
{
  private readonly SqlDb _db;
  
  public async Task<Result<User>> Get(UserId id)
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
3. The integration returns only Domain Objects
4. The integration receives requests only as Domain Objects

This means that the implementation benefits from all of the ease of use that some of the best ORM libraries provide. It also means the the application and its code is completely insulated from any of the implementation details. There are no rigid and fragile data structures flying all over the system. There is no coupling between the application and particular database integration code, or table schemas. 

In case you are thinking that this example is too trivial and doesn't showcase the true perils of DTOs and ORMs, here's a piece of code I recently wrote that is a much more involved scenario with a much larger amount of information.

```
public sealed class SqlBatchedGeo : IBatched<GeoId, Geo>
{
  private readonly SqlDb _db;
   
  public async Task<Result<Dictionary<GeoId, Geo>>> Get(IEnumerable<GeoId> req)
  {
    const string query = @"
      SELECT z.GeoID, z.Zip5 AS Zip, a.Line1, a.Line2, a.City, a.State, z.Zip5
      FROM Scheduling.GeoZip z
        LEFT OUTER JOIN Scheduling.GeoAddress a ON a.GeoID = z.GeoID
      WHERE z.GeoID IN (SELECT [value] FROM STRING_SPLIT(@ids, '|'))";

    var ids = string.Join("|", idsList.Select(x => $"{x}"));
    return await _db.Query<GeoRecord>(query, new { ids = ids })))
        .IfSucceeded(records => records.ToDictionary(
          r => new GeoId(r.GeoID), 
          r => r.AsGeo())));
  }
  
  private class GeoRecord
  {
    public string GeoID { get; set; }
    public string Zip { get; set;  }
    public string Line1 { get; set; }
    public string Line2 { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string Zip5 { get; set; }
    public GeoType GeoType => HasAddress ? GeoType.Address : GeoType.Zip;
    private bool HasAddress => !string.IsNullOrEmpty(State);
    
    public Geo AsGeo()
      => new Geo(new GeoId(GeoID), GeoType, new ZipCode(Zip), 
        HasAddress 
          ? new TransferAddress(Line1, Line2, City, State, Zip5)  
          : Maybe<TransferAddress>.Missing);
  }
}
```

----

### Design Conclusions

----

So, does using ORMs and DTOs for data integrations mean that you can't have elegant systems? Absolutely not! **An elegant system may use DTOs for transferring data.** They are very useful tools for transferring data between two systems! 

The critical design considerations are that while they should be used for transporting data into and out of your application, **your application should work with Objects for performing its use cases. When you do have Data Structures, keep them co-located with their integration,** since the shape of the data will change almost exactly as often as the integration will. Most of your applications will absolutely require working with external data.  

<img src="/images/cool-blue-database.jpg" alt="Futuristic sleek blue database."  />

What are the big design principles to consider, whether or not you choose to use ORMs and DTOs? 

1. **Make your application Behavior-Centric, not Data-Centric**
2. **Do not let your application be coupled to specific shapes of external data**
3. **Ensure that your data access patterns are easy to performance tune**

As long as you follow these patterns, does it matter whether you use ORMs and DTOs? It really doesn't. Use whatever libraries work best for your implementations and query patterns. Reach a team agreement about what to use, and don't worry about the details. **A good architecture will ensure that the interaction patterns in your applications are clean, regardless of which specific tools you use.** 