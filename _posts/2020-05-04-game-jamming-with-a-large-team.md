---
layout: post
title: Game Jamming with a Large Team without Pure Chaos
date: 2020-05-04 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/angst-office-scene.jpg
---

A couple weekends ago, I led a team for Ludum Dare 46. We created a video game from scratch in 72 hours. Many people voiced expressed surprise, awe, and curiosity about how we managed to do that with such a large team and have everything work out smoothly. 

We created a game called Angst, a 2D Adventure-Exploration about fighting one's inner demons.

<div class="container mb2"><iframe width="592" height="333" src="https://www.youtube.com/embed/gOFLgwLXdds" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen style="margin-left: auto; margin-right: auto"></iframe></div>

I've led quite a number of game jam and software teams of various sizes before. I will briefly share my insights on what made it work well for us.

### The keys to working well with a large team are these:

1. Clear Shared Vision
2. Well-Defined Roles
3. Collaboration Tooling
4. Project Visualization

----

## 1. Clear Shared Vision

The team needs to understand what the key shared objectives are. Each team member has their own personal reasons for wanting to take part in a game jam. Some people want to learn. Some people are building portfolios. Some people really love games. Some people enjoy the flow-state that jamming brings. These are good, and they bring people together.

**For the team to succeed, people need to have a shared team vision.**

- What are the most important things to work on?
- How should the game look?
- How should the game sound?
- How should the game play?
- How big will the game be?

If everyone on the team knows the answers to these, it sets up a clear path for success.

**What did we do to communicate a shared vision for Angst?**
- Wrote a [Game Jam Guide](https://github.com/EnigmaDragons/LDJam46/blob/master/guides/game-jam-guide.md) before the jam started
- Wrote a detailed [Game Design Document](https://github.com/EnigmaDragons/LDJam46/tree/master/src/LDJam46/GDD%20(Game%20Design%20Documentation)) during the first phase of the jam
- Brainstormed together as a team to decide on the game
- Published and pinned each Milestone during the jam in Discord
- Held regular full-team demo syncs  

----

## 2. Well-Defined Roles

People are incredibly capable when you give them clear responsibilities. At the start of the jam, everyone should know exactly what parts they are responsible for delivering, and what areas they get to call the shots about. 

While it sounds like a good idea to have one person deciding everything, this doesn't scale well with a larger team. You want to aim for autonomy. 

**We have two types of roles. There are Leads and Contributors.** A Lead role is empowered to make any and all decisions for the entire team about his/her domain. The Lead Artist gets to make all final decisions about how the game should look. The Lead Game Designer gets to make all final decisions about the game rules and interactions. The Lead Programmer gets to make all final decisions about how the code should be structured and how systems should be integrated.

This sets up clear communication paths so that everyone on the team knows which person to ask about X part of the game. **With a larger team, you want to have more Leads, each with a focused area.**

When creating Angst, these were the roles we assigned up front.

- @Silas Reinagel - Project Manager / Integrator
- @Max - Lead Game Designer / Art Design
- @ZavixDragon  - Lead Programming
- @Jaroslav Vozár - Programming
- @Gordy - Lead Tester
- @Mustafa - Tester
- @KamuiHand - Lead Artist (2D)
- @GraphicEdit  - Art/Rigging/Animation (2D)
- @Youghurt - Art (2D)
- @verdentgrey - Art (2D)
- @AmerigoGazaway  - Music
- @Trevyn - Sound

----

## 3. Collaborative Tooling

This is important. Your tools should make collaboration easy. If your tools make working together hard, this will slow you down or cause frustration. 

**What do you need?**
- Source Control
- Real-Time Chat Tool
- Real-Time Screen Sharing Tool

**What did we use?**
- GitHub and Git for Source Control
- Discord for Chat and Screen-Sharing
- Google Drive for large Source Artwork before importing into Unity

We ran into two major problems during the jam. One problem was that initially our Artists were putting art into Unity folders, but they weren't running Unity. So, later integrators had merge conflicts with the generated `.meta` files.

Also, we had our `.gitignore` incorrectly configured for `.meta` files, so we had some painful merges and lost work. 

Both of these issues impressed upon us that it's not only necessary to have the right tools in place for collaboration, but also ensure they are correctly configured and used by everyone on the team. 

----

## 4. Project Visualization

Building a game with a large team is challenging because of how many little pieces of work need to be done. Without clear visualization, it can be very easy to miss important parts, or have trouble handing off finished pieces and getting them into the game.

**Having tools that can help you visualize your next work items, and what the team is working on is massively important.**

We use a Kanban board, with columns separated out by roles, that's directly integrated with our source control system to make it easy to see the current project status and team current work items at a glance.

For our team, we use Github, Github Issues, and Zube.io as our tools. 

I didn't take a screenshot of our board during the jam, sadly, but this example should still give you the basic idea.

<img src="/images/kanban-example-1.jpg" alt="One of our Zube Kanban boards." />

Other tools such as Trello can work well. Although, it's definitely much nicer to have it integrated into Source Control so that people don't have to manually update finished tickets, and the board never gets out of sync with the work items. 

----

### Summary

How did it go for us? **Overall, the team worked together very smoothly, even though this particular group had never worked together before.** People had a really enjoyable time and were genuinely pleased with what we created. Currently, our game is the #4 most popular LDJam46 game on itch.io 

After the game jam, we held a team Retrospective and talked through what went well, what didn't go well, and what we could improve in the future. You can read the [meeting notes from our retro](https://github.com/EnigmaDragons/LDJam46/blob/master/retro/retro-notes.md).

Want to play the game that we created? You can play on Windows, Mac, or in your browser here: https://enigmadragons.itch.io/angst

**Have you jammed with a large team before? What were your key learnings? Share below in the comments.**
