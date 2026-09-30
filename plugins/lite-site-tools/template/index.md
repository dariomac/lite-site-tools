---
title: Home
---

# Hi, I'm {{ site.author }}.

I'm moving into software development, and I use this site to write down what I
know and what I'm learning along the way.

## Latest posts

<ul class="post-list">
{% for post in site.posts limit:5 %}
  <li>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <span class="post-date">{{ post.date | date: '%b %-d, %Y' }}</span>
  </li>
{% endfor %}
</ul>

[All posts &rarr;]({{ '/blog/' | relative_url }})
