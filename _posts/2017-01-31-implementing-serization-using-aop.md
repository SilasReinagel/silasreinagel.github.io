---
layout: post
title: Implementing Serialization Using AOP
date: 2017-01-31 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/complex-simple.jpg
---

Well-designed objects do one thing, one thing well, and one thing only. They are not burdened by external concerns. They are not cluttered with things that should be the responsibility of another object. The domain objects in your application should be strictly concerned with the business problem. Unless you working for a technology solutions company, there should not be any code related to serialization, transfer protocols, user permissions, or database persistence in your application core. <strong>Keep your objects clean and tightly-designed!</strong>

In case your objects are polluted with these concerns, I will show you what I do to decouple them from serialization concerns. Examples are in C#. 

----

## Polluted Objects

----

It starts innocently enough with just an explicit attribute, and the requirement to expose public property setters. 
```
[Serializable]
public class Pixel 
{
    public int X { get; set; }
    public int Y { get; set; }
}
```

Some objects may have custom deserialization attributes/annotations. These are fine for messaging objects in your integration layer, but they should not exist in your domain. 

```
public class Poll
{
    [JsonProperty("pollid")]
    public int PollID { get; set; }
    [JsonProperty("question")]
    public string Question { get; set; }
    [JsonProperty("start")]
    public DateTime Start { get; set; }
    [JsonProperty("end")]
    public DateTime End { get; set; }
    [JsonProperty("category")]
    public string Category { get; set; }
}
```

For others, it might be even more invasive, involving special constructors, implementing interfaces, explicit initialization, and value output code. <strong>The boilerplate code for serialization can easily become more extensive than the human-oriented content.</strong> That should raise a giant red flag in your mind!

```
public class AddVendor : ISerializable
{
    public string ClientId { get; private set; }
    public string VendorId { get; private set; }

    public AddVendor(string clientId, string vendorId)
    {
        ClientId = clientId;
        VendorId = vendorId;
    }

    public AddVendor(SerializationInfo info, StreamingContext context) 
    {
        ClientId = info.GetString(nameof(ClientId));
        PartnerId = info.GetString(nameof(PartnerId));
    }

    [SecurityPermission(SecurityAction.Demand, SerializationFormatter = true)]
    public void GetObjectData(SerializationInfo info, StreamingContext context)
    {
        info.AddValue(nameof(ClientId), ClientId);
        info.AddValue(nameof(PartnerId), PartnerId);
    }
}
```
 
For a simple immutable 2-property object, 24 lines is excessive. Also notice that for every property that is added, a developer must remember to write three new additional lines of code: one in the standard constructor, one in the serialization constructor, and one in `GetObjectData()`. This makes the change more costly than it needs to be.  

----

## Creating Transformations

----

While generally in programming, it's best to avoid using Reflection, serialization is one of the few times when using Reflection is essential. <strong>With a little bit of work, you can build simple transformation objects which plug in to your application's external messaging.</strong> The basic strategy is, use Serialization transformations for sending messages and Deserialization transformations for receiving messages. 

Here is an example transformation that enables an object to exposes its Public Properties through the ISerializable interface:

```
using System.Reflection;
using System.Runtime.Serialization;

public sealed class ReflectionSerializable : ISerializable
{
    private readonly object _obj;

    public ReflectionSerializable(object obj)
    {
        _obj = obj;
    }

    public void GetObjectData(SerializationInfo info, StreamingContext context)
    {
        foreach (var prop in _obj.GetType().GetProperties(
            BindingFlags.Instance | BindingFlags.Public))
                info.AddValue(prop.Name, prop.GetValue(_obj));
    }
}
```

With the above transformation, it would be also be trivial to serialize your objects using all lowercase property names without requiring any JsonProperty attributes. `info.AddValue(prop.Name.ToLower(), prop.GetValue(_obj));` 

Here is a similar way to skip the reflection part and plugin directly to a serialization library like JSON.Net:

```
using Newtonsoft.Json;

public sealed class NewtonsoftJsonString
{
    private readonly object _obj;

    public NewtonsoftJsonString(object obj)
    {
        _obj = obj;
    }

    public string Create()
    {
        return JsonConvert.SerializeObject(_obj);
    }
}
```

The more complicated part is Deserialization. The best way to adapt this for your application is to setup unit tests for your particular scenarios and tinker with the process until you achieve the desired results.

```
[TestMethod]
public void NewtonsoftDeserialization_ComplexValueObject_MatchesOriginal()
{
    var src = new ComplexValueObject(
        "I Am Complex", 
        new SimpleValueObject("I Am Simple", 1234));
    var json = new NewtonsoftJsonString(src).Create();
    
    var dest = new NewtonsoftDeserialized<T>(json).Create();

    Assert.AreEqual(src.Name, dest.Name);
    Assert.AreEqual(src.Inner.Name, dest.Inner.Name);
    Assert.AreEqual(src.Inner.Year, dest.Inner.Year);
}
```

