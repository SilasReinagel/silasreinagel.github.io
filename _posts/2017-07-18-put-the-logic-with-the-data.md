---
layout: post
title: Put the Logic with the Data
date: 2017-07-18 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/logic-flow.jpg
---

The understandability of code is directly related to the distance between the data and the code that makes decisions based on that data. The fewer places you have to look to see the actual behavior of the system, the easier it is to comprehend. 

<img src="/images/logic-flow.jpg" alt="Logic Flow Diagram"  />

Recently, I was working with a lower-level system that doesn't have UI controls, and the project needed the ability to let objects respond to various Mouse interactions. I built the `MouseStateActions` component to hold the data that describes what is to be done as its relationship to the mouse changes:

```
public sealed class MouseStateActions
{
    public MouseState CurrentState { get; set; } = MouseState.None;
    public DateTime ClickedAt { get; set; } = DateTime.MinValue;
        
    public Action OnReleased { get; set; } = () => {};
    public Action OnHover { get; set; } = () => {};
    public Action OnPressed { get; set; } = () => {};
    public Action OnExit { get; set; } = () => {};
}
```

I built the MouseStateProcessing system to get the current mouse state, and then iterate through all the UI components and update them based on their location relative to the mouse. 

```
public sealed class MouseStateProcessing : ISystem
{
    private MouseDeltaSnapshot _mouse = new MouseDeltaSnapshot();
    
    public void Update(IEntities entities, TimeSpan delta)
    {
        _mouse = _mouse.GetCurrent();

        entities.With<MouseStateActions>((o, m) =>
        {
            if (!o.Transform.Intersects(_mouse.Position))
            {
                if (m.CurrentState != MouseState.None)
                    m.OnExit();
                m.CurrentState = MouseState.None;
            }
            else if (!o.Transform.Intersects(_mouse.LastPosition))
            {
                m.OnHover();
                m.CurrentState = MouseState.Hovered;
            }
            else if (_mouse.ButtonJustPressed)
            {
                m.ClickedAt = DateTime.Now;
                m.OnPressed();
                m.CurrentState = MouseState.Pressed;
            }
            else if (_mouse.ButtonJustReleased)
            {
                m.OnHover();
                if ((DateTime.Now - m.ClickedAt).Milliseconds < 150)
                    m.OnReleased();
                m.CurrentState = MouseState.Hovered;
            }
        });
    }
}
```

Whenever you see code in one class manipulating more than a single Field, Variable or Property in another class, this is a sure sign that a refactor is needed. I simplified the system by moving the logic that acts on the data into the class that holds the data.

```
public sealed class MouseStateProcessing : ISystem
{
    private MouseSnapshot _mouse = new MouseSnapshot();
    
    public void Update(IEntities entities, TimeSpan delta)
    {
        _mouse = _mouse.Current();

        entities.With<MouseStateActions>((o, m) =>
        {
            if (!o.Transform.Intersects(_mouse.Position))
                m.Exit();
            else if (!o.Transform.Intersects(_mouse.LastPosition))
                m.Hover();
            else if (_mouse.ButtonJustPressed)
                m.Click();
            else if (_mouse.ButtonJustReleased)
                m.Release();
        });
    }
}
```

This offers two benefits. First, this allows the `MouseStateActions` to hide its `CurrentState` and `ClickedAt` properties. This ensures that only the declarative properties can be set. Secondly, the `MouseStateProcessing` system is now much, much clearer. The code clearly indicates that he is an intermediary between the Mouse and the object with MouseStateActions. 

Furthermore, this reduces the coupling between the two since now there is no data passing between the System and the Component. This reduces the chance of bugs, and makes it easier to modify the behavior of MouseStateActions if further logic or state-tracking is needed in the future.

For data structures that you own, whenever and wherever possible, keep the logic and utility functions alongside the data.  
