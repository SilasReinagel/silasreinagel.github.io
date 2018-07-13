---
layout: post
title: Build Horizontally, not Vertically
date: 2016-09-26 19:26
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/vertical-programs-jenga.jpg
---

<strong>If you want a program that is fragile, rigid, and immobile, build vertically.</strong>

<strong>If you want a program that is flexible, robust, and reusable, build horizontally.</strong>

<img src="/images/verticalilty-is-forever.jpg" alt="Verticalilty is Forever (Twin Towers)" width="202" height="300" class="aligncenter size-medium" />

----

### What is meant by building vertically or horizontally?

----

Vertical building is what happens anytime you put something new on top of something else. It's a visual metaphor, which represents depth, and layers of dependencies.

- A city is built more vertically when it puts more people in the same geographical area.
- A two-story house is built more vertically than a one-story house.
- A 30-line method is built more vertically than a 12-line method
- A class with 30 public methods is built more vertically than a class with 2 public methods.
- A program with 10 features is built more vertically than a program with 3 features.


Horizontal building is what happens anytime you put something next to something else. It's a visual metaphor, which represents width, with outwards expansion instead of layers.

- A city expands its geographical area when increasing in population.
- A row of 3 houses is built next to each other, instead of a single three-story house.
- A class consists of 12 small methods, instead of 4 large ones.
- A program is built with 80 small classes, instead of 8 very large ones.
- A company has 3 very focused applications for sale, instead of 1 large application.


----

### Rigidity

----

Horizontality decreases rigidity in the following ways:

- New independent elements can be put alongside existing ones easily
- Removing existing elements is much easier, since there are fewer external effects
- Systems can be restructured more easily, since there are fewer layers
- Changes are easier to reason about due to the larger amount of internal subdivisions

Examples:

- Creating a new neighborhood of residential housing is easier than trying to double the occupancy of an existing populated neighborhood
- Adding a first-floor room to a house is easier than adding another floor
- Switching one plugin for an application is far simpler than switching to a new framework
- Understanding the implications of changing a non-inherited class is simpler than figuring out how to alter a class with 7 parent base classes
- Creating a new database table causes far fewer integration problems than making a change to an existing core table


----

### Fragility

----

Horizontality decreases fragility in the following ways:

- Smaller scopes decrease range of possible side effects
- Damage or failure in one subsystem is not very extensive or deep
- A failing subsystem impacts fewer external subsystems
- A failing subsystem has less surface area to examine and possibly repair
- A failing subsystem can be replaced with less effort

Examples:

- A skyscraper that catches on fire spreads more debris and may damage nearby buildings
- A jumbo jet that crashes kills more occupants than a private planes that crashes
- A program crash in one application does not directly impact other applications
- A 4-line method is easier to read and debug than a 20-line method
- A server that hosts only one Service causes less harm if it loses power than a server hosting 4 Services


----

### Immobility

----

Horizontality decreases immobility in the following ways:

- Systems have more clearly delineated subcomponents
- Simple functionality is always more general than complex functionality
- Each subcomponent has fewer connections to the outside
- Each subcomponent has few internal elements

Examples:

- It is easier for a family to move to another house than for all the occupants of an office building to relocate
- It is easier to move an alarm clock to a new room and plug it in, than it is to move a desktop PC with peripherals
- A small and focused class can easily be used in other projects
- A simple method can easily be used in another scenario with very small modifications
- A self-contained web authentication service can easily be used by many different applications without any changes
