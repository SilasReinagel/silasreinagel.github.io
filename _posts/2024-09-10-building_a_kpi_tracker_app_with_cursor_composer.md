---
layout: post
title: Building a Fullstack KPI Tracker App with Cursor Composer
date: 2024-09-10 11:00
author: silas.reinagel@gmail.com
comments: true
categories: [ai, cursor, development, kpi-tracker]
featured-img: /images/building-fullstack-kpi-tracker-app-with-cursor-composer.jpg
---

In this blog post, I'll explore the process of building a simple full-stack KPI (Key Performance Indicator) tracker application using Cursor Composer, a powerful AI-assisted coding tool. I'll walk through the development process, highlighting 
the strengths and limitations of using AI in software development.

---

## Introduction

Cursor Composer is an advanced feature of the Cursor IDE that allows developers to work with multiple files simultaneously, create new files, and make sweeping changes across a project. It's particularly useful for full-stack development, where you need to coordinate changes between frontend and backend components.

To see this process in action, check out [this video demonstration](https://www.youtube.com/watch?v=OohBglX5MgI) where I build the KPI tracker app in about an hour, sped up 10x for brevity.

<img src="/images/building-fullstack-kpi-tracker-app-with-cursor-composer.jpg" alt="Building a KPI Tracker App with Cursor Composer"/>

## Tech Stack

For this project, I used a Node.js backend with SQLite for the database. This setup allows for easy deployment to a server without complex database hosting requirements. I built the frontend using React with Tailwind CSS for styling.

---

## Key Development Moments

1. **Authentication**: I implemented basic authentication to secure the API. For simplicity, I used a configurable user system rather than a full login flow.
2. **API Centralization**: I centralized all API calls into a single file for consistency and easier management of headers.
3. **Error Handling**: I set up a toast notification system to display errors in the user interface.
4. **CORS Configuration**: I addressed Cross-Origin Resource Sharing (CORS) issues to enable frontend-backend communication.
5. **Database Schema Updates**: I added utility functions to recreate the database when schema changes were made, which is particularly useful for SQLite in development.
6. **KPI and Event Management**: I built features to create and view KPIs, as well as record and view events associated with these KPIs.

---

## Cursor Composer Insights

- **Multi-file Editing**: Cursor Composer excels at working across multiple files, but it requires explicit tagging of files you want to reference or modify.
- **UI Layouts**: The AI is proficient at creating decent UI layouts, especially when using frameworks like Tailwind CSS.
- **Limitations**: Cursor Composer doesn't handle package installation or complex setup processes (like configuring PostCSS for Tailwind).
- **Project Templates**: Starting from a template with basic configurations can significantly speed up the development process.
- **Technology Preferences**: Using a Cursor rules file to specify preferred technologies helps the AI make better decisions about syntax and library usage.

---

## Lessons Learned

1. **Developer Expertise Still Crucial**: While AI tools like Cursor Composer are powerful, they still require a developer's understanding of architecture, integration, and troubleshooting.
2. **File Organization**: Centralizing related functionality into single files can make it easier for the AI to reference and modify code.
3. **Time Zone Challenges**: Proper handling of time zones and date ranges remains a complex task that often requires additional libraries.
4. **Setup and Configuration**: Some aspects of project setup, scaffolding, and library configuration still require manual intervention.

---

## Conclusion

Building a KPI tracker app with Cursor Composer demonstrated the tool's potential to accelerate development significantly. However, it also highlighted the ongoing need for developer expertise in guiding the AI, making architectural decisions, and handling complex integration challenges.

As AI-assisted coding tools continue to evolve, they're becoming increasingly valuable for developers. Tools like Cursor Composer are not about replacing programmers but about enhancing their productivity and allowing them to focus on higher-level design and architectural decisions.

Have you tried using Cursor Composer or similar AI-assisted coding tools? Share your experiences in the comments below!
