---
layout: post
title: Open Source Project Essentials
date: 2019-05-28 10:00
author: silas.reinagel@gmail.com
comments: true
categories: [blog]
featured-img: /images/giving-sapling.jpg
---

Open Source software has revolutionized the software industry. It enables truly widespread distribution of both code and coding artifacts that empower modern development. If you or your company are ready to give back to the world, these are the project essentials needed to share your code with the world and supercharge its continued development.

<img src="/images/giving-sapling.jpg" alt="A young sapling, held out towards the world in generous hands." />

----

### 1. Source Code Hosting

For developers who are taking an in-depth look at various libraries and offerings, discoverability and browsability are essential. This means all serious open source projects must be hosted on one of the big Open Source code sites.

At this point, GitHub is still king. There are other options, but if you are serious about Open Source, GitHub is the best place to host the source code. 

----

### 2. Library Distribution

Most developers simply import Open Source libraries into their codebases. This must be as easy as possible. Your package must be hosted on the biggest public package repository for your language (NuGet, npm, maven, PyPI, RubyGems, etc...)

- Open Source packages must be published to the package repository
- Package metadata must be set and maintained
- Package must follow a consistent versioning strategy

----

### 3. Usage Documentation

Having an open codebase and a published library artifact isn’t enough for a library to be usable. Usability and ease of integration is one of the key factors in the success of open source software projects. Developers should be able to easily integration the library into their software from reading the README alone.

Open Source projects must include a README
- README must include a software problem/solution description
- README must explain how to install the software
- README must explain how to configure the software for common use cases
- README must explain at least basic usage scenarios
- README ought to include a brief section comparing it with other existing similar pieces of open source software
- README ought to include documentation on how to address problems with learning or using the library

----

### 4. Contribution Policy

A project isn’t a truly open project unless other developers are empowered to make changes, report bugs, open feature requests, and submit pull requests.

- README should have a contribution section
- Issues Creation rights should be configured with appropriate access permissions
- Bug Report template must be included if public bug reports are allowed
- PR template should be included if public PRs are allowed

----

### 5. Public Architects / Owners

Ownership of all public project needs to be explicitly defined and maintained. The project architect / owner is responsible for the project. They must ensure that bugs and feature requests are prioritized and groomed. They must be available to answer questions that users have. They must ensure that the documentation is up to date, the current published artifacts are available and appropriately versioned. A project may be owned by a team or individuals, but someone must specifically be responsible for it.

- Open Source Project ownership must be documented, preferably in the README

----

### 6. Publicly Integrated CI/CD

Successful open source projects always attract external contributors. In order for contributors to submit their own pull requests and have those capable of being integrated in the project, the CI/CD system must be setup to be publicly visible. Failing builds and their reasons must be visible to PR authors. Every README should display the current build status.

- README should include a build badge linking to a public CI Build Pipeline
- PRs should be integrated with the CI Build Pipeline
- PRs should be set to require a passing Build as a merge prerequisite 

----

### 7. Licensing

Open source projects must have public licenses. This information should be in the README, clearly presently on the source code page (and, if needed, put as a file header on every source file). This is necessary for developers and companies to be able to re-use the source code in their own projects. 

----

### 8. Marketing

Presentation matters. For developers to begin adopting and contributing to open source projects, they must discover them. A web presence strategy is needed. New projects, new version releases and big updates must be communicated publicly. Providing a tech blog with regular updates is a good option for proving low-cost announcements. Posting about the project on social media is another great way to reach your followers. 
 
----

Is there anything that you think is essential for an Open Source software project that I missed? Share your thoughts in the comments!

