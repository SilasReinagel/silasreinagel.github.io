---
layout: post
title: Build Horizontally, not Vertically
date: 2016-09-26 19:26
author: silas.reinagel@gmail.com
comments: true
categories: [Software Engineering]
---
<strong>If you want a program that is fragile, rigid, and immobile, build vertically.</strong>

<strong>If you want a program that is flexible, robust, and reusable, build horizontally.</strong>

<img src="http://silasreinagel.com/wp-content/uploads/2016/09/VerticaliltyIsForever-202x300.jpg" alt="Verticalilty is Forever (Twin Towers)" width="202" height="300" class="aligncenter size-medium wp-image-51" />

<hr />

<h3>What is meant by building vertically or horizontally?</h3>

<hr />

Vertical building is what happens anytime you put something new on top of something else. It's a visual metaphor, which represents depth, and layers of dependencies.

<ul>
<li>A city is built more vertically when it puts more people in the same geographical area.</li>
<li>A two-story house is built more vertically than a one-story house.</li>
<li>A 30-line method is built more vertically than a 12-line method</li>
<li>A class with 30 public methods is built more vertically than a class with 2 public methods.</li>
<li>A program with 10 features is built more vertically than a program with 3 features.</li>
</ul>

Horizontal building is what happens anytime you put something next to something else. It's a visual metaphor, which represents width, with outwards expansion instead of layers.

<ul>
<li>A city expands its geographical area when increasing in population.</li>
<li>A row of 3 houses is built next to each other, instead of a single three-story house.</li>
<li>A class consists of 12 small methods, instead of 4 large ones.</li>
<li>A program is built with 80 small classes, instead of 8 very large ones.</li>
<li>A company has 3 very focused applications for sale, instead of 1 large application.</li>
</ul>

<hr />

<h3>Rigidity</h3>

<hr />

Horizontality decreases rigidity in the following ways:

<ul>
<li>New independent elements can be put alongside existing ones easily</li>
<li>Removing existing elements is much easier, since there are fewer external effects</li>
<li>Systems can be restructured more easily, since there are fewer layers</li>
<li>Changes are easier to reason about due to the larger amount of internal subdivisions</li>
</ul>

Examples:

<ul>
<li>Creating a new neighborhood of residential housing is easier than trying to double the occupancy of an existing populated neighborhood</li>
<li>Adding a first-floor room to a house is easier than adding another floor</li>
<li>Switching one plugin for an application is far simpler than switching to a new framework</li>
<li>Understanding the implications of changing a non-inherited class is simpler than figuring out how to alter a class with 7 parent base classes</li>
<li>Creating a new database table causes far fewer integration problems than making a change to an existing core table</li>
</ul>

<hr />

<h3>Fragility</h3>

<hr />

Horizontality decreases fragility in the following ways:

<ul>
<li>Smaller scopes decrease range of possible side effects</li>
<li>Damage or failure in one subsystem is not very extensive or deep</li>
<li>A failing subsystem impacts fewer external subsystems</li>
<li>A failing subsystem has less surface area to examine and possibly repair</li>
<li>A failing subsystem can be replaced with less effort</li>
</ul>

Examples:

<ul>
<li>A skyscraper that catches on fire spreads more debris and may damage nearby buildings</li>
<li>A jumbo jet that crashes kills more occupants than a private planes that crashes</li>
<li>A program crash in one application does not directly impact other applications</li>
<li>A 4-line method is easier to read and debug than a 20-line method</li>
<li>A server that hosts only one Service causes less harm if it loses power than a server hosting 4 Services</li>
</ul>

<hr />

<h3>Immobility</h3>

<hr />

Horizontality decreases immobility in the following ways:

<ul>
<li>Systems have more clearly delineated subcomponents</li>
<li>Simple functionality is always more general than complex functionality</li>
<li>Each subcomponent has fewer connections to the outside</li>
<li>Each subcomponent has few internal elements</li>
</ul>

Examples:

<ul>
<li>It is easier for a family to move to another house than for all the occupants of an office building to relocate</li>
<li>It is easier to move an alarm clock to a new room and plug it in, than it is to move a desktop PC with peripherals</li>
<li>A small and focused class can easily be used in other projects</li>
<li>A simple method can easily be used in another scenario with very small modifications</li>
<li>A self-contained web authentication service can easily be used by many different applications without any changes</li>
</ul>
