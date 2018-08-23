---
layout: post
title: Result vs Exception
date: 2018-06-18 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/exception.jpg
---

When working with business or network integrated software, errors are inevitable. It's been compellingly argued that exceptions should not be used for control flow. It's also critical to communicate the cause of the error and known solutions. One of the possible solutions this leads to is using a Result data structure. Let's look at how this differs from the conventional use of exceptions. 

<img src="/images/exception.jpg" alt="Red cube amongst grey cubes"  />

Often in Web Applications you will see something terrible like this:

```
[HttpGet]
public async Task<ActionResult> GetFinancingInfo(FinancingRequest request)
{
    try
    {
        var info = await Financing.GetFinancingInfo(
            request, LoggedInUser.Profile);
        return Json(info);
    }
    catch (Exception ex)
    {
        var code = (int)HttpStatusCode.InternalServerError};
        Log.Error("GetFinancingInformation failed", ex);
        HttpContext.Response.StatusCode = code;
        var error = new Dictionary<string, object>
        {
            {"ErrorCode", code}
            {"ErrorMessage", exception.Message}
        };
        return Json(error, JsonRequestBehavior.AllowGet);
    }
}
```

<strong>What is wrong with this?</strong>

1. There is more than one line of code in the controller. [It belongs in the application.](/blog/2017/03/28/keep-your-asp-net-controllers-code-free/)
2. The client has no good way to differentiate between different kind of errors. Why did this request fail? 
3. InternalServerError is the worst possible Http StatusCode to return. It implies a lack of understanding of the system.
4. The exception is being caught far out of the scope where the error occurred. We don't know what message the client will see.
5. Two possible types of data response are returned. The error response doesn't have the same shape as the successful response.
6. This makes more work for the developers maintaining the software, since they must troubleshoot every failure manually.

Is there a solution to this? <strong>Yes there is.</strong> 

----

### Use a Result Structure to communicate Error Information

----

In general, a result structure is a data structure that is used for messaging between objects, and explicitly contains both Content and Error Information. Here is a condensed example:

```
public sealed class Result<T>
{
    public T Content { get; }
    public ResultStatus Status { get; }
    public string ErrorMessage { get; }
}
```

<strong>To correctly build a system using Results:</strong>

1. Every exception should be caught right at the source and encapsulated in a Result with a descriptive message.
2. Every error-possible part of the system must return nothing but Results. 
3. Safe parts of the system do not need to use Results. 
4. Every application response message should be a Result.
5. Every operation which depends on another Result must itself return a Result.

Using Results instead of throwing exceptions is not an easy fix. It takes discipline and intentionality. It will change your codebase substantially, perhaps as much as migrating from Asynchronous code to Synchronous. <strong>The error-possible parts of your system will all be explicit</strong>, and working with error-possible workflow steps can be handled with cleaner syntax using methods or extension methods for Result.

----

### Why use an enum for ResultStatus?

----

It is best for a program to have a finite list of possible errors it expects. <strong>In a well-designed program, all common types of expected errors are known and explicitly expressed.</strong> Whether an enum, or a code, or a string is used is not important. What is important is a clear description of the type of error, and easy discoverability of all possible general error types.

Why is an enum or string better than a strongly-defined type? Because they aren't really a different type of thing, typed exceptions are simply aliases. Also, not using strongly-typed exceptions prevent the abuse of language features like catching particular types of exceptions and using them for control flow.

----

### Exception vs Result Workflow

----

With Exceptions

```
public async Task<SavePreferenceResponse> Execute(SavePreferenceRequest req)
{
    var now = Clock.UnixUtcNow;
    var selection = new BookingOption(req.BookingOptionId);
    var details = selection.Details();
    var key = CustomerVehicleKey.FromBookingOption(selection);

    string legacyId = "";
    try
    {
        legacyId = await _preferences.Put(key, selection);
    }
    catch (Exception e)
    {
        throw new Exception($"Unable to Save Preference due to {e}", e);
    }
    
    try
    {
        await _legacyStorage.Put(details)
    }
    catch (Exception e)
    {
        throw new Exception($"Unable to Save to legacy store due to {e}", e);
    }
        
    try
    {
        await _events.Publish(new PreferenceSaved(now, details))
    }
    catch (Exception e)
    {
        throw new Exception($"Unable to publish Saved Event to {e}", e);
    }

    return new SavePreferenceResponse { PreferenceId = legacyId };
}
```

With Result

```
public async Task<Result<SavePreferenceResponse>> Execute(SavePreference req)
{
    var now = Clock.UnixUtcNow;
    var selection = new BookingOption(req.BookingOptionId);
    var details = selection.Details();
    var key = CustomerVehicleKey.FromBookingOption(selection);

    return (await (await (await _preferences.Put(key, selection))
        .Then(async () => await _legacyStorage.Put(details)))
        .Then(async () => await _events.Publish(
            new PreferenceSaved(now, details))))
        .IfSucceeded(legacyId => new SavePreferenceResponse { PreferenceId = legacyId });
}
```

Using results means that errors are handled at the source instead of imperatively by the calling code. It eliminates early returns from methods. It leads to code that is more declarative, since the control flow is explicitly handled by the Result. 

----

### Should you use Results instead of Exceptions?

----

I've been working with Results in microservices for more than 2 years. I've tried various permutations and implementations. Results are best for microservices, since there are many types of errors that can occur, and those can be a huge pain if they aren't communicated effectively across boundaries with clarity. There are some tradeoffs, however.

**Results**
- Takes a fair bit of work to setup and use
- Works best with Functional Programming techniques
- Makes all possible errors explicit and well-communicated
- Significantly reduces error handling code duplication
- Much better client/server error communication and troubleshooting

**Exceptions**
- More familiar for most developers
- Is the prevailing design paradigm for many popular libraries
- Leads to simpler and smaller code when exceptions are genuinely rare
- Makes it harder to find and discover the true source of errors, even when using StackTrace
- Works best with imperative programming styles

For standalone applications with fewer integrations, it's probably better to just use exceptions. For game development and tightly-scoped libraries, it's better to use neither results nor exceptions. When working with distributed software where transient errors are frequent, and cross-service debugging and tracing is harder, using Results is the best way to go. 
