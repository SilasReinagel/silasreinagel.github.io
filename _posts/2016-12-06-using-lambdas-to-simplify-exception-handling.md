---
layout: post
title: Using Lambdas to Simplify Exception Handling
date: 2016-12-06 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/IWillNotWriteDuplicateCode.jpg
---

Duplicate code is wasteful and problematic. It decreases the maintainability of software and potential leads to reliability issues. Far too often, I see duplicate exception handling blocks within a codebase. In the past, some developers might have felt that the languages required this duplication, and they were partially correct. However, in languages with anonymous functions, such as Java 8, C#, and Javascript, there is no excuse for duplicate exception handling. 

I will show you a simple and elegant way to standardize your exception handling using lambdas. Ideally, within any library or application, there should not be two identical try/catch blocks anywhere. There is absolutely no excuse for duplicate exception logic in a single source file. 

----

Imagine that you are looking at a gateway class that has many calls to some external system, like a database, or a web service. You might see code like this:

```
public List<Post> getRecentPosts() {
    try {
        return svc.getRecentPosts();
    } catch (HttpException e1) {
        logAndThrowWrappedException(e1);
    } catch (InternalServiceException e2) {
        informImportantPeople(e2);
    } catch (MyCompanyException e3) {
       throw e3;
    } catch (Exception e4) {
       throw new MyCompanyException(e4);
    }
}

public int createNewPost(Post post) {
    try {
        return svc.createPost(user);
    } catch (HttpException e1) {
        logAndThrowWrappedException(e1);
    } catch (InternalServiceException e2) {
        notifyImportantPeople(e2);
    } catch (MyCompanyException e3) {
       throw e3;
    } catch (Exception e4) {
       throw new MyCompanyException(e4);
    }
}

...
```

If you are like me, seeing code like this makes you cringe. You probably scroll down to the bottom of the file to see how many needless lines look exactly like these. Some part of you wonders why the system is so complex that you need four different catch blocks. Fixing the exception complexity might take a bit of work, but <strong>making this file clean, readable, and much smaller is quite easy.</strong> Here are the three basic steps:

<strong>1. Start by changing just a single method. Rewrite it the way it ought to look: </strong>

```
public List<Post> getRecentPosts() {
    return handleExceptions(() -> svc.getRecentPosts();
}
```

<strong>2. Next, create the non-existent method ```handleExceptions()``` and move all the exception handling logic into its new home.</strong>

```
private <T> T handleExceptions(Callable<T> func) {
    try {
       return func.call();
    } catch (HttpException e1) {
        logAndThrowWrappedException(e1);
    } catch (InternalServiceException e2) {
        notifyImportantPeople(e2);
    } catch (MyCompanyException e3) {
        throw e3;
    } catch (Exception e4) {
       throw new MyCompanyException(e4);
    }
}
```

<strong>3. Finally, change all the other methods to use the new exception handling method.</strong>

```
public int createNewPost(Post post) {
    return handleExceptions(() -> svc.createPost(post);
}
```

That should give you a clear picture of the general strategy to simplify the exception handling. However, there may be a few variations that can add some complexity. 

<strong>Adapt void return calls in order to use them with ```handleExceptions()```.</strong>

```
private void schedulePost(Post post, LocalDateTime publishTime) {
    execute(() -> svc.schedulePost(post, publishTime)));
}

private void execute(Runnable command) {
    handleExceptions(() -> {
        command.run();
        return true;
    };
}
```

<strong>Use Functional Interfaces to deal with checked exceptions (which you shouldn't have in your codebase).</strong>

```
@FunctionalInterface    // annotation is optional
private interface ServiceCallable<T> {
    T call() throws InternalServiceException;
}

private <T> T handleExceptions(ServiceCallable<T> func) { ... }
```

If you find that different gateways or service interfaces use the same exception handling strategy, then <strong>be sure to consolidate the exception handling logic in its own class</strong>. The better you consolidate your application error handling, the easier it will be to maintain your objects, understand the application functionality, debug problems, change error handling logic, and track down inconsistent error behavior. It's very hard to do that when your source code files are filled with hundreds of lines of useless noise. 

----

This is a practical guide on how to use lambdas to consolidate your exception handling. We looked at a simple and effective way to remove the duplicate code from a gateway. We looked at a couple of ways to adapt the pattern to deal with variations and complexities. 

<strong>Never let duplicate code live. Exterminate it with extreme prejudice!</strong>

If colleagues are writing duplicate try/catch blocks, stop them immediately and make them read this! Only you can prevent duplicate code. 
