---
layout: post
title: Cut Out The Middleman
date: 2017-06-27 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/moneymakers.jpg
---

Too much decoupling in software development is arguably worse than too little. Excessive decoupling leads to software that is more complex, more verbose, harder to understand and much less maintainable. Don't let your critical use cases get split up into little tiny bits and strewn about your application!

There are several causes of excessive decoupling. The one I want to address in this post is the dysfunctional approach to getting everything through an intermediary. Why does everything need to be acquired through a Repository, a Supplier, a Provider, a Service, a Lookup, a Builder and so forth? **Do we need so much separation?**

<img src="/images/moneymakers.jpg" alt="Business People With Money, Laughing" width="700" height="411" />

How often have you seen some code that looks like this?

```
public class InvoiceBuilder : IInvoiceBuilder
{
    public IDocument BuildMyInvoice(Customer customer, 
        List<Product> products, decimal orderTotal)
    {
        var pdf = new PdfDocument();
        AddCustomerToDoc(pdf, customer);
        AddProductsToDoc(pdf, products);
        AddTotalToDoc(pdf, orderTotal);
        return pdf;
    }
	
    ... private section building methods ...
}
```

A solution like this expects to be used in a very particular way. It's a very particular solution. The calling code might look like this:

```
public class InvoiceService : IInvoiceService
{
    private readonly IInvoiceBuilder _invoiceBuilder;
    private readonly ICustomerRepository _customerRepository;
    private readonly IOrderRepository _orderRepository;

    public InvoiceService(IInvoiceBuilder invoiceBuilder,
        ICustomerRepository customerRepository,
        IOrderRepository orderRepository) { ... }
	
    public IDocument GetInvoice(int orderId)
    {
        var order = _orderRepository.Get(orderId);
        var customer = _customerRepository.Get(order.CustomerId);
        var invoice = _invoiceBuilder.BuildMyInvoice(customer, 
            order.Products, order.Total);
        return invoice;
    }
} 
```

Now we have a bunch of different objects strewn about the system. **In order to track down an Invoice problem, developers have to trudge through several areas of the system.** Is the right data in the database? Is the InvoiceBuilder correctly assembling the various segments of the Pdf? Is InvoiceService getting the right things from the Repositories? Are the repositories getting the right things out of the database? 

Furthermore, any changes to the structure of the invoice are going to require changes to a large number of classes. To add a new segment to the Invoice, you've got to change your database tables, update your repositories, update your data transfer objects, update your InvoiceService and update your InvoiceBuilder. That sounds like a lot of work. That's because it IS a lot of work.

How much value are we getting by organizing the application functionality this way? **Is there a better way to arrange this code?**

Yes! **Cut out the middlemen!** Code is poorly arranged if you need to change several source code files at the same level of abstraction to implement a new business use case. It's far better to have a larger object that is cohesive than smaller objects that hide and disconnect critical pieces of functionality. 

----

### Evolving the Code

----

Let's evolve the code example above into something simpler and more direct. **First, we must step back and consider WHAT we want done.** This means throwing away all preconceptions about HOW it will get done. 

What we want is an Invoice, presented as a PDF. The invoice consists of some information about the Customer, and some information about the Order. 

Let's model that in the code:

```
public class Invoice
{
    private Order _order;
    private Customer _customer;
	
    public Customer Customer => _customer;
    public List<Product> Items => _order.Products;
    public decimal Total => _order.Total;
	
    public Invoice(Customer customer, Order order) { ... }
	
    public static Invoice ForOrder(int orderId)
    {
        var order = new SqlOrder(orderId);
        var customer = new SqlCustomer(order.CustomerId);
        return new Invoice(customer, order);
    }
}

public class InvoicePdf : IDocument
{
    private Invoice _invoice;
	
    public InvoicePdf(Invoice invoice) { ... }
	
    public byte[] GetContent()
    {
        var pdf = new PdfDocument();
        AddCustomerToDoc(pdf, invoice.Customer);
        AddProductsToDoc(pdf, invoice.Items);
        AddTotalToDoc(pdf, invoice.Total);
        return pdf.GetContent();
    }
	
    ... private section building methods ...
}
```

This is far better than the earlier code with all the Repositories, Builders, and Services. It is more expressive, more cohesive, and has a simpler API. Let me point out a few specific benefits:

### 1. Clear Business Concepts
In the original code, there was no object modelling an Invoice. Now, we have an Object that represents a business thing and consists of precise information: a Customer, Items and a Total. Those are business terms, not computer-science language. 

----

### 2. Less Data Trucking
Our PDF is easier to create. Previously we had to independently find and pass in very particular data arguments in order to build the Invoice Pdf. Now we simply create an InvoicePdf using an Invoice. If tomorrow your project owner decides that the Invoice needs four new pieces of information, no public methods or constructors for the InvoicePdf will change. 

----

### 3. No DI Container Needed
With objects composed in this manner, you don't need a DI Container to inject all the right pieces of functionality into your application. There are fewer moving parts in the system, and each of the parts is simpler. 

----

### 4. True Dependency Inversion
Previously the InvoiceService depended on the InvoiceBuilder. The service was coupled to the presentation mechanism. Now, InvoicePdf depends on Invoice, but Invoice knows nothing about presentation concerns. 

----

Those are just a few concrete benefits that we gain from cutting out the middleman and focusing on the actual business functionality of the software.

Our recent solution is good. **We can make things just a little better by moving away from the database-oriented models and raising the abstraction level one more time.** Let's make Order responsible for his Customer, rather than requiring all calling code to assemble disparate pieces of information.

```
public class Invoice
{
    private Order _order;
	
    public Customer Customer => _order.Customer;
    public List<Product> Items => _order.Products;
    public decimal Total => _order.Total;
	
    public Invoice(int orderId)
        : this (new SqlOrder(orderId)) { }
	
    public Invoice(Order order) { ... }
}
```

**Now this code looks elegant and simple to use!** The secondary constructor makes the API convenient for callers, without compromising the ability to implement Order without using SQL.  

Watch how the usage evolved with each change:

Original Program
```
var service = new InvoiceService(
                new InvoiceBuilder(), 
                new OrderRepository(), 
                new CustomerRepository());
var doc = service.GetInvoice(orderId);
```

Second Program
```
var invoice = Invoice.ForOrder(orderId);
var doc = new InvoicePdf(invoice);
```

Final Program
```
var invoice = new Invoice(orderId);
var doc = new InvoicePdf(invoice);
```

----

### Summary

----

Sometimes when you're in a codebase that has a lot of needless indirection, it becomes easy to think that the indirection is necessary or even a "best practice". It's time to take a step back. Do I actually want a CustomerBuilder, or do I want a Customer? Do I want a ProductsLookupService or do I want a ProductList? Do I want a CarProvider, or could I simply use a Car?

**Move towards concepts and language that express the problem itself.** Try to minimize the number of different classes, functions and objects that data passes through. Always go directly to the source instead of through a middleman. Avoid unnecessary indirection. 

As you work towards eliminating the indirections, your code will become simple, concise, and easy to use. 
