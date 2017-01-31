---
layout: post
title: Collaborate With Your Computer
date: 2016-10-04 09:00
author: silas.reinagel@gmail.com
comments: true
categories: [Object Thinking, Software Engineering]
---
One of the core concepts in Object Thinking or Extreme Programming is the importance of metaphors. Metaphors are the way you conceptualize a given problem in your mind. The metaphors you use will profoundly influence your designs.

Since programming is about the problem of using computers to accomplish a variety of arbitrary tasks, the ability of a programmer to effectively do this is heavily predicated on their metaphor for what a computer is and how it behaves.

Your metaphor defines the way you relate to the computer. There are an infinite number of possible metaphors. In this article, I would like to take a brief look at two paradigms. One of them is very popular, and the other is less popular.

<hr />

<h3>Inanimate Tool</h3>

<hr />

If you perceive the computer as an inanimate tool, a stupid object who deals only in ones and zeroes, then your designs will reflect that. You will be a craftsman who must know how and how not to use your tool. You will be a micromanager who tells the computer precisely what to do, how to do it, and when to do it. You will micromanage the computer, watch its internal state and outputs closely, and debug problems when it doesn't do things quite right. The entire responsibility for making the computer accomplish tasks rests upon the programmers who write the task instructions. You need to be rather clever and know various tricks and techniques, since the computer doesn't help you with anything. This will result in programmers writing code like this:

{% highlight java lineanchors %}
public void writeToFile(String filePath, String[] lines) throws IOException 
{
    File file = new File(filePath);
    FileOutputStream outStream = new FileOutputStream(file); 
    BufferedWriter writer = new BufferedWriter(
        new OutputStreamWriter(outStream));

    for (int i = 0; i < lines.length; i++) 
    {
        writer.write(lines[i]);
        writer.newLine();
    }

    writer.close();
}
{% endhighlight %}

In the above example, the programmer is telling the computer what to do when someone tells it to write lines to a file. The code is not bad, but it is certainly very detail oriented. This procedure knows about many kinds of classes, it knows about IOExceptions, it knows about iterating through arrays, it knows about needed to close a writer after writing some lines. Furthermore, this solution is very specific. If another programmer needs to write something else to a file (bytes, images...etc.) then he will have to create a new procedure, since BufferedWriter only works with characters and strings.

<hr />

<h3>Living Person</h3>

<hr />

A much better metaphor for computers is a person. He is a person who enjoys collaborating with other people to solve problems and accomplish tasks. His thinking is very literal. He doesn't know very much about the things that you know about. However, he is open to instruction and is always excited to learn new skills and ideas. He is always willing to learn new words and concepts, as long as they are clearly explained to him. When you perceive the computer as a person, he becomes an active collaborator in accomplishing tasks. The computer will do what he can to make it easy for you to make web requests, update database entries, discover great sales, read files, send messages to your friends, discover mistakes in your code, and virtually anything else.

This metaphor can extend further. As developers, we can collaborate with our Operating Systems, collaborate with our IDEs, collaborate with our Programs, collaborate with our Frameworks, collaborate with our Modules, collaborate with our Classes, and so on. The Java Virtual machine wants to work with you to accomplish exciting things. Your program wants to learn how to effectively do his job, while giving your users a pleasurable experience. Your TextFileInvoice class wants to work with you to store important information for your business into portable, simple files. This results in code that looks more like this:

<pre><code>new TextFile(filePath, lines).save();
</code></pre>

After looking at the above example, some of you will be thinking "Where is the code? Doesn't this just mean you have to write the real code somewhere else?". That's the wrong question to ask. The natural inclination of a programmer is to think about how the computer will accomplish a task. This is the wrong paradigm. The above code is very collaborative because it means that the programmer will be working with the TextFile class to save text files. The programmer doesn't need to know how TextFile saves files, where he puts them, how he encodes them, or any other detail. The programmer should trust TextFile to do his job. The programmer and the TextFile object collaborate to accomplish the task that the client has requested. The program gets smarter over time as he learns more things. This makes life much simpler for programmers. A programmer doesn't need to know as many things. A programmer doesn't need to store as much complexity in his mind.

<hr />

<h3>Code Examples</h3>

<hr />

Of these two paradigms, the living person metaphor will result in programs that are more intelligent and easy to use. The inanimate tool metaphor will result in programs that must be carefully and correctly used by human actors. Using the person metaphors, programmers teach their computers how to accomplish various tasks. Using the inanimate tool metaphor, programmers create a toolbox of functionality that they can later use in order to use the computer to accomplish those tasks.

Sometimes, for simple cases, the code might end up looking similar, but the mentality ends up being extremely different.

<strong>Tool Thinking:</strong>

<pre><code>Rectangle rect = new Rectangle();
rect.Color = "Red";
</code></pre>

<strong>Person Thinking:</strong>

<pre><code>Rectangle rect = new Rectangle();
rect.colorYourself("Red");
</code></pre>

It is much more collaborative to ask an object to do something, than to change values of an inanimate thing.

Sometimes, for more complex cases, this changes the way you design methods completely.

<strong>Tool Thinking:</strong>

<pre><code>public void run()
{
    print("Sending out weekly email reports beginning at " + nextSendDate);
    while(true)
    {
        if(LocalDateTime.now().isAfter(nextSendDate))
        {
            emailReport();
            nextSendDate = DateTime.getStartOfWeek(LocalDateTime.now())
                .plus(Duration.ofDays(7));
        }

        ThreadUtils.sleep(60 * 1000);
    }
}
</code></pre>

<strong>Person Thinking:</strong>

<pre><code>public void run()
{
    print("Sending out weekly email reports.");
    new RecurringTask(new StartOfNextWeek(), 
        new WeekDuration(), () -&gt; emailReport()).run();
}
</code></pre>

In the tool thinking example, the programmer is deciding precisely how to recur a given task, what formulas to use to compute certain dates, how long to sleep between checking conditions, and so forth. When another similar feature is requested by the clients, the programmer will have to write a similar method.

In the person thinking example, the programmer simply declares what he would like done, and the program decides how to intelligently perform the task. The method is much shorter, simpler, and high-level. The computer knows about the details and takes care of all of them so that the programmer doesn't need to. The program is more intelligent, capable, and easy to work with, because he has been taught how to solve problems such as figuring out the start of the next week, figuring out how to perform tasks on a regular schedule, and so forth. When another similar feature is requested by the clients (perhaps a weekly advertising email), it will be extremely easy for the programmer to implement. The computer already knows how to do these sorts of tasks. In fact, using person thinking, it would be trivial to teach the computer about weekly recurring tasks, like this:

<pre><code>public void run()
{
    print("Sending out weekly email reports.");
    new WeeklyTask(() -&gt; emailReport()).run();
}
</code></pre>

<hr />

<h3>Vocabulary</h3>

<hr />

As your thinking shifts, so too will your vocabulary.

<ul>
<li>You are not using your computer, you are working with your computer</li>
<li>You are not creating a spreadsheet using Microsoft Excel, you are creating a spreadsheet with Microsoft Excel</li>
<li>You are not instantiating a class, you are inviting an object into a world</li>
<li>You are not replacing your RAM, you are giving your computer a RAM transplant</li>
<li>You are not playing a game on your PS4, you are playing a game with your PS4</li>
<li>You are not setting the color of a button, you are asking the button to change his color</li>
<li>You are not creating a method on a class, you are teaching an object how to do something new</li>
</ul>

Don't use your computer. Collaborate with him.
