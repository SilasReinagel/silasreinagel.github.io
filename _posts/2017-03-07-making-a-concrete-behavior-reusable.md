---
layout: post
title: Making a Concrete Behavior Reusable
date: 2017-03-07 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/standardized-puzzle-pieces.jpg
---

Solving a software engineering problem once in your application is good. Taking a solution and making it reusable inside your application is even better. Recently, I had fun writing a simple scene transition, and then making it reusable. Join me in watching it evolve.

<img src="/images/standardized-puzzle-pieces.jpg" alt="" width="700" height="400" class="aligncenter size-full" />

----

<strong>Problem:</strong> Take a game scene, and begin the scene by fading in from black.

<strong>Patterns Demonstrated:</strong> Decorator Pattern, Abstract Factory Pattern

Our scene interface is:

```
public interface IScene
{
    void Init();
    void Update(TimeSpan delta);
    void Draw();
}
```

Let's add the fade-in transition to a simple scene, like this one:

```
public sealed class LogoScene : IScene
{
    public void Init()
    {
        Input.On(Control.Start, () => Navigation.NavigateToScene("MainMenu"));
    }

    public void Update(TimeSpan delta)
    {
    }

    public void Draw()
    {
        UI.DrawBackgroundColor(Color.Black);
        UI.DrawCentered("Images/Logo/evilcorp");
    }
}
```

The simplest solution would be to draw a semi-transparent black rectangle over the entire screen, with the opacity decreasing over the duration of the transition.

```
public sealed class FadingInLogoScene : IScene
{
    private const int _durationMs = 2000;
    
    private bool _transitionComplete;
    private double _elapsedMs;
    private int _opacity = 255; 

    public void Init()
    {
        Input.On(Control.Start, () => Navigation.NavigateToScene("MainMenu"));
    }

    public void Update(TimeSpan delta)
    {
        if (!_transitionComplete)
        {
            _elapsedMs += delta.TotalMilliseconds;
            _opacity = (int)(255 - 255 * (_elapsedMs / _durationMs));
            _transitionComplete = _elapsedMs >= _durationMs;
        }
    }

    public void Draw()
    {
        UI.DrawBackgroundColor(Color.Black);
        UI.DrawCentered("Images/Logo/evilcorp");
        
        if (!_transitionComplete)
            UI.DrawRectangle(new Rectangle(0, 0, 1920, 1080),
                Color.FromNonPremultiplied(0, 0, 0, _opacity));
    }    
}
```

That works like a charm. However, it couples the Logo Scene to its fade-in transition. Furthermore, if there are other scenes that should use a fade-in transition, someone might end up writing this same code in another scene. Let's pull out the fade-in functionality and add it using composition.


```
public sealed class FadingIn : IScene
{
    private readonly IScene _scene;
    private readonly int _durationMs;
    
    private bool _transitionComplete;
    private double _elapsedMs;
    private int _opacity = 255;

    public FadingIn(int durationMs, IScene scene)
    {
        _durationMs = durationMs;
        _scene = scene;
    }

    public void Init()
    {
        _scene.Init();
    }

    public void Update(TimeSpan delta)
    {
        if (!_transitionComplete)
        {
            _elapsedMs += delta.TotalMilliseconds;
            _opacity = (int)(255 - 255 * (_elapsedMs / _durationMs));
            _transitionComplete = _elapsedMs >= _durationMs;
            return;
        }

        _scene.Update(delta);
    }

    public void Draw()
    {
        _scene.Draw();

        if (!_transitionComplete)
            UI.DrawRectangle(new Rectangle(0, 0, 1920, 1080),
                Color.FromNonPremultiplied(0, 0, 0, _opacity));
    }
}
```

Now we can add the Fade-In transition to any scene via composition. 

```
return new SceneFactory(new Dictionary<string, Func<IScene>>
{
    { "Logo", () => new FadingIn(2000, new LogoScene()) }
});
```

Perhaps requiring a transition duration forces users to write more verbose code, when often they really don't care exactly how long the fade-in takes. Let's add a default value in a secondary constructor.

```
public sealed class FadingIn : IScene
{
    public FadingIn(IScene scene)
        : this (2000, scene) { }
    
    public FadingIn(int durationMs, IScene scene)
    {
        _durationMs = durationMs;
        _scene = scene;
    }
    
    ...
}
```

Now developers can effortlessly add the fade-in transition to any scene.

```
return new SceneFactory(new Dictionary<string, Func<IScene>>
{
    { "Logo", () => new FadingIn(new LogoScene()) },
    { "MainMenu", () => new FadingIn(new MainMenuScene()) }
});
```

<img src="/images/LogoFadeIn.gif" alt="" width="700" height="393" class="aligncenter size-full" />

----

Decorator pattern is an excellent way to add new behavior dynamically, and without coupling the the old behavior to the new. This is one of the best ways of following the Open-Closed Principle, which requires that we do not change existing code when adding new behavior. 

### Reader Challenge
* What would it take to add a Fade-out transition to a scene via composition? 
* What about the present structure of our Logo Scene makes it difficult to plug in a Fade-out transition?
