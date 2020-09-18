# Optimization Technique - DNS Pre-Fetch

Most web pages use some resources that aren't co-located.

Perhaps your site uses Google Font, embeds a YouTube video, uses a hosted CSS framework, or any other deferred external resource.

## How do I do this?

In the `<head>` of your website, include a DNS prefetch link to any external domain that will later need to access.

```
<!-- Google Fonts -->
<link rel="dns-prefetch" href="//fonts.googleapis.com">
<link rel="dns-prefetch" href="//fonts.gstatic.com">
```

If you have synchronous resource loads, or deferred content, having the prefetch will speed up the browsers access to the prefetched resources.

## How does it work?

Every website name resolves to a specific host.

A DNS Lookup involves taking a canonical name, such as `www.google.com` and translating it to a physical computer IP Address such as `172.217.14.110`.

Using the DNS Pre-Fetch optimizes future browser requests to all resources at that domain by eliminating the need to perform the DNS lookup at the time of the resource request.

## Expected Performance Gains

10-300ms speed improvement, varying based on how many domains, and how well their DNS records are configured.
