---
layout: post
title: Reactive Game State in Unity
date: 2020-07-21 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/reactive-state-in-unity-graph.jpg
---

Performance is key in game development. Your players want silky smooth 60+ frames per second. One of the common performance expenses is using the Update loop to check data values for changes. I will show you how to setup a simple Reactive Game State system.

<img src="/images/reactive-state-in-unity-graph.jpg" alt="Reactive State in Unity Graph, with many data sources converging into one point." />

First I will show you a common anti-pattern that is seen often in Unity projects.

Then, I will walk you through a scalable and elegant solution.

----

## Anti-Pattern To Avoid - Data Query In Update Loop

This is a common example of code seen in many Unity games. The UI or something about the game state is checked in the Update loop to ensure that it's always up to date with the latest information.

Since the game state doesn't change every frame, an implementation like this needlessly wastes cycle time by running on every single Update tick. It can potentially be even more expensive, since changing a UI value may result in a Canvas re-render, which is even more costly than the Update code execution cost.

```
public sealed class ScorePresenterUpdateLoop : MonoBehaviour
{
    [SerializeField] private Text scoreLabel;
    [SerializeField] private CurrentGameState gameState;

    void Update() => scoreLabel.text = $"Score: {gameState.Current.Score}";
}
```

----

## Solution - Reactive Game State

How do we solve this? The key goal is we only want to change the UI values, or run any game-tracking logic (inventory change, quest status change, level up, etc.), when the game state has changed.

There are three key pieces to the solution:
1. Setup mediator for Reactive Message Publishing
2. Setup the ScriptableObject for publishing a message on state changes
3. Use a reactive script for responding to changes

Complete Project Example can be found here: https://github.com/EnigmaDragons/UnityReactiveGameStateExample

----

### Step 1: Setup mediator for Reactive Message Publishing

In the past, I have written about the advantages of using [messaging solutions](/blog/2019/02/04/messaging-conceptual-fundamentals/). If you want a refresher on that, definitely read that post.