Here is an example adaption that allows JSON.Net to discard the library-required cruft and return your pure objects after the Deserialization process:

```csharp
public class NewtonsoftDeserialized<T>
{
    private readonly string _json;

    public NewtonsoftDeserialized(string json)
    {
        _json = json;
    }

    public T Create()
    {
        return JsonConvert
            .DeserializeObject<NewtonsoftSerializable<T>>(_json).Create();
    }

    private class NewtonsoftSerializable<T> : ISerializable
    {
        private readonly SerializationInfo _info;

        public NewtonsoftSerializable(SerializationInfo info, 
            StreamingContext context)
        {
            _info = info;
        }

        // Must implement ISerializable in order for Newtonsoft to use
        public void GetObjectData(SerializationInfo info, 
            StreamingContext context)
        {
            throw new NotImplementedException();
        }

        public T Create()
        {
            var obj = new SerializationFactory<T>().Create();
            foreach (var entry in _info)
                if (HasProperty(obj, entry.Name))
                    WritePropertyValue(obj, entry.Name, 
                        GetValue(entry.Value, GetPropertyType(obj, entry)));
            return obj;
        }

        private bool HasProperty(T obj, string propertyName)
        {
            return obj.GetType().GetProperty(propertyName) != null;
        }

        private Type GetPropertyType(T obj, SerializationEntry entry)
        {
            return obj.GetType().GetProperty(entry.Name).PropertyType;
        }

        private object GetValue(object obj, Type toType)
        {
            if (!(obj is JToken))
                throw new InvalidOperationException(
                    $"Can only convert Newtonsoft JToken objects.");
            return ((JToken)obj).ToObject(toType);
        }

        // Reflection magic necessary for inherited public Properties. 
        private void WritePropertyValue(
            object obj, string propertyName, object value)
        {
            var currentType = obj.GetType();
            while (currentType != null)
            {
                var prop = currentType.GetProperty(propertyName, 
                    BindingFlags.Public | BindingFlags.Instance);
                if (prop != null && prop.CanWrite)
                {
                    prop.SetValue(obj, value);
                    return;
                }
                currentType = currentType.BaseType;
            }
        }
    }
}
```

----

## Plugging In The New Aspect

----

Now, with the new transformation, plug them in at the edges of your application, when sending and receiving messages.

Client gateway example:
```
private async Task<T> GetAsync<T>(string uri)
{
    var content = await GetStringContentAsync(uri);
    return new NewtonsoftDeserialized<T>(content).Create();
}

private async Task<string> GetStringContentAsync(string uri)
{
    using (var response = await _httpClient.GetAsync(uri))
    {
        EnsureSuccessfulResponse(response);
        return await response.Content.ReadAsStringAsync();
    }
}
```

Server example:
```
[HttpGet]
public string Get(int id)
{
    return new NewtonsoftJsonString(_productRepository.Get(id)).Create();
}
```

----

When I started this post, I wanted to say that implementing Serialization using AOP is simple and easy. The truth is, it's not easy. It takes some work. There isn't a simple general solution that solves all of the details. <strong>The more complex your messaging objects are, the tougher it is to wire in a Serialization Aspect.</strong> Simpler objects make it much easier. 

However, if you have more than a few message objects in your application, <strong>using AOP instead of designing every object with additional concerns pays off dividends.</strong> When you keep your objects simpler and confine each one to it's own subdomain, your code is easier to read, easier to understand, easier to test, and easier to reason about. This gives major benefits when you add a new feature to your application or add an existing one. You won't have to ask yourself if there is some aspect you forgot to include in your simple message objects, or if you missed a critical test case. This ease of mind is well worth a couple of days trial-and-error to extract the messaging responsibilities from your domain.

The best argument that I can make for implementation Serialization using AOP is the practical one. The second best argument is just to show you the difference. 

### Which code would you be happier to see in your application?

```
public class AddVendor : ISerializable
{
    public string ClientId { get; private set; }
    public string VendorId { get; private set; }

    public AddVendor(string clientId, string vendorId)
    {
        ClientId = clientId;
        VendorId = vendorId;
    }

    public AddVendor(SerializationInfo info, StreamingContext context) 
    {
        ClientId = info.GetString(nameof(ClientId));
        PartnerId = info.GetString(nameof(PartnerId));
    }

    [SecurityPermission(SecurityAction.Demand, SerializationFormatter = true)]
    public void GetObjectData(SerializationInfo info, StreamingContext context)
    {
        info.AddValue(nameof(ClientId), ClientId);
        info.AddValue(nameof(PartnerId), PartnerId);
    }
}
```

### OR

```

public class AddVendor
{
    public string ClientId { get; private set; }
    public string VendorId { get; private set; }

    public AddVendor(string clientId, string vendorId)
    {
        ClientId = clientId;
        VendorId = vendorId;
    }
}
```

<strong>The answer is self-evident.</strong>