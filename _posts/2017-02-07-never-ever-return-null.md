---
layout: post
title: Never Ever Return Null!
date: 2017-02-07 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/WaiterEmptyPlate.jpg
---

Have you ever asked an object or library for a resource and got a NullReferenceException when you went to use the resource? I have. Nothing breaks my trust as much as code that unexpectedly returns nothing. That sort of code forces developers to litter their code with nasty bits of defensive logic!

Don't ever return null! There are much better solutions. Returning null is a clear sign that you don't respect other developers, and that you don't know how to design your APIs for expected use cases. 

----

Consider the following code:

```
public void SetUserEmail(int userId, string emailAddress)
{
    User user = _userRepository.LoadUser(userId);
    user.Email = emailAddress;
    _userRepository.SaveUser(user);
}
```

This code is awful for a lot of reasons! The biggest issue is that it doesn't express what happens if a particular `User` isn't found. Walter, the overworked developer who wrote this code is going to end up with a production bug due to a `NullReferenceException`. His mistake was trusting the awful `UserRepository` object. 

<img src="/images/WaiterEmptyPlate.jpg" alt="WaiterWithEmptyPlate" width="700" height="400" class="size-full" /> 

Before we improve it, let's see how Walter should have written his code in order to work with the treacherous `UserRepository`:

----

## 1. Require Caller Null-Checking 

```
public void SetUserEmailIfExists(int userId, string emailAddress)
{
    User user = _userRepository.LoadUser(userId);
    if (user == null)
        return;
        
    user.Email = emailAddress;
    _userRepository.SaveUser(user);
}

// UserRepository.cs
public User LoadUser(int id)
{
    return _dbUsers.SingleOrDefault(e => e.Id == id);
}
```

Letting Walter experience an unexpected `NullReferenceException` is absolutely the worst possible way we could design our API. <strong>If Walter requests a resource, a real resource should be returned to him.</strong> It is very disrespectful for us to return nothing, when something was requested. At the very least, if we can't give Walter what he requested, we should let him know why. 

----

## 2. Require Caller Exception Catching

```
public void SetUserEmailIfExists(int userId, string emailAddress)
{
    try
    {
        User user = _userRepository.LoadUser(userId);
        user.Email = emailAddress;
        _userRepository.SaveUser(user);
    }
    catch (NotFoundException ex)
    {
        return;
    }        
}

// UserRepository.cs
public User LoadUser(int id)
{
    User user = _dbUsers.SingleOrDefault(e => e.Id == id);
    if (user == default(User))
        throw new NotFoundException($"User not found. Id: '{id}'")       
    return user;
}
```

This is mild improvement. It will never return null. However, unless we are working in a language with checked exceptions, Walter won't know that a `NotFoundException` will be thrown. Also, this forces Walter to use exceptions for control flow, which is a terrible practice. <strong>Exceptions should never be used for control flow!</strong>

----

## 3. Null Object Pattern

```
public void SetUserEmail(int userId, string emailAddress)
{
    User user = _userRepository.LoadUser(userId);
    user.Email = emailAddress;
    _userRepository.SaveUser(user);
}

// UserRepository.cs
public User LoadUser(int id)
{
    User user = _dbUsers.SingleOrDefault(e => e.Id == id);
    if (user == null)
        return User.None;   
    return user;
}

public User SaveUser(User user)
{
    if (user.Equals(User.None))
        return;
    
    ...
}
```

This solution makes it easier for Walter's code to work without any obviously problems. It works perfectly when a user exists, and it doesn't throw any exceptions when a user doesn't exist. However, when Walter's boss asks him why a customer is having troubles changing his email address, it's going to take a bit of work for Walter to track down the problem. <strong>There is no indication to Walter that nothing is done when a user isn't found in the database.</strong>

Let's try explicitly expressing the fact that a user might not exist.

----

## 4. Return an Optional Object

```
public void SetUserEmailIfExists(int userId, string emailAddress)
{
    Schrodingers<User> user = _userRepository.LoadUser(userId);
    if (user.IsDead)
        return;
    
    user.Email = emailAddress;
    _userRepository.SaveUser(user);
}

// UserRepository.cs
public Schrodingers<User> LoadUser(int id)
{
    return new Schrodingers<User>(
        _dbUsers.SingleOrDefault(e => e.Id == id));
}

// Schrodingers.cs
public class Schrodingers<T>
{
    private readonly T _obj;

    public Schrodingers(T obj)
    {
        _obj = obj;
    }

    public bool IsDead => 
        EqualityComparer<T>.Default.Equals(_obj, default(T));

    public T Value
    {
        get
        {
            if (IsDead)
                throw new IsDeadException();
            return _obj;
        }
    }
}
```

Our `UserRepository` is now explicit about the fact that for any `userId` a `User` may or may not exist. It also results in a thrown exception if Walter tries to use the user without ensuring that it is present.

However, it still forces Walter to write more code than ideal. Let's see if we can make life easier for him. 

----

## 5. Caller Delegates Behavior

```
public void SetUserEmailIfExists(int userId, string emailAddress)
{
    _userRepository.Update(userId, user => user.Email = emailAddress, 
        () => _logger.Warn($"Missing user, id: '{id}'"));
}

// UserRepository.cs
public void Update(int id, Action<User> ifExists, Action ifMissing)
{
    User user = _dbUsers.SingleOrDefault(e => e.Id == id));
    if (user == null)
        ifMissing.Invoke();
        
    ifExists.Invoke(user);
    SaveUser(user);
}
```

This solution is elegant. We explicitly require Walter to declare what should happen when a user is present and when a user is missing. He no longer has to write ugly try/catches, defensive checks or evaluative logic. We reduce the amount of code needed for both scenarios. No exceptions are thrown or caught. 

<img src="/images/HappyChef.jpeg" alt="HappyChef" width="300" height="400" class="aligncenter size-full />

---- 

## Never, Ever, Ever Return Null!

----

Returning null is one of the very worst things you do can when you write code that other people will use. <strong>Returning null is a symptom of laziness and lack of design.</strong> There are plenty of solutions that don't require returning null, including throwing exceptions, returning objects that express the two possible scenarios, using the Null Object pattern, and allowing the caller to concisely provide his own code for the different scenarios. 

Write your API so that it expresses all of the common scenarios, does not surprise a caller with hidden requirements, and does not require ugly bits of defensive code to be littered all over the place. Let your APIs provide top quality service and delight all of your users.

There is zero excuse for ever returning null. It is irresponsible and lazy. Don't force Walter to do the work you should have done. <strong>Never, ever, ever return null!</strong> 
