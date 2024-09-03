---
layout: post
title: AI - Using Claude 3 with Cursor
date: 2024-03-18 18:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog, ai, claude3, cursor, llm]
featured-img: /images/ai-using-claude-3-with-cursor.jpg
---

As an AI-powered VSCode fork, Cursor has revolutionized the way developers interact with their code. By allowing users to invoke LLM assistance directly within the IDE using a simple Ctrl+K shortcut, Cursor has made it easier than ever to leverage the power of AI in coding projects. However, with Cursor's current reliance on OpenAI's API and models, users have been eagerly awaiting support for other cutting-edge LLMs.

---

**Note: This article is outdated. For the latest information on using Claude with Cursor, please see the [updated article](/2024/09/03/claude-with-cursor-update/).**

Enter Claude 3 Opus, Anthropic's latest offering that has been making waves in the AI community for its impressive code generation capabilities. While Cursor hasn't officially integrated Claude 3 Opus yet, there's a way for users to access it (and a wide range of other models) through OpenRouter.ai.

<img src="/images/ai-using-claude-3-with-cursor.jpg" alt="AI - Using Claude 3 with Cursor IDE"/>

## Unlocking New Possibilities with OpenRouter.ai

OpenRouter.ai is a SaaS platform that acts as a universal API gateway for LLMs. By mimicking the OpenAI API structure, OpenRouter allows users to seamlessly switch between a vast array of models, including open-source options, proprietary models like GPT-4, and Anthropic's Claude series. OpenRouter also offers a range of other features, such as model versioning, model management, and usage analytics.

*(**Important Note:** Your mileage may vary. Each LLM works a bit differently and prompting is not the same across models. Your actual Cursor usage may be better/worse with Claude 3 or any other model you connect with. The prompts in Cursor are most optimized for Open AI models, currently.)*

Integrating OpenRouter into Cursor is a straightforward process that can be completed in just a few steps:

## Setting up Your OpenRouter Account

1. Sign up for an account on OpenRouter.ai.
2. Navigate to Account → Settings to save your payment details and add credits (consider setting up auto-top up for convenience).
3. In the settings, select your default model (Anthropic Claude 3 Opus)
4. Generate a new API key under Account → Keys (you can set a credit limit to manage usage).

## Configuring OpenRouter in Cursor

1. Launch Cursor and open the settings by pressing Cmd+Shift+J/Ctrl+Shift+J.
2. Find the "OpenAI API" section and enter your OpenRouter API key in the designated field.
3. Access the "Configure models" option below the API key field.
4. Add a new model by clicking "+ Add model" and entering "anthropic/claude-3-opus" as the model name.
5. Click the "+" button next to the field to confirm the addition.
6. Locate the "Override OpenAI Base URL (when using key)" text with an arrow and click on it.
7. Input "https://openrouter.ai/api/v1" as the API base URL.
8. Crucially, click the small arrow to the right of the OpenAI API key field above.
9. Wait for the "Using key" switch/checkbox to appear below the OpenAI API key field (there's no wait time indicator) and ensure it's enabled.
10. (Optional) Customize your active models by disabling unwanted ones or keeping multiple options available for selection during usage.

<img src="/images/cursor-openrouter-settings.jpg" alt="Cursor - OpenRouter Settings"/>

With this setup, you can now enjoy the benefits of Claude 3 Opus and other powerful LLMs directly within Cursor.

One of the most exciting aspects of using OpenRouter with Cursor is the ability to experiment with a diverse range of LLMs. Whether you're interested in exploring open-source options or comparing the performance of different proprietary models, OpenRouter makes it easy to switch between them and find the perfect fit for your needs.

---

## Summary

By combining the power of Cursor with the flexibility of OpenRouter.ai, developers can now access a world of cutting-edge LLMs, including Anthropic's Claude 3 Opus, without waiting for official integration. This opens up new possibilities for AI-assisted coding and allows users to find the perfect model for their specific requirements.

If you've tried using OpenRouter with Cursor, I'd love to hear about your experiences! Share your thoughts, tips, and favorite models in the comments below. And for more in-depth guides on optimizing your AI-powered development workflow, be sure to explore my other blog posts!
