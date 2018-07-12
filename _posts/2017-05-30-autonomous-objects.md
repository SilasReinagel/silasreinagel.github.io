---
layout: post
title: Autonomous Objects
date: 2017-05-30 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/AutonomousRobots.jpg
---

A CPU is a linear instruction processor. Humans behave autonomously, using pattern recognition to dynamically respond to stimuli. The natural tendency is for programmers to shape their minds according to the CPU's implementation. The software craftsman must know how to write software on both sides of the spectrum: linear procedures and autonomous objects. 

----

### Linear / Procedural 
On the procedural side of the spectrum, programmers instruct the computer precisely how to operate, what to do when. At a low-level, this consist of moving bytes around in memory and performing byte-level manipulations. At a high-level this consists of invoking methods on various higher-level classes and data structures.

----

### Autonomous
On the autonomous side of the spectrum, programmers simply bring objects to life inside of a program and the objects act as they wish. The objects may use whatever computer resources they need, but they are the ones who decide what happens, and when. Autonomous objects do not like to be told how to do their jobs. They do not like to be asked to provide data. Autonomous objects communicate using messages.

----

### Dependent 
There is a broad area of space between the two poles. In this space there are decomposed procedures, dependent objects, dependency injection, and complex code graphs. 

----

A system built around the procedural style is a Command and Control system. A system with specific class dependencies and inverted dependencies is a Trust and Delegate system. **A system built around the autonomous objects is an Orchestrated system.**

<img src="/images/AutonomousRobots.jpg" alt="" width="700" height="400" class="aligncenter size-full" />

----

### Autonomous Objects In Practice

----

**A purely autonomous object has no public members.** You cannot ask him for anything, you cannot tell him what to do, and you cannot depend on him (that would constrain his freedom). In practice, our present programming languages do not fully support this concept. The closest we can get in most languages is to expose a single method that sets him in motion. 

