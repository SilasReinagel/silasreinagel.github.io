---
layout: default
title: "Projects"
permalink: projects.html
---


<div class="projects-container">
  These are some of the non-NDA software projects I've built recently:
  {% for project in site.data.project.projects %}
  <div class="project-card">
    <h2 class="project-title">{{ project.title }}</h2>
    <p><strong>Date:</strong> {{ project.date }}</p>
    <p><strong>Type:</strong> {{ project.appType }}</p>
    <p><strong>Status:</strong> {{ project.status }}</p>
    <p><strong>Description:</strong> <span class="description">{{ project.description }}</span></p>
    <a href="{{ project.url }}" class="project-link" target="_blank">Learn More</a>
  </div>
  {% endfor %}
</div>

<style>
.project-title {
  margin-top: 0px;
}

.projects-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
  align-items: center;
}

.project-card {
  background-color: #f9f9f9;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  padding: 20px;
  width: 600px;
  min-width: 300px;
  text-align: left;
}

.project-card h2 {
  font-size: 1.5em;
  margin-bottom: 10px;
}

.project-card p {
  margin: 10px 0;
}

.description {
  font-size: 0.9em;
}

.project-link {
  display: inline-block;
  margin-top: 15px;
  padding: 10px 20px;
  background-color: #007bff;
  color: #fff;
  text-decoration: none;
  border-radius: 5px;
}

.project-link:hover {
  background-color: #0056b3;
  color: #fff;
}
</style>



