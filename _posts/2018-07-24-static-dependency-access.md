---
layout: post
title: Static Dependency Access
date: 2018-07-24 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/globe-hexagons.jpg
---

Static Dependency Access

There has always been a lot of controversy over the right ways to access dependencies. Should they be injected? Located? Directly referenced? Magically resolved? Inverted? Context objects? Everyone tends to speak very dogmatically about how they think you should or shouldn't access your dependencies. Statically accessing your dependencies is a very powerful and efficiency-boosting technique, you should absolutely use it, but you must avoid its many perils. 

Suppose you have an application which plays different background music in each scene.

The conventional wisdom says that you should do all of these things:
1) Create an abstract interface for the MusicPlayer, to support different implementations
2) Register an instance of the MusicPlayer in your composition root
3) Explicitly inject the instance of MusicPlayer into each object who needs it

The goal of the conventional wisdom is this:
1) Use clean abstractions to ease testing, 
2) Use clean abstractions to ease changing behavior (like not playing music when you are developing)
3) Make dependency usage clear
4) Make the composition root clearly declare the configuration of your application

The codebase looks something like this 

```
public interface MusicPlayer
{
	void Play(string songName, float volume);
}

public class MainMenuScene : IScene
{
	private MusicPlayer _musicPlayer;

	public MainMenuScene(MusicPlayer musicPlayer) { ... }
	
	public void OnInit() 
	{ 
		_musicPlayer.Play("SomeSong", 0.5f); 
	}
}

... public OptionsScene(MusicPlayer musicPlayer) { ... } ...
... public CreditsScene(MusicPlayer musicPlayer) { ... } ...
... public CharacterSelectionScene(MusicPlayer musicPlayer) { ... } ...
... public SaveLoadScene(MusicPlayer musicPlayer) { ... } ...
... public LevelSelectionScene(MusicPlayer musicPlayer) { ... } ...
```

This feels good at first. You write all the code. You inject the MusicPlayer into each scene when you instantiate him. You get a nice dopamine hit in your brain as you tell yourself that this code follows the best practices. It's elegant. It's perfect.

So, you keep developing. The next feature you are working on has some visuals. Each scene needs to have a different background image. That sounds simple enough. Let's pull in a Spritebatch and start drawing images.

```
public interface SpriteBatch 
{
	void Draw(string imageName, Transform2 transform);
}

public class MainMenuScene : IScene
{
	private MusicPlayer _musicPlayer;
	private SpriteBatch _sprites;

	public MainMenuScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch) { ... }
	
	public void OnInit() 
	{ 
		_musicPlayer.Play("SomeSong", 0.5f); 
	}
	
	public void Draw()
	{
		_sprites.Draw("MainMenuBg.jpg", new Transform2(new Size2(1920, 1080));
	}
}

... public OptionsScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch) { ... } ...
... public CreditsScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch) { ... } ...
... public CharacterSelectionScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch) { ... } ...
... public SaveLoadScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch) { ... } ...
... public LevelSelectionScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch) { ... } ...
```

You update all of your scenes, make their constructors bigger, store the spritebatch in a field, register your `SpriteBatch` in the composition root, and inject him into every single scene. It took a bit more work than you expected, but hey, everyone knows that sometimes writing code the right takes a bit of work. "This is just the price of doing things the right way", you tell yourself. However, doubt starts to grow at the back of your brain. Too small to acknowledge, but just enough to make you think, "Should it be this hard to add something that I already know I need just about everywhere?"

The next ticket is waiting for you in `Up Next`, you quickly assign it to yourself and mark it `In Progress`. It's time to add navigation to all your scene. Users will want to click buttons or perform actions that will take them from one scene to another. No problem.

```
public interface Navigation 
{
	void NavigateTo(string sceneName);
}

public class MainMenuScene : IScene
{
	private MusicPlayer _musicPlayer;
	private SpriteBatch _sprites;
	private Navigation _navigation;

	public MainMenuScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch, Navigation navigation) { ... }
}

... public OptionsScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch, Navigation navigation) { ... } ...
... public CreditsScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch, Navigation navigation) { ... } ...
... public CharacterSelectionScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch, Navigation navigation) { ... } ...
... public SaveLoadScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch, Navigation navigation) { ... } ...
... public LevelSelectionScene(MusicPlayer musicPlayer, SpriteBatch spriteBatch, Navigation navigation) { ... } ...
```

You update all of your scenes, make their constructors bigger, store the navigation in a field, register your `Navigation` instance in the composition root, and inject him into every single scene. Now, the work isn't partiularly hard, but it is extremely verbose and tedious. The small doubt becomes a full-fledged thought, "Is there a better way to do this?"

---- 

### A Better Way

----

Once the game is all wired up, the rest of everything happens in the scenes. They all need generally the same sorts of dependencies. The usage flow of the application looks like this:

1) Init Game Application
	2) Navigate User to Main Menu
		3) User Initializes a Game Instance (New Game/Load/Continue)
			4) User Plays Game

As long as the application only actually uses one instance of `AudioPlayer`, `SpriteBatch`, and `Navigation`, and as long as those are wired up before the User reaches the Main Menu, the application will function correctly, in all scenes. Realistically, it doesn't make a lot of sense to change the way one plays sounds (use the OS Audio Devices) or display visuals (use the OS Video Devices). Some things will change (resolution, FPS, windowed/fullscreen, volume, sound/music balance, subtitles, etc), and some things just won't. 

There is a better way than following the conventional wisdom of constructor injection. Access your general dependencies statically. The codebase looks like this instead.

```
public interface MusicPlayer
{
	void Play(string songName, float volume);
}

public static class Music
{
	private static MusicPlayer _musicPlayer;

	public static void Init(MusicPlayer musicPlayer) { ... }

	public void Play(string songName, float volume) { _musicPlayer.Play(songName, volume) };
}

public class MainMenuScene : IScene
{
	public void OnInit() 
	{ 
		Music.Play("SomeSong", 0.5f); 
	}
}

... public OptionsScene() { ... } ...
... public CreditsScene() { ... } ...
... public CharacterSelectionScene() { ... } ...
... public SaveLoadScene() { ... } ...
... public LevelSelectionScene() { ... } ...
```

**This is a far more ergonomic design.** Now, creating a new scene won't involve all of the boilerplate of bringing in the `MusicPlayer` to play the background music. Having scenes do more things doesn't require massive changes rippling through the whole codebase to wire in the new dependency. 

It also still accomplishes all of the goals of following the conventional constructor injection wisdom.
1) Use clean abstractions to ease testing
2) Use clean abstractions to ease changing behavior
3) Make dependency usage clear
4) Make the composition root clearly declare the configuration of your application

----

When Should You Make a Dependency Statically Accessible?

----

- When it has a clean abstraction
- When your application only needs one instance
- When a large number of classes are all injecting the same dependency

----

What Pitfalls Should Be Avoided With Static Dependencies?

----

- Don't allow arbitrary resolution (such as `T Resolve<T>()`) which leads to Runtime Errors
- Don't make a dependency statically available until enough classes need it
- Don't allow a dependency to be changed after application wireup

----

**Ergonomics is a critical API trait.** Your software can be well-designed and follow the "right" principles, while still be cumbersome and verbose. Learning where and when to adapt and make concessions for syntax and usability is a key skill to develop. Sometimes providing static accessors for instance dependencies is the best choice. **Look for patterns of duplication and verbosity in your code and let them guide you to designs that are more ergonomic.** Don't be afraid to adapt things and make them more usable for your team and your software project. 