For our purposes here, you can simply import this file into your Unity Project: [Message.cs](https://github.com/EnigmaDragons/UnityReactiveGameStateExample/tree/master/src/ReactiveGameStateExample/Assets/Scripts/Messaging/Message.cs)

The key methods here are:
```
public static void Publish(object payload) ...
public static void Subscribe<T>(Action<T> onEvent, object owner) ...
public static void Unsubscribe(object owner) ...
```

Why not simply use C# Event Delegates? For a very simple project, that works well. You certainly can do that route.

For more complex projects, it's useful to have a one-stop shop where you can add reactive hooks, logging, debug tooling, and other utilities that will globally apply to all messages. Additionally, in the implementation provided here, the message queue ensures that each state change is fully processed before any other changes are made, which is useful if you have cascading state changes.

----

### Step 2: Setup the ScriptableObject to publish state change messages

The second key ingredient is to ensure that all state changes are centralized to one place, so that no changes occur without triggering the appropriate messages.

In this case, we have three pieces.

There is the data structure that represents the current state of the game:

```
[Serializable]
public sealed class GameState
{
    public int Score;
}
```

This is a serializable data structure, so that it plays nicely with Unity and natively shows up in the Unity Editor. Unity Serialization works with fields, since they are more efficient than Properties, and so we use fields for everything.

If you have a Save/Load system, this is the data structure that you persist and read.

*Note: In a real game, you may store a lot of data in this structure. Here's a much more complex example we used in a [recent game](https://github.com/EnigmaDragons/TheInterview/blob/master/src/TheInterview/Assets/Scripts/State/GameState.cs)*.

Secondly, we need a single scriptable object to provide Editor-friendly binding and access to our encapsulated Game State:

*Note: We use ScriptableObject instead of a C# singleton since it helps us to track and manage our dependencies better, as well as provided a native way to view the data in the Editor. You can use a C# singleton instead if you like, and it will accomplish the same fundamental use case.*

```
[CreateAssetMenu(menuName = "OnlyOnce/CurrentGameState")]
public sealed class CurrentGameState : ScriptableObject
{
    [SerializeField] private GameState state = new GameState();

    public void Init() => Init(new GameState());
    public void Init(GameState intial) => state = inital;

    public void AddScore(int amount) => UpdateState(g => g.Score += amount);

    public void UpdateState(Action<GameState> apply)
    {
        UpdateState(_ =>
        {
            apply(state);
            return state;
        });
    }

    public void UpdateState(Func<GameState, GameState> apply)
    {
        state = apply(state);
        Message.Publish(new GameStateChanged(state));
    }
}
```
`CurrentGameState` is a container for encapsulating access to the current GameState. When starting a game, or loading a game, you initialize him.

The key component of this is the `UpdateState` methods, which should be the only way anywhere in the game that the GameState is modified. Whenever one of these methods is called, the GameState is updated, and a change message is published.

Lastly, we need the message data structure to communicate state changes:

```
public sealed class GameStateChanged
{
    public GameState State { get; }

    public GameStateChanged(GameState s) => State = s;
}
```

### Step 3: Reactive Script To Respond To Changes

This is final piece of the puzzle. We need to have scripts that naturally manange their subscriptions based on their Unity attached Object lifecycles, so that it handles create/enable/disable/destroy hooks.

For that, I use a single abstract base class that extends MonoBehavior.

```
public abstract class OnMessage<T> : MonoBehaviour
{
    private void OnEnable() => Message.Subscribe<T>(Execute, this);
    private void OnDisable() => Message.Unsubscribe(this);

    protected abstract void Execute(T msg);
}
```

That's the final piece we need. Now we have all three pieces:

1. A Messaging Mediator
2. Encapsulated Game State that publishes Change Messages
3. A Script to Automatically Receive Changes

Once the three elements are in place, now you can evolve GameState and seamlessly bind to any number of Game Objects who cares about those state changes without using the Update Loop.

----

### Using The Reactive Game State

Now, we have a brand new script that receives state changes reactively, and does not use the Update Loop.

```
public sealed class ScorePresenterReactive : OnMessage<GameStateChanged>
{
    [SerializeField] private Text scoreLabel;

    protected override void Execute(GameStateChanged msg)
        => scoreLabel.text = $"Score: {msg.State.Score}";
}
```

This script will always receive a `GameStateChanged` message any time the GameState has been modified. This means that whenever the game state isn't changing, this code isn't in the execution pathway. This always prevents countless UI re-renders, which are one of the performance pitfalls in Unity.

Here is another example from a recent game, where we reward the player with Credits and XP upon completing an objective. This is a purely game logic processing operation that doesn't directly change the UI (although you would rightly presume that other reactive triggers handle showing the player his Credit and XP gains).

```
public class ObjectiveRewardHandler : OnMessage<ObjectiveSucceeded>
{
    [SerializeField] private CurrentAppState app;

    protected override void Execute(ObjectiveSucceeded msg)
    {
        app.UpdateState(a =>
        {
            a.Creds += msg.Objective.RewardCredsAmount;
            a.CurrentLevelXp += msg.Objective.RewardXpAmount;
        });
    }
}
```

Another key advantage of using Reactive Game State is that you don't have to know in advance what all the impacts of something happening will be. Since scripts aren't directly coupled, you can later decide that you want to play a sound effects when you lose health without being coupled to the visuals or other pieces of logic.

This is invaluable when you are working with a team, and you want to avoid code merge conflicts that happen due to working in the same areas of the code. Since effects are decoupled from the causes, collisions are very rare.

Once you move to using reactive game state, you will discover many other architectural benefits.

----

## Summary

This is a general solution for reactively managing and communicating Game State changes using Unity-friendly patterns. By moving to Reactive state updates, you will significantly increase the performance of your non-physics game code, and provide easy ways to respond to changes without ending up with spaghetti code.

Move your state query code out of the Update Loop and bind to it reactively by:
1. Setting up a mediator for Reactive Message Publishing
2. Setting up a ScriptableObject for publishing a message on state changes
3. Using a reactive script for responding to changes

Do you have other state management patterns that you find generally useful in Unity Projects?

**Share your thoughts and techniques in the comment below.**
