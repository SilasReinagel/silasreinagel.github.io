---
layout: post
title: Make Your Interfaces Small
date: 2017-02-21 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/escher-business.jpg
---

Well-designed interfaces are a delight to read, use, and implement. The really elegant ones stick in your brain and satisfy your artistic yearnings. They possess beauty similar to a math theorem or a law of physics. To be an effective software craftsman, you must be very good at designing interfaces.

Elegant interfaces are succinct. They do not contains a lot of uncomposed elements and dissimilar use cases.

<img class="size-full aligncenter" src="/images/escher-business.jpg" alt="Confusing Options" width="700" height="400" />

```
public interface IDealRepository
{
    bool OptOutOfDeal(long dealId);
    List<Deal> GetSignedDeal(long dealId);
    string GetSigningStatusById(long dealId);
    void UpdateDealDate(long dealId, DateTime dealDate, Guid userID);
    bool UploadDealTerms(long dealId, List<DealTerm> terms);
    string GetSigningRoomUrl(long dealId, string fullName, string email);
    string GetSigningRoomUrl(long dealId, UserProfile userProfile, string role);
    void RemoveCurrentDeal(long dealId);
    string GetDealDocumentKey(string dealType);
    string GetSigningStatus(long vendorTransactionId);
    List<DealPdf> GetSignedDocumentsById(long dealId);
    List<DealPdf> SplitLargeDealDocument(DealPdf dealPdf, int pagesPerDoc);
    bool UploadDealDocuments(long dealId, List docs);
}
```

This interface is a tangled mess! It has tons of methods. There are wildly diverging categories of use cases. The method cohesion is extremely weak. The input and outputs vary wildly. <strong>Scattered design is typical for a lengthy interface.</strong>

Whenever you have a long interface, it is inevitable that it will not be well-designed. It is very tempting to add new methods to an interface that seems to have a similar context. It takes work to determine who the users of an interface are, and what they need. If you want to create an elegant interface, the first rule is to keep it short. This forces you to make challenging decisions up front.

----

<strong>A good interface has one to four methods.</strong> It never has zero. A single method interface is the very best. Single method interfaces are crisp, tight, portable, easy-to-use, and in many cases, timeless. The most commonly used interfaces are single method: IEnumerable, IDisposable, Runnable, Function, etc.

Two method interfaces are also often very elegant. Whenever there are inverse operations, a two method interface makes a lot of sense. Here are some gorgeous two method interfaces:

```
public interface IIoService
{
    void SaveToFile(string filePath, T obj) where T : new();
    T LoadFromFile(string filePath) where T : new();
}
```

```
public interface ICryptography
{
    string EncryptString(string input);
    string DecryptString(string input);
}
```

```
public interface IObservable
{
    void Subscribe(IObserver observer);
    void Unsubscribe(IObserver observer);
}
```

If an interface has five or more methods on it, there is nearly always a way to improve the design. <strong>It's not terrible to have a few interfaces with five or six methods, but you should keep a close eye on them.</strong> They might be lured by the darkside at any moment!

----

When you are counting the number of methods, don't forget to include any extended interface methods as well. Those methods must be implemented by any new concrete class. Each extension makes an interface a little more weighty and a bit more complex. For example this interface secretly has 6 methods:

```
public interface ITimer : IObservable, IDisposable
{
    void Start();
    void Stop();
    void Reset();
}
```

----

For a particularly egregious offense, take a glance at the least usable interface I have ever seen: <a href="https://docs.oracle.com/javase/7/docs/api/java/sql/Connection.html">java.sql.Connection</a>. No interface source file should ever exceed 1000 lines -- it's totally insane! No one will ever implement that. They won't be able to, even if they wanted to.

Succinct interfaces are the best! Your interface design skills will increase dramatically simply by making your interfaces as small as possible. <strong>Make your interfaces small!</strong>