Recently, I refactored a Java Hangman game according to this concept. Here is the [original procedural code](https://github.com/yegor256/hangman/blob/master/src/main/java/hangman/Main.java).  Here is the new `Game` class:

```
public final class Game implements Runnable
{
    private final List<Runnable> _objects;
    private final WordList _words;
    private final Messages _messages;

    public Game(Messages messages, WordList words, Media media, 
        Scanner in, MistakeMax max)
    {
        this(messages, words, 
            new UserInterface(messages, media, in), 
            new Secret(messages), 
            new Gallows(messages, max));
    }

    private Game(Messages messages, WordList words, Runnable... objects)
    {
        _objects = Arrays.asList(objects);
        _messages = messages;
        _words = words;
    }

    @Override
    public void run()
    {
        _objects.forEach(x -> x.run());
        _messages.send("GameStarted", _words.random());
    }
}
```

As you can see, this is a very different program than a procedural program with specific instructions to be executed in order. This is also very different than a trust-and-delegate program which invokes methods on various objects (who, in turn, invoke methods on other objects). The only method `Game` exposes is `void run()`. He is a miniature program. Once he has been birthed by using a constructor (constructors are not part of the object), he accepts no direct inputs and provides no direct outputs. 

Furthermore, the other objects in this system (except for `Messages` and the `WordList`) are also fully autonomous. None of the three gameplay objects `UserInterface`, `Secret`, and `Gallows` know about each other or about `Game`. **Once set in motion, they will all act independently, communicating entirely using simple messages.**

In this system, `Messages` allows simple strings to be passed by subject name. In a bigger system, these messages might consist of Json, Xml, or Html content, and the subject could be Urls or endpoint names. In other systems, these messages could be used to pass [strongly-typed data structures](https://github.com/EnigmaDragons/MonoDragons.Core/blob/master/MonoDragons.Core/EventSystem/Events.cs). Regardless of what form these messages take, using decoupled messaging allows for a completely autonomous emergent system.

```
public final class Gallows implements Runnable
{
    private final Messages _messages;

    private AtomicInteger _mistakes;
    private MistakeMax _max;

    public Gallows(Messages messages, MistakeMax max)
    {
        _messages = messages;
        _mistakes = new AtomicInteger();
        _max = max;
    }

    @Override
    public void run()
    {
        _messages.subcribeTo("GuessedCorrectly", x -> guessed(x));
    }

    private void guessed(String correctly)
    {
        if(!correctly.equals("true"))
            _messages.send("GallowsUpdated", 
                String.format("Mistakes: #%d out of %d",
                _mistakes.incrementAndGet(), _max.intValue()));
        checkForGameEnd();
    }

    private void checkForGameEnd()
    {
        if (_mistakes.get() == _max.intValue())
            _messages.send("GameEnded", "lost");
    }
}
```

The `Gallows` object is autonomous. You can't ask him whether the game is over. You can't tell him to draw one more segment of the hanging man. He will take care of all of that. **He chooses exactly which messages he cares about, and he updates his internal state based on the contents of those messages.** Since he is a backend game rule component, he does not interact with the User Interface. He does not even know if anyone is presenting information to the User. That's not his job. 

In a simple game like Hangman, there is a simple win-lose condition. **However, in systems with more complex rules, the ability to independently track and evaluate state changes is incredibly valuable.** New rules can be plugged in without changing existing code. This style of infrastructure affords great flexibility. 

There is another incredible value in using autonomous objects. It protects us from inferior implementations:

```
public final class Secret implements Runnable
{
    private final Messages _messages;

    private String _word;
    private List<Boolean> _discovered;

    public Secret(Messages messages)
    {
        _messages = messages;
    }

    @Override
    public void run()
    {
        _messages.subcribeTo("GameStarted", x -> startGame(x));
        _messages.subcribeTo("Guessed", x -> guess(x));
    }

    private void startGame(String word)
    {
        _word = word;
        _discovered = _word.chars()
            .mapToObj(x -> false).collect(Collectors.toList());
        _messages.send("WordUpdated", publicWord());
        _messages.send("GameSetup", "true");
    }

    private void guess(String guess)
    {
        String result = guessedCorrectly(guess);
        _messages.send("WordUpdated", publicWord());
        _messages.send("GuessedCorrectly", result);
        checkForGameEnd();
    }

    private void checkForGameEnd()
    {
        if (_discovered.stream().allMatch(x -> x))
            _messages.send("GameEnded", "won");
    }

    private String publicWord()
    {
        return String.join("", IntStream.range(0, _word.length())
            .mapToObj(i -> _discovered.get(i) ? _word.substring(i, i + 1) : "?")
            .collect(Collectors.toList()));
    }

    private String guessedCorrectly(String guess)
    {
        String result = "false";
        for (int i = 0; i < _word.length(); ++i) {
            if (_word.charAt(i) == guess.charAt(0) && !_discovered.get(i)) {
                _discovered.set(i, true);
                result = "true";
            }
        }
        return result;
    }
}
```

There is some genuinely ugly code in this class. There is a command-query violation hiding in `guessedCorrectly()`. There is some insidious temporal coupling in `guess`. There are definitely better ways to represent a hidden word than using a `String` and a `List<Boolean>`. The `publicWord()` method is not very intuitive. There are a ton of ways this object could be better implemented -- but, that doesn't matter.

**When a system is composed of decoupled autonomous objects, the internal quality of any of those objects is contained.** It's ugliness and imperfection do not leak into the surrounding system. As long as the messages sent by object are clean and easy to consume, the system is healthy. Nothing in the system is coupled to the implementation of an autonomous object. Therefore, you can cleanup or replace a nasty object without a functional impact to the system. 

This is a benefit that is not afforded by a system with dependent objects and data flows. 

----

### Go Experiment With Autonomous Objects!

----

If you haven't explored the space of Autonomous Objects, it is a very eye-opening journey. Not every programming problem is best solved with Autonomous Objects, but a software craftsman must know what this side of the spectrum is like. You must know what benefits are afforded by orchestrations, and what limitations this approach possesses. 

**Personally, I have found that autonomous objects are an effective way to model a number of different problem domains.** Some elements of the autonomy and messaging style allow for much easier frontend-backend parallel development. This is especially valuable in time-constrained team projects. It also produces simple designs than most of the three-layer presentation patterns: MVC, MVVM, and MVP. With messaging, you can often implement the same functionality without the intermediary layer. You also end up with simpler data flows, since there is no need to aggregate information in order to present it. 

I challenge you to build one or two small programs consisting primarily of objects with no public methods, except for `void run()`. 
