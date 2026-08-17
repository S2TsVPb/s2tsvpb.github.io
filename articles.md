---
layout: page
title: 文章列表
permalink: /articles/
---

<style>
  :root { --muted: #666; }
  html[data-theme="dark"] { --muted: #9a9a9a; }
  .cat-section { margin-bottom: 2.2rem; }
  .cat-head {
    display: flex; align-items: baseline; gap: 0.6rem;
    border-bottom: 2px solid var(--border-color);
    padding-bottom: 0.4rem; margin-bottom: 0.4rem;
  }
  .cat-head h2 { font-size: 1.1rem; margin: 0; }
  .cat-count { font-size: 0.8rem; color: var(--muted); }
  .post-entry { padding: 0.85rem 0; border-bottom: 1px dashed var(--border-color); }
  .post-entry:last-child { border-bottom: none; }
  .entry-title { font-size: 1.15rem; font-weight: 600; color: var(--link-color); text-decoration: none; }
  .entry-title:hover { text-decoration: underline; }
  .empty-tip { font-size: 0.85rem; color: var(--muted); padding: 0.5rem 0; }
</style>

<div class="cat-section">
  <div class="cat-head">
    <h2>📝 随笔集 essays</h2>
    <span class="cat-count">{{ site.categories.essays | size }} 篇</span>
  </div>
  {% for post in site.categories.essays %}
  <div class="post-entry">
    <a class="entry-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </div>
  {% endfor %}
</div>

<div class="cat-section">
  <div class="cat-head">
    <h2>📦 资源分享 resources</h2>
    <span class="cat-count">{{ site.categories.resources | size }} 篇</span>
  </div>
  {% for post in site.categories.resources %}
  <div class="post-entry">
    <a class="entry-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </div>
  {% endfor %}
</div>

<div class="cat-section">
  <div class="cat-head">
    <h2>🖼️ 画廊 gallery</h2>
    <span class="cat-count">{{ site.categories.gallery | size }} 篇</span>
  </div>
  {% for post in site.categories.gallery %}
  <div class="post-entry">
    <a class="entry-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </div>
  {% endfor %}
  {% if site.categories.gallery.size == 0 %}
  <p class="empty-tip">画廊暂时还没有内容，敬请期待 🌱</p>
  {% endif %}
</div>
