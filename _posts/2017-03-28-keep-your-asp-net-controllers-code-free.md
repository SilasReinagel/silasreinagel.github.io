---
layout: post
title: Keep Your ASP.NET Controllers Code-Free!
date: 2017-03-28 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/asp-net-laptop.jpg
---

If you've been doing any amount of server-centric web development, you have definitely seen more than a few Web Controllers. If your experience has been like mine, often the methods on these controllers are filled with procedures that process user requests. This is absolutely wrong! Web Controllers must be kept code-free!

This rule is essential to ensure that your [application is decoupled from deployment concerns](http://silasreinagel.com/2017/03/21/independently-executable-units/), to ensure that your application itself expresses its business scenarios, and to ensure that you do not have any application complexity leaking into inappropriate parts of the codebase. 

<img src="/images/asp-net-laptop.jpg" alt="ASP.NET Laptop"   />

The Single-Responsibility Principle requires that Web Controllers should only contain code for passing Requests into the application and returning Web Responses. They should do absolutely nothing else!

----

### Offensive Controller Methods

----

I will show you examples that flagrantly violate the rule. Consider the following:

```
[HttpPost, Authorize]
public async Task<IHttpActionResult> VerifyAddress([FromBody] Address address)
{
    var zip = string.IsNullOrWhiteSpace(address.Zip5) 
        ? address.Zip 
        : address.Zip5;
	
    var validAddresses = (
        await _addressService.VerifyAddressAsync(
            address.Street, 
            address.Street2, 
            address.City, 
            address.State, 
            zip)).ToList();

    if (validAddresses.Count == 1)
        return Ok(AddressVerifyResult.FromVerified(validAddresses.First());
    if (validAddresses.Count > 1)
        return Ok(AddressVerifyResult.FromMultiple(validAddresses));
    return Ok(AddressVerifyResult.FromProposedAddress(address));
}
```

This is far from the worst offender I have seen recently. However, it has some major flaws. 

First, it performs subtle interpretations of the user's request, sometimes using one zip code field, other times using another. This means that the same method is being used to handle two different types of requests. <strong>Each method should handle one and only one type of request.</strong>

Secondly, it has control flow, where specific types of responses are conditionally built outside of the application. This business logic is coupled to Web Routing and Web Responses. <strong>Web controller methods must not contain any selection logic!</strong>

Here is another one:
```
[HttpGet]
public async Task<ActionResult> GetStoresNear(int zipCode)
{
    try
    {
        var stores = await _stores.GetStoresNear(zipCode);

        var asString = JsonConvert.SerializeObject(stores, 
            new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore,
                ContractResolver = new CamelCasePropertyNamesContractResolver()
            });

		return Content(asString, "application/json");
	}
    catch (Exception exception)
    {
        Log.ErrorWithData("GetStoresNear failed", new {zipCode}, exception);
        HttpContext.Response.StatusCode = (int)HttpStatusCode.BadRequest;
        var error = new Dictionary<string, object>
            {
                {"ErrorCode", (int)HttpStatusCode.InternalServerError},
                {"ErrorMessage", exception.Message}
            };
        return Json(error, JsonRequestBehavior.AllowGet);
    }
}
```

Where should I start?

First, the exception handling lives here in the Controller, instead of in the application, where it belongs. <strong>If users can attempt to perform invalid operations, then handling those scenarios is a business concern.</strong>

Second, our application failures are being logged by our deployment plugins. Where logging is needed, it should be injected using AOP decorations, or handled explicitly by the application itself when user requests result in execution failures. <strong>Web methods must not perform any logging!</strong>

Third, there is special serialization logic applied for this particular request. Having method-specific custom serialization is a way to ensure that your different Web Controllers will be filled with duplicate code, or, even worse, that they will be unpredictably inconsistent. <strong>If you need custom serialization, centralize it -- do not handle it in the controller!</strong>

----

### Clean Controllers

----

How can you avoid these problems? 

<strong>You are only allowed to have a single line of code in each of your Web Controller methods.</strong>

Here is a good controller method:

```
[HttpGet("{storeId}")]
public IActionResult GetAvailableBeverages(int storeId)
{
    return Ok(_stores.Get(storeId).Beverages());
}
```

You may ask yourself, doesn't this create more problems than it solves? What should we do about logging, response formatting, and error handling?

Those are precisely the right questions to ask. In fact, those <strong>design questions should be answered before any Web Controllers are created</strong>. Those are application use case questions. If it is possible for the application to throw exceptions, then the application must have user-friendly logic for how to let the user know what has gone wrong and how to resolve the situation. 

Let's evolve our `GetAvailableBeverages` use case to handle the scenarios where a user requests information about a Store that doesn't exist. We shouldn't have ASP.NET return a `500 - Internal Server Error` response -- that would be very poor design!

First, let's rework our StoreFactory to express the semantics that not all stores exist, by [returning an Optional](http://silasreinagel.com/2017/02/07/never-ever-return-null/) instead of throwing an exception when a requested Store doesn't exist. 

```
public sealed class StoreFactory
{
    ...

    public Optional<Store> Create(int storeId)
    {
        return _stores.Exists(storeId) 
            ? new Optional<Store>(_stores[storeId])
            : Optional<Store>.Missing;
    }
}
```

Next, we need an App Response that is able to express whatever what we need to communicate to users. *(Note: This is an example. In a real application you probably don't want to lose the Type information of your Response Content.)*

```
public sealed class AppResponse
{
    public ErrorType ErrorType { get; }
    public string ErrorMessage { get; }
    public object Body { get; }

    public AppResponse(ErrorType errorType, string errorMessage)
        : this(errorType, errorMessage, default(object)) { }

    public AppResponse(object body)
        : this(ErrorType.None, string.Empty, body) { }

    private AppResponse(ErrorType errorType, string errorMessage, object body)
    {
        ErrorType = errorType;
        ErrorMessage = errorMessage;
        Body = body;
    }
}
```

Finally, we create a class for our use case. 

```
public sealed class StoreBeverages : IResponse
{
    private readonly StoreFactory _stores;
    private readonly int _storeId;

    public AppResponse Get()
    {
        var store = _stores.Create(_storeId);
        if (store.IsMissing)
            return new AppResponse(
                ErrorType.NotFound, $"Unknown store: {_storeId}");
        return new AppResponse(store.Value.Beverages());
    }
}
```

At this point, our application itself now has the logic to handle various types of user input, like requesting information for Stores that don't exist. Now, if we want to express our application response using the semantics of HTTP, we can simply create a response adapter. This adapter belongs in our ASP.NET project, not in our application (which must be entirely decoupled from Web/Serialization/Databases/etc.). 

```
public sealed class AppActionResult
{
    private readonly IResponse _response;

    public IActionResult Get()
    {
        AppResponse response = _response.Get();
        if (response.ErrorType == ErrorType.NotFound)
            return new NotFoundObjectResult(response.ErrorMessage);
        return new OkObjectResult(response.Body);
    }
}
```

Our controller method now looks just slightly different:

```
[HttpGet("{storeId}")]
public IActionResult Get(int storeId)
{
    return new AppActionResult(new StoreBeverages(_stores, storeId)).Get();
}
```

What's different? Now our application itself knows about the business use cases, and knows how to handle a request for a Store that doesn't exist. We are simply adapting our AppResponse to utilize the semantics of WebAPI, including HTTP Status Codes. 

Our Web Controller is still clean and elegant. Our application now handles use cases that were previously badly designed. 

----

### Summary

---- 

<strong>The amount of code in your Web Controllers reveals the completeness of your application design.</strong> Whenever your application is missing critical business logic, you will find more and more code sneaking into your Web Controllers. Putting the code there is a big mistake! Instead, add the logic to your application, where it belongs. 

When all of your Web Controller methods contains just a single line of code, it is very hard to end up with duplicate code, write fancy serialization procedures, sneak in complex business logic, or add use-case-specific logging. <strong>Your Web Controllers exist solely for routing requests and returning HTTP Responses, nothing else!</strong>

Put in the design work you need to handle all the use cases of your application. Keep your code simple. Solve each problem exactly one. Above all, <strong>keep your Web Controllers code-free!</strong>
