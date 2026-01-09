---
layout: post
title: "Web Pages Are Not the Future"
date: 2026-01-08 17:00
author: silas.reinagel@gmail.com
comments: true
categories: [ai, agents, web, technology, future]
featured-img: /images/web-pages-not-the-future-ai-agents-machine-internet.jpg
---

We built the internet for human eyes. Every pixel of CSS, every carefully kerned headline, every hamburger menu and hover state—all of it exists because humans need visual hierarchy to parse information. We've spent three decades optimizing for wetware that processes 40 bits per second consciously. But the new primary users of the internet don't have eyes. They don't need your gradient buttons. They don't care about your font choices. And they're about to inherit the web.

---
<img src="/images/web-pages-not-the-future-ai-agents-machine-internet.jpg" alt="Web pages are not the future - AI agents and the machine-optimized internet"/>

HTML was a miracle. In 1991, Tim Berners-Lee gave us a way to link documents across the planet. Then we added CSS to make them beautiful. JavaScript to make them interactive. Frameworks to make them reactive. 

We perfected the art of rendering information for human consumption.

**And now it's becoming obsolete.**

Not because HTML failed. Because it succeeded—at the wrong problem.

The fastest-growing consumers of internet services aren't humans scrolling feeds. They're AI agents executing tasks. And they don't need web *pages*. They need web *capabilities*.

---

## Imagine 2032

It's a Tuesday morning. You wake up and say: "Book a cabin in Colorado for next weekend. Dog-friendly. Under $400 a night. Near good hiking."

Your agent goes to work.

It doesn't open Airbnb in a browser. It doesn't parse HTML looking for listing cards. It doesn't simulate clicking through filters and scrolling through results.

Instead, it hits Airbnb's capability endpoint directly. A terse, machine-optimized format that says: *Here are the available properties matching your constraints. Here are the actions you can take. Here are the parameters each action accepts.*

In 400 milliseconds, your agent has queried availability, cross-referenced hiking trail proximity from three services, checked your calendar, verified the property allows dogs, and initiated a booking—all without rendering a single pixel.

Meanwhile, the human-facing Airbnb website still exists. A beautifully designed experience for the 15% of users who prefer to browse listings manually, savoring the photos, reading reviews for fun, daydreaming about trips they'll never take.

**Two webs. One for humans who want to look. One for machines that need to act.**

---

## What Agents Actually Need

HTML is information rendered for visual processing. Agents don't process visually. They need:

### 1. Efficient Information Retrieval

Agents don't want to parse a 47KB HTML document to extract three data points. They want:

- Structured data formats (JSON, protobuf, MessagePack)
- Semantic schemas that describe what fields mean
- Minimal payloads with exactly the requested information
- No presentation layer, no styling metadata, no visual hierarchy hints

When an agent asks "what's the price?"—it shouldn't receive a styled `<span class="price-display text-2xl font-bold text-green-600">$249.99</span>`. It should receive `{"price": 249.99, "currency": "USD"}`.

### 2. Capability Discovery

Before an agent can act, it needs to know: *What can I do here?*

This is the real shift. HTML describes what something **looks like**. Agents need to know what something **does**.

- What actions are available?
- What parameters do they accept?
- What are the constraints?
- What will the responses look like?
- What authentication is required?

OpenAPI gets at this—imperfectly. It's verbose, designed in an era before agents, and focused on developer documentation rather than machine consumption. But it's the *right kind of thing*: a declarative description of capabilities.

The future needs something leaner. More semantic. Optimized for agents that need to discover, reason about, and execute actions in milliseconds.

### 3. Efficient Action Execution

Once an agent knows what's possible, it needs to act with minimal friction:

- Direct endpoints, not simulated form submissions
- Structured inputs, not field-by-field typing
- Immediate responses, not page reloads
- Clear success/failure signals, not visual cues

Clicking a button is a human concept. Agents don't click. They invoke.

---

## The 80/20 Split

Here's my prediction:

**By 2030, 80% of internet traffic will be machine-to-machine.** Agents talking to services. APIs calling APIs. Structured data flowing between systems without a human in the loop.

The remaining 20%? That's the human web. And it will thrive—but in a narrower niche:

- **Social media** – Humans doom-scrolling, seeking connection, performing identity
- **Entertainment** – Streaming, gaming, experiences designed for human pleasure
- **Creative content** – Articles, videos, art meant to be savored, not consumed for data
- **Exploration** – Browsing when you don't know what you want yet

These are domains where the *experience* is the point. Where visual design, emotional resonance, and serendipity matter.

But for everything transactional? Everything task-oriented? Everything where a human says "just get this done"?

**That's agent territory.** And agents won't be browsing web pages.

---

## What Machine-Optimized Looks Like

HTML won't disappear. It will become a specialized format for human-consumption endpoints—like how PDFs still exist for printable documents.

The default will shift to something like:

```
GET /capabilities
→ Returns structured schema of available actions, parameters, constraints

POST /actions/book-reservation
→ Structured input, structured response, no rendering

GET /data/availability?location=colorado&dates=2032-01-15..2032-01-17
→ Pure data, semantically described, minimal payload
```

Think of it as **the web without the page**.

The protocols might be HTTP. Or something new. The formats might be JSON. Or something more efficient. The capability descriptions might evolve from OpenAPI. Or from MCP. Or from something we haven't invented yet.

What matters is the pattern:

> **Machine-optimized endpoints that describe what's possible and execute what's requested—without the overhead of human presentation.**

---

## The Implications

If you're building software today, this matters:

**For your products:**
- Every capability you expose to humans should also be exposed to agents
- Your "API" isn't a secondary artifact—it's becoming the primary interface
- Design capability schemas as carefully as you design UI

**For your content:**
- Structured data matters more than ever
- Semantic markup isn't just for SEO—it's how agents understand you
- If an agent can't parse your content, you're invisible to 80% of traffic

**For your business:**
- Agent-to-service integration becomes a competitive moat
- Companies that are easy for agents to work with will win
- The "customer" increasingly is the agent, not the human behind it

---

## The Transition

We're in the transition now.

Agents today still scrape HTML. They simulate browsers. They parse visual layouts to extract meaning. It works, barely, because we haven't built anything better yet.

But it's inefficient. Fragile. Slow.

The first companies to offer clean, machine-optimized interfaces alongside their human-facing websites will see their usage explode. Agent developers will flock to services that are easy to integrate.

And slowly, then quickly, the center of gravity shifts.

The web doesn't die. It bifurcates.

**Human web: beautiful, experiential, emotional.**

**Machine web: terse, capable, efficient.**

Both legitimate. Both thriving. But only one growing.

---

## Conclusion

The web page was a revolutionary interface for human knowledge sharing. It will remain valuable for human experiences.

But **the page is not the future of the web**.

The future is capability-first. Schema-defined. Machine-optimized. A web where the primary question isn't "how does this look?" but "what can this do?"

HTML taught machines to serve humans.

The next chapter teaches machines to serve each other—and to serve humans better by getting out of the way.

> **The most powerful interface is no interface at all.**

Your users won't visit your website. Their agents will. Build accordingly.

