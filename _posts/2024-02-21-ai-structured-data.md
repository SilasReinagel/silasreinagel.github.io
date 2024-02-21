---
layout: post
title: AI - Prompting for Structured Data
date: 2024-02-14 13:09
author: silas.reinagel@gmail.com
comments: true
categories: [blog, ai, structured-data, prompt-engineering]
featured-img: /images/ai-llm-chaos-to-structured-data.jpg
---

AI LLMs are very powerful. They can be used to generate text, code, and even structured data. In this post, I'll show you how I use LLMs and prompt engineering techniques to generate structured data for powering applications to deliver a consistent experience. 

---


<img src="/images/ai-llm-chaos-to-structured-data.jpg" alt="AI LLM - Prompting for Structured Data"/>

Most people who have interacted with LLMs are used to using a chat-style interface. You provide a human-language prompt and the model generates a human-language response. This is a very powerful and flexible way to use LLMs, but it's not the only way.

For engineering purposes, sometimes it's important to have a structured data output. This is especially true when you want to use the output to power an application. 

## Example: Sample Data Generator

Suppose we're working on a sample data generator. We want to generate some sample customer data to visualize how our application will look with real data. We want to generate a list of customers with their names, email addresses, and phone numbers.

Naive Prompt:
```
Generate 10 sample customers with their names, email addresses, and phone numbers.
```

Naive Prompt Output (Result 1 - ChatGPT 4) - *Truncated*:
```
Here are 10 sample customers with their names, email addresses, and phone numbers:

1.  Name: Melinda Zimmerman
    Email: thompsonrobert@gmail.com
    Phone: 613-115-3387
...
```

Naive Prompt Output (Result 2 - ChatGPT 4) - *Truncated*:
```
Here are 10 sample customers with their names, email addresses, and phone numbers:

1. Name: Ms. Katherine Morris
    - Email: mark85@hotmail.com
    - Phone Number: 2966924154
...
```

This is a very simple example, but it illustrates the point. The LLM gave us good data, but we cannot easily use this in our application for several reasons. The data is hard to parse, the results will be inconsistent (for the same input you won't get the same format of output), and the individual data values are inconsistent.

---

## Prompt for Structured Data

To get structured data, we need to prompt the LLM in a way that it understands that we want structured data. We need to provide a prompt that tells the LLM to generate structured data, and gives it the data formats and schema we need. Let's get it to output a JSON object.

Structured Prompt:
```
Generate 10 sample customers with their names, email addresses, and phone numbers. 

Only return JSON, no commentary. See the following sample output. 

- Phone numbers should be in the format 1-613-115-3387. 
- Names should only be first and last name, exclude all titles, middle names, suffixes, and honorifics.

---

{
  "customers": [
    {
      "name": "Melinda Zimmerman",
      "email": "melinda@zimmerman.com"
      "phone": "1-613-115-3387"
    },
    ...
  ]
}
```

Structure Data Output (Result 1 - ChatGPT 4) - *Truncated*:
```
{
  "customers": [
    {
      "name": "Miguel Anderson",
      "email": "lisaterry@gmail.com",
      "phone": "1-961-336-5894"
    },
    {
      "name": "Karen Mack",
      "email": "jonathanmclaughlin@nelson.com",
      "phone": "1-789-192-2789"
    },
  ]
}
```

Output (Result 2 - ChatGPT 4) - *Truncated*:
```
{
  "customers": [
    {
      "name": "Ryan Lamb",
      "email": "david83@hotmail.com",
      "phone": "1-613-378-8378"
    },
    {
      "name": "Antonio Gonzalez",
      "email": "gordonshane@hotmail.com",
      "phone": "1-613-934-1513"
    },
  ]
};
```

This is a much better result. The data is structured, consistent, and easy to parse. We can use this data directly in our application. For safety, we can validate the data with a JSON parser + schema validator to ensure that the data is in the format we expect.

This type of approach can work with virtually any format of structured data. You can use it to generate SQL, CSV, XML, or any other structured data format.

Happy AI Prompting!
