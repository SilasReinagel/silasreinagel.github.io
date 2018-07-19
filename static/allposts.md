---
layout: default
title: "All Posts"
permalink: all.html
---

<div class="index">
  <h1 class="title">All Posts</h1>
  <hr />
  {% for post in site.posts %}
    <a href="{{ post.url }}">
      <div class="post">
        <h3 class="h3 post-title">{{ post.title }}</h3>
        <p><small>{{ post.date | date: "%B %e, %Y" }}</small></p>	
      </div>
    </a>		
  {% endfor %}	
</div>