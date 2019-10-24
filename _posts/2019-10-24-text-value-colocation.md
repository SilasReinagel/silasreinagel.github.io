---
layout: post
title: Keep Critical Values In Your Tests
date: 2019-10-24 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/knight-armor.jpg
---

One of the keys to a well-written unit test is clarity. A great unit test should be short, focused on a single use case, easy to read, and free from noise or complex setup. Here, I will talk briefly about where the critical values should live, inside a test.

<img src="/images/knight-armor.jpg" alt="A knight in a full suit of armor, exemplifying the scenario in the follow unit test." />

Consider the following unit test:

```    
[Test]
public void ArmorFlat_ApplyEffect()
{
    AllEffects.Apply(data, performer, new MemberAsTarget(target));

    Assert.AreEqual(6, target.State.Armor());
}
```

While it makes the test generally easy to read with the data built outside of the test, there is one quesion that can't be answered by reading this test.

**Why 6 Armor?**

What is special about exactly 6? Would 5 be okay? Why can't it be 4?

With a bit of effort, we find the answer in the surrounding context.

```
private EffectData data = new EffectData 
{ 
  EffectType = EffectType.ArmorFlat, 
  FloatAmount = new FloatReference(1) 
};

private Member performer = new Member(
    1,
    "Good Dummy One",
    "Paladin",
    TeamType.Party,
    new StatAddends()
);

private Member target = new Member(
    2,
    "Good Dummy Two",
    "Wooden Dummy",
    TeamType.Party,
    new StatAddends().With(StatType.Armor, 5)
);
```

It's a bit buried in there, but a little bit of reading eventually makes this clear. This test is expecting that if the target already has **5 Armor** and there is an effect to change that by **+1 Armor**, the target should then have **6 Armor**.

What can we do to make this test immediately clear?

Let's refactor the key values back into the test.

``` 
[Test]
public void ArmorFlat_ApplyEffect_ArmorIsChangedCorrectly()
{
    var addArmorEffect = ChangeArmorBy(1);
    var target = MemberWithStartingArmor(5);
    
    AllEffects.Apply(addArmorEffect, anyPerformer, new MemberAsTarget(target));
    
    Assert.AreEqual(6, target.State.Armor());
}
```

Now, the test makes it obvious why **6 Armor** is the correct amount.

When writing tests, it's definitely valuable to factor out tangential setup into helper methods and builders. But, it's essential to leave the critical values that matter to *this particular test* to remain in the test itself.

### Always co-locate the critical values inside the test itself. 

Reading the test alone should make the assertion completely clear. 
