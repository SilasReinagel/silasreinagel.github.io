---
layout: post
title: AI - How To Run Llama 2 Locally
date: 2024-03-14 16:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog, ai, llama2, llm]
featured-img: /images/ai-how-to-run-llama-2-locally.jpg
---

There are advantages to integrating with large open models. But there are also downsides. How do you control costs? What to do about data security? How do you control model versioning to avoid unexpected regressions? Running your own LLM model on your local machine or your own server is an effective class of solution to these types of engineering challenges.

---

Integrating with the OpenAI API is reasonably simple and there are many tutorials on how to do this. But, if you want to run a local model, it's harder to find the right on-ramps. Here's a simple guide to running Llama 2 on your computer.

<img src="/images/ai-how-to-run-llama-2-locally.jpg" alt="AI - How To Run Llama 2 Locally"/>

## Running Llama 2 Locally

Here are the 4 easy steps to running locally:
1. Install Ollama
2. Download the Llama 2 model
3. Serve the model using the Ollama CLI
4. Integrate with the model's REST API

### 1. Install Ollama

[Download](https://ollama.com/download) the latest version of the Ollama CLI.

Install it on your computer.

The installer ought to add `ollama` to your PATH variable. You can confirm that the CLI is installed correctly by running `ollama -v` from your terminal.

### 2. Download the Llama 2 Model (or other Pre-trained model)

Browse the [Ollama Model Librart](https://ollama.com/library) and select your preferred model.

For Llama 2 7B (the compact model) the model id is `llama2`

Pull your model by running terminal command `ollama pull llama2`

Wait until the model is fully downloaded locally.

### 3. Serve the Model

Run terminal command `ollama serve`

### 4. Integrate with the model's REST API

Use curl or your favorite HTTP/REST client.

```
curl http://localhost:11434/api/generate -d '{
  "model": "llama2",
	"prompt": "Say Hello World and nothing else",
  "stream": false
}'
```

If everything is running correctly, you should get back a JSON response body with a `response` value saying "Hello World!"

For more integration learnings, refer to the [API Documentation](https://github.com/ollama/ollama/blob/main/docs/api.md)

---

## Summary

Running Llama 2 locally is a straightforward process that opens up a world of possibilities for developers and AI enthusiasts alike. Happy coding, and may your local AI endeavors lead to innovative and exciting outcomes!

Did you get stuck somewhere? Got another question? Comment below.
