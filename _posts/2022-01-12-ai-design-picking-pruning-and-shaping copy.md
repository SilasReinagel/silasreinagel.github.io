---
layout: post
title: AI Design - Picking, Pruning, and Shaping
date: 2022-01-12 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/ai-design-ice-cream-selection.jpg
---

AI Design is an intriguing problem space! In my recent experiences with AI, I've come to see the significant differences in the use of hard logic and soft logic heuristics and the effects they have on the quality of the decisions made by actors. Read on to accompany me on this journey.

<img src="/images/ai-design-ice-cream-selection.jpg" alt="AI Design - Ice Cream Selection"/>

## AI Design Fundamentals

When designing AI, you are in a space that consists primarily of purpose, information, and decisions. A successful AI fulfills its purpose by using a set of information to make good decisions. 

A well-designed AI is both successful and also behaves well in scenarios that it has not yet been presented with. This is one of the big challenges in any simulation since the introduction of new elements is a hallmark of any likely human context where an AI would be deployed

---

## Ice Cream Shopping Journey

For this brief journey, we're going to simplify the information and purpose aspects of AI design, and simply focus on the decision-making aspect.

For today's toy example, we'll look at an AI going out for a treat at an Ice Cream Shop. Our AI is successful if its decisions in every known scenario are good choices. It is well-designed if it handles most or all scenarios well, even ones that were not used to inform its design. 

```
Scenario 1 - Buy 1:
$5 - Chocolate Ice Cream
$5 - Vanilla Ice Cream
```

The simplest and most naive solution is to give the AI one's preference and teach it to choose that. 
- `#1 Pick Chocolate`

```
Scenario 2 - Buy 1:
$5 - Vanilla Ice Cream
$5 - Strawberry Ice Cream
```

With this scenario, our previous AI Design leaves us disappointed and treatless, as our AI is forever stuck at the counter without being able to make a valid decision.

A better design should be able to handle both scenarios reasonably.

Many potentially better picking strategies are possible. 
- `#2 Pick the first`
- `#3 Pick the second`
- `#4 Pick the last`
- `#5 Pick one at random`

```
Scenario 3 - Buy 1: 
$50 - Rocky Road Ice Cream
$5 - Cherry Vanilla Ice Cream
$1 - Extra Napkins
```

Of our various new picking strategies, two of them would leave us very unhappy after our third purchase, and one would have a very good chance of leaving us unhappy. Only one of the strategies would make us feel good about our AI decision (#3), and even then, it's only a positional accident.

To evolve our AI, we would need to evolve the criteria. This adds a pruning factor. 
- `#6 Pick the first ice cream that costs less than $10`

<img src="/images/ice-cream-01.jpg" alt="AI Design - Delicious Ice Cream"/>

```
Scenario 4 - Buy 1:
$5 - Limoncello Gelato
$5 - Tiramisu Gelato
```

Scenario 4 shows us that we overspecified our picking. One of the key dangers of picking is that there are a large set of possible scenarios in which the AI will be unable to make a decision. It's certainly possible to have a pure picking algorithm that will work, but it can be risky and inflexible.

For this reason, it's generally preferable to use a shaping algorithm in AI Design. A shaping algorithm is anything that influences the final decision without removing possibilities from the selection set. This can be as simple as sorting, or as complex as assigning weighted values to options.

Here's an example of shaping combined with a final pick.
- `#7 Sort by price, pick the cheapest food item`

```
Scenario 5 - Buy 1:
$1 - Extra Gummy Bears
$5 - Vanilla Ice Cream
$6 - Tiramisu Gelato
$6 - Limoncello Gelato
```

Our pricing sorting shaping works fairly nicely, but now the final pick was underspecified.

One way to evolve this strategy is to provide preferences for known things. Without needing more information for analysis, we could give preference to Gelato and Ice Cream. 

- `#8 Preferring Ice Cream and Gelato, pick the cheapest, most preferred food item`

```
Scenario 6 - Buy 1:
$99 - Ultra-Premium Chocolate Ice Cream
$98 - Ultra-Premium Vanilla Ice Cream
```

The shaping helped a lot, but now our AI decision resulted in substantial overspending.

To fix this issue, we can use a pruning criteria and add a fallback.
- `#9 Preferring Ice Cream and Gelato, of the items that cost less than $20, pick any random one of most preferred food items or if there are none, leave the store without buying anything.`

```
Scenario 7 - Buy 1:
$1 - Extra Gummy Bears
$1 - Extra Napkins
$5 - Chocolate Ice Cream
$5 - Vanilla Ice Cream
$5 - Strawberry Ice Cream
$5 - Cherry Vanilla Ice Cream
$6 - Tiramisu Gelato
$6 - Limoncello Gelato
$50 - Rocky Road Ice Cream
$99 - Ultra-Premium Chocolate Ice Cream
$98 - Ultra-Premium Vanilla Ice Cream
```

The AI's final possible decisions from this set are tiered as:
```
Tier 1 - $5 - Chocolate Ice Cream
Tier 1 - $5 - Vanilla Ice Cream
Tier 1 - $5 - Strawberry Ice Cream
Tier 1 - $5 - Cherry Vanilla Ice Cream
Tier 1 - $6 - Tiramisu Gelato
Tier 1 - $6 - Limoncello Gelato
Tier 2 - $1 - Extra Gummy Bears
```

This selection set seems fantastic! Any AI picking from that tiered set is making a very reasonable decision.

So, we need a combination of picking (selection), pruning (filtering), and shaping (preferences), along with a fallback option to be able to handle a broad array of scenarios.

<img src="/images/ice-cream-02.jpg" alt="AI Design - Delicious Gelato"/>

## Summary

Shaping is the best place to start for an AI since it will inherently better handle novel situations and content than picking-based approaches. 

You'll typically find it highly useful to add pruning heuristics to prevent really stupid possible decisions. This is especially true if you're creating actors for financial systems!

Even though we began with picking in our example, generally an AI will be best if the picking is only used for the final selection, and if shaping is used for everything else.

Also... if you're not hungry for some ice cream after reading this article, I'm not sure you're actually human!
