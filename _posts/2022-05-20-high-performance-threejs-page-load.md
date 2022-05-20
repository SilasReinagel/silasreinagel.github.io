---
layout: post
title: High-Performance ThreeJS - Page Startup Scripting
date: 2022-05-19 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/threejs-high-performance-page-load.jpg
---

ThreeJS is a powerful technology that opens the door to many new web experiences. However, it’s not easy to optimize for performance. There are several articles detailing improving the runtime performance of ThreeJS, but remarkably few focus on initial page load performance. Here is my contribution to the body of knowledge.

----

<img src="/images/threejs-high-performance-page-load.jpg" alt="ThreeJS High Performance Page Load - Ideal Experience Visualization"/>

As a purely technical analysis, and perhaps a bit of a damning one, I want to ensure that I set the stage correctly.

If you don't care about the precise details, feel free to skip to the end for my [framework recommendation based on the results of the benchmark](#recommendation).

## Experiment Motivation:

Initial page load and interaction speeds are very important for modern eCommerce buyers. It's especially critical for mobile devices, which vary greatly in quality and device power. I recently performed some deep-dive research into improving the Page Scripting Evaluation on a part of a major eCommerce website that uses ThreeJS to deliver the key experience. 

How critical are page load speeds? [They are a billion-dollar factor at scale.](https://www.cloudflare.com/learning/performance/more/website-performance-conversion-rates/)

## Experiment Catalyst:

When running various profiling and web performance tools on our site, we discovered that Page Script Evaluation was one of the biggest bottlenecks.

Initial script evaluation must occur before the ThreeJS experience can be rendered and become available and interactive for the page visitor.

## Benchmark Tool:

While Lighthouse is a very popular tool for standard web benchmarking, it doesn't provide very reliable or useful metrics for ThreeJS sites, particularly because it has a hard time interpreting the experience.

For the benchmarks covered in this article, I used the Performance Tool built into Google Chrome. This seems to provide the best holistic metrics and visualization of the performance of a ThreeJS Experience

<img src="/images/threejs-scripting-benchmark-1.jpg" alt="ThreeJS Scripting Benchmark Image"/>

## Benchmark Experiment:

To measure the overhead of the particular framework stack, I used a minimal ThreeJS scene. Once that renders, we know that the JS stack has been loaded, evaluated, and a minimal ThreeJS experience has been delivered. 

The scene used for this is a simple Canvas with a Cube and a Basic Material.

<img src="/images/threejs-scripting-benchmark-2.jpg" alt="ThreeJS Scripting Benchmark Image"/>

## Frameworks Compared:

- Vanilla JS - [(No Framework)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
- Svelte - [Svelte + Svelte Cubed](https://svelte-cubed.vercel.app/)
- Vue - [TroisJS (ThreeJS + VueJS 3 + ViteJS)](https://troisjs.github.io/)
- React - [React + React Three Fiber](https://github.com/pmndrs/react-three-fiber)
- Next - [NextJs + React + React Three Fiber](https://github.com/pmndrs/react-three-next)

## Technical Caveats:

- A sample size of 2 is statistically insignificant. This isn't a comprehensive benchmark. Instead, this could be used as the springboard for a more robust benchmark project.
- Performance often changes with framework versions. While the benchmark results may be significant today, the ranking of any given framework could change with a new release.
- Projects were lightly-standardized, but not refined to be precisely identical. Since they represent an extremely trivial ThreeJS scene, they should be fair comparisons, but may not be identical comparisons.

## OKAY, ENOUGH DETAILS! LET THEM RACE!

<img src="/images/threejs-scripting-benchmark-total-scripting.jpg" alt="ThreeJS Scripting Benchmark Image"/>

<img src="/images/threejs-scripting-benchmark-time-to-ready.jpg" alt="ThreeJS Scripting Benchmark Image"/>

<img src="/images/threejs-scripting-benchmark-hot-chunk.jpg" alt="ThreeJS Scripting Benchmark Image"/>

## Recommendation

Caveats aside, it seems that we have two very clear winners.

If you want to use a JS framework for your ThreeJS experience, Svelte offers the fastest scripting performance by a good margin. It offers all the composability and the nice developer experience of a framework, without sacrificing as much speed as the others. The one downside is that the Svelte Three ecosystem isn't very mature yet, so it's a bit closer to working with plain ThreeJS than using something like React Three Fiber with DREI, which offers a very nice developer experience at the expense of scripting load speed.

If you want the very fastest page scripting experience, using no framework is the very fastest. The overhead is minimized completely, and you have precise control over all the performance characteristics of your ThreeJS experience. However, this can be more difficult since it requires more general coding expertise, stronger team JS skill, and doesn't provide as clear an architectural path as using a framework. For smaller and simpler ThreeJS experiences, this is probably the very best bet. For more complex experiences and applications, it might be better to use Svelte, even if performance is one of your key design considerations.

## Summary

In the current ThreeJS ecosystem, Vanilla JS (No Framework) and Svelte provide the highest performance application shells for delivering script-efficient ThreeJS experiences. Using one of these will dramatically improve your experience startup speed, which is a massively leveraged metric in eCommerce at scale.

This benchmark and analysis is just one step in our pursuit of high-performance 3D-enabled web experiences. There is potential for much better tooling around ThreeJS Web performance measurements and improvement recommendations. There is potential for a more rigorous and standardized benchmarking process. Also, there is a substantial opportunity for improving framework integrations with ThreeJS to deliver better Web performance.

I hope this analysis and recommendation is helpful to your own ThreeJS journey!

Share your thoughts, critiques, or questions in the comments below.
