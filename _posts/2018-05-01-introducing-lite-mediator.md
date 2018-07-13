---
layout: post
title: LiteMediator - In-Process Messaging Library
date: 2018-05-01 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/lite-mediator.jpg
---

The best libraries are discovered, rather than engineered. After using in-process messaging in .NET projects for several years, I have decided to release a library sharing it with all of you. Using messaging has been extremely helpful to me in both game development and modern web development. Both greatly benefit from lightly-coupled message-driven architectures, which makes Mediator pattern a perfect solution.

----

<a href="https://github.com/SilasReinagel/LiteMediator.DotNet"><img src="/images/lite-mediator-wide.jpg" alt="LiteMediator Logo" width="256" height="160" class="aligncenter size-full" /></a>

LiteMediator is available primarily as source code. I personally find that it is very helpful when I am developing to be able to easily view and modify any part of my application. 

Source code is available on [Github](https://github.com/SilasReinagel/LiteMediator.DotNet)

For those who prefer to manage their dependencies using package managers, I also have a [NuGet package](https://www.nuget.org/packages/LiteMediator/) available.

----

The two ways I typically use this are in an Actor-model fashion with objects who subscribe themselves to the messages they wish to listen to, and with a declarative application wireup where all the messages and their handlers are setup in the composition root. 

### Application Use Cases Declaration

As you are aware, well-architected applications are [transport protocol independent](http://silasreinagel.com/2017/03/21/independently-executable-units/). Mediator pattern is a great way to plug your application into external messaging code such as Web Controllers, Message Queue subscriptions, chatbot integrations and so forth.

The following is an example adapted from an ASP.NET Core financing pledge management microservice. The intent is to reveal, in a single place, all of the possible messages that the application receives, and what will happen when each message is received. The advantage of this approach is that one never needs to browse through a whole project to discover all of the use cases. 

```
public void ConfigureServices(IServiceCollection services)
{
    var sqlDb = new SqlDatabase(new EnvironmentVariable("AccountSqlConn"));
    var eventStore = new SqlEventStore(sqlDb, "Accounts.Events");
    var users = new Users(new UsersTable(sqlDb));
    var accounts = new Accounts(eventStore);
    var pledges = new Pledges(eventStore, users, accounts, 
        new PledgeFundingSettings());
	
    var appCommands = new SyncMediator();
    appCommands.Register<OpenAccount>(x => accounts.OpenAccount(x));
    appCommands.Register<SetOverdraftPolicy>(x => accounts.SetPolicy(x));
    appCommands.Register<TransactionRequest>(x => accounts.ApplyTransaction(x));
    appCommands.Register<RegisterUser>(x => users.RegisterUser(x));
    appCommands.Register<UnregisterUser>(x => users.UnregisterUser(x));
    appCommands.Register<AddRoles>(x => users.AddRoles(x));
    appCommands.Register<RemoveRoles>(x => users.RemoveRoles(x));
    appCommands.Register<SetPledge>(x => pledges.SetPledge(x)));
    appCommands.Register<FundPledges>(x => pledges.FundPledges(x)));
	
    services.AddSingleton(appCommands);
}
```

----

### Actor Model

The big idea for actor-model style usage is that each object should decide for himself which messages he wishes to publish and receive. This creates a more decoupled and complex system. It also enables all of the state of an object to be completely encapsulated. This is a very useful pattern for things that change frequently, such as reporting structures, user interface views and view models, and other presentation concerns. 

The following code sample is lightly adapted from my team's recent [Cyberpunk Murder Mystery game](https://enigmadragons.itch.io/modeajet-grand-resort). The flexibility here is useful, because if we decide that more state should be tracked and saved/loaded, no external classes need to change. `GameState` can simply subscribe to the new events that need to be persisted. 

```
public class GameState
{
    private readonly Dictionary<string, string> _memories = 
        new Dictionary<string, string>();
    private readonly HashSet<string> _viewedItems = new HashSet<string>();
    private readonly HashSet<string> _thoughts = new HashSet<string>();
    private readonly SyncMediator _events;

    public GameState(SyncMediator events)
    {
        _events = events;
        _events.Register<ItemViewed>(
            x => ChangeState(() => _viewedItems.Add(x.Item)));
        _events.Register<ThoughtGained>(
            x => ChangeState(() => _thoughts.Add(x.Thought)));
        _events.Register<ThoughtLost>(
            x => ChangeState(() => _thoughts.Remove(x.Thought)));
        _events.Register<DialogueMemoryGained>(x => ChangeState(() =>
        {
            _viewedItems.Add(x.Dialog);
            _memories.Add(x.Dialog, x.Location);
        }));
    }

    public bool HasViewedItem(string item)
    {
        return _viewedItems.Contains(item);
    }

    public bool IsThinking(string thought)
    {
        return _thoughts.Contains(thought);
    }

    private void ChangeState(Action updateState)
    {
        updateState();
        _events.Publish(new StateChanged());
    }
}
```

----

Have fun with the new library! I would love to see what you create with it. 
