---
layout: post
title: Never Use Reference Constants
date: 2019-06-24 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/reference-documents.jpg
---

Very often in enterprise programming I come across files named XYZConstants. Files with the word "Constants" in it are always indicative of bad design! The problem with these classes is similar to the problem of Utility classes, but it's slightly different. There is a much, much better design!

<img src="/images/reference-documents.jpg" alt="Piles of unsorted business documents on a desk in bundles." />

---- 

### The Problem

----

Here is a small snippet from an offending class I came across (the real class is MUCH bigger): 

```
public static class ConfigurationConstants 
{
    public const string DECRYPTION_CERT_THUMBPRINT 
        = "DecryptionCertThumbprint";
    public const string AUTH_SERVER_AUTHORITY_URL
        = "AuthServerAuthorityUrl";
    public const string REQUIRED_SCOPES = "RequiredScopes";
}
```
As you can imagine, during the application wireup, these values are used along with a Configuration object to configure the application.

```
services.AddAuth(
    config[ConfigurationConstants.AUTH_SERVER_AUTHORITY_URL], 
    config[ConfigurationConstants.REQUIRED_SCOPES]?.Split(' '));
```

There are three major flaws with this design:
1. The usage inferred by the Constants class ensures that calling code must be complex
2. This class is unlimited in scope and will inevitably grow
3. There is a needless separation of data and behavior

----

## Elegant Design Heuristics:

1. Keep it simple!
2. Scope everything tightly, not broadly.
3. Code should emphasize behaviors, not data.

---

The biggest issue here is that clients of this code need both the constant value, and something else which contextualizes or utilizes the value.

I have written previously about some concrete ways to simplify code by [cutting out the middleman](https://www.silasreinagel.com/blog/2017/06/27/cut-out-the-middleman/) and [keeping your logic and data together](https://www.silasreinagel.com/blog/2017/07/18/put-the-logic-with-the-data/). Here we're going to do something similar. 

Currently, the problem is that the caller needs an `IConfiguration`, a constant value, and some processing logic.

The second issue is that clients of the constants also need to have their own ability to know how to use the constants, and what to do with the output. You can see in the calling code there is some data processing happening even after the constant is used to retrieve the desired data.

```
config[ConfigurationConstants.REQUIRED_SCOPES]?
    .Split(' ')
```


----

### Object-Oriented Solution

----

We can solve this by encapsulating the constant values inside an object, handling the data processing internally, and then returning the actual information the caller desires.

```
public sealed class AuthConfiguration 
{
    private readonly IConfiguration _config;

    public AuthConfiguration(IConfiguration config) 
        => _config = config;

    public string AuthServerAuthorityUrl 
        => _config["AuthServerAuthorityUrl"];
    public string[] RequiredScopes 
        => _config["RequiredScopes"]?.Split(' ');
}
```

Now, the existing constant values are not publically exposed to anything else in the application. They are encapsulated. The calling code also no longer needs to know about the constant values or how to process the data in the configuration file.

```
services.AddAuth(
    config.AuthServerAuthorityUrl, 
    config.RequiredScopes);
```

----

### Functional Solution

----

Perhaps your codebase prefers functions to objects. In that scenario, we can still encapsulate the data by providing extension methods which will operate as accessors.

```
public static class AuthConfigurationExtensions
{
    public static string AuthServerAuthorityUrl(this IConfiguration c) 
        => c["AuthServerAuthorityUrl"];
    public static string[] RequiredScopes(this IConfiguration c) 
        => c["RequiredScopes"]?.Split(' ');
}
```

Again, the existing constant values are not publically exposed to anything else in the application. They are cleanly encapsulated. 

```
services.AddAuth(
    config.AuthServerAuthorityUrl(), 
    config.RequiredScopes());
```

----

### Summary

----

Just like Utilities classes, Constants classes significantly decrease the quality of a codebase. We walked through two different solutions that make the code:

1. Simpler for clients
2. Have explicitly bounded scope
3. Emphasize the core behavior, instead of the lookup details
4. More cleanly separated at each abstraction level

Any time you see the word "Constants" in a class name, there is sure to be one or more design problems. **Use that moment as an opportunity to improve the design of your system**, by scoping things locally, and making your code emphasize the behaviors and objects in your system, instead of the data. 
