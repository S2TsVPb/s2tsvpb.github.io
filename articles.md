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
  .entry-date { font-size: 0.78rem; color: var(--muted); margin-left: 0.5rem; }
  .entry-excerpt { font-size: 0.85rem; color: var(--muted); margin: 0.25rem 0 0; line-height: 1.6; }
  .empty-tip { font-size: 0.85rem; color: var(--muted); padding: 0.5rem 0; }
  /* 搜索框 */
  #articles-search { margin-bottom: 1.5rem; }
  #articles-search-input {
    width: 100%;
    padding: 12px 16px;
    font-size: 16px;
    border: 1px solid var(--border-color);
    border-radius: 8px;
    background: var(--bg-color);
    color: var(--text-color);
    box-sizing: border-box;
    transition: border-color 0.2s;
  }
  #articles-search-input:focus {
    outline: none;
    border-color: var(--link-color);
    box-shadow: 0 0 0 3px rgba(3,102,214,0.1);
  }
  mark {
    background-color: #fff3a3;
    padding: 0 2px;
    border-radius: 2px;
  }
  #articles-search-results .cat-section:first-child { margin-top: 2.5rem; }
  #articles-search-results .empty-tip { margin-top: 2rem; }
</style>

<!-- 搜索框 -->
<div id="articles-search">
  <input type="text" id="articles-search-input" placeholder="🔍 搜索…" aria-label="搜索文章">
  <div id="articles-search-results"></div>
</div>

<!-- 静态分类列表 -->
<div id="articles-static">
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
</div>

<script>
  (function() {
    var input = document.getElementById('articles-search-input');
    var results = document.getElementById('articles-search-results');
    var staticList = document.getElementById('articles-static');
    var postsData = [];
    var groups = [
      { key: 'essays', title: '📝 随笔集 essays' },
      { key: 'resources', title: '📦 资源分享 resources' },
      { key: 'gallery', title: '🖼️ 画廊 gallery' }
    ];

    // 加载 search.json（与原搜索页同一数据源）
    fetch('{{ "/search.json" | relative_url }}')
      .then(function(r) { return r.json(); })
      .then(function(d) { postsData = d; })
      .catch(function() {
        results.innerHTML = '<p class="empty-tip">搜索数据加载失败，请稍后重试。</p>';
      });

    // HTML 转义，防止 XSS
    function escapeHtml(str) {
      return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    // 高亮关键词
    function highlight(text, keyword) {
      var escapedText = escapeHtml(text);
      var escapedKeyword = escapeHtml(keyword);
      if (!escapedKeyword) return escapedText;
      var regex = new RegExp('(' + escapedKeyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
      return escapedText.replace(regex, '<mark>$1</mark>');
    }

    // 生成包含第一处匹配的摘要片段
    function makeSnippet(content, keyword, maxLength) {
      maxLength = maxLength || 120;
      var lowerContent = content.toLowerCase();
      var lowerKeyword = keyword.toLowerCase();
      var index = lowerContent.indexOf(lowerKeyword);
      if (index === -1) return content.substring(0, maxLength);
      var half = Math.floor(maxLength / 2);
      var start = Math.max(0, index - half);
      var end = Math.min(content.length, index + keyword.length + half);
      var snippet = content.substring(start, end);
      if (start > 0) snippet = '…' + snippet;
      if (end < content.length) snippet = snippet + '…';
      return snippet;
    }

    function renderEntry(p, kw) {
      var snippet = makeSnippet(p.content || p.excerpt || '', kw, 120);
      return '<div class="post-entry">'
        + '<a class="entry-title" href="' + p.url + '">' + highlight(p.title, kw) + '</a>'
        + '<span class="entry-date">' + (p.date || '') + '</span>'
        + '<p class="entry-excerpt">' + highlight(snippet, kw) + '</p>'
        + '</div>';
    }

    // 搜索函数：按分类分组
    function performSearch(query) {
      results.innerHTML = '';
      if (!query.trim()) {
        staticList.style.display = '';
        return;
      }
      staticList.style.display = 'none';

      var keyword = query.trim();
      var keywordLower = keyword.toLowerCase();
      var hits = postsData.filter(function(post) {
        var haystack = (post.title + ' ' + (post.excerpt || '') + ' ' + (post.content || '') + ' ' + (post.categories || []).join(' ')).toLowerCase();
        return haystack.indexOf(keywordLower) !== -1;
      });

      if (hits.length === 0) {
        results.innerHTML = '<p class="empty-tip">没有找到相关文章，换个关键词试试</p>';
        return;
      }

      // 按分类归档
      var assigned = {};
      groups.forEach(function(g) { assigned[g.key] = []; });
      var other = [];
      hits.forEach(function(post) {
        var cats = post.categories || [];
        var placed = false;
        groups.forEach(function(g) {
          if (cats.indexOf(g.key) !== -1) { assigned[g.key].push(post); placed = true; }
        });
        if (!placed) other.push(post);
      });

      var html = '';
      groups.forEach(function(g) {
        if (assigned[g.key].length === 0) return;
        html += '<div class="cat-section">'
          + '<div class="cat-head"><h2>' + g.title + '</h2><span class="cat-count">' + assigned[g.key].length + ' 篇</span></div>';
        assigned[g.key].forEach(function(p) { html += renderEntry(p, keyword); });
        html += '</div>';
      });
      if (other.length > 0) {
        html += '<div class="cat-section">'
          + '<div class="cat-head"><h2>📂 其他</h2><span class="cat-count">' + other.length + ' 篇</span></div>';
        other.forEach(function(p) { html += renderEntry(p, keyword); });
        html += '</div>';
      }
      results.innerHTML = html;
    }

    // 处理中文输入法组合事件
    var composing = false;
    input.addEventListener('compositionstart', function() { composing = true; });
    input.addEventListener('compositionend', function() {
      composing = false;
      performSearch(input.value);
    });
    input.addEventListener('input', function() {
      if (!composing) performSearch(input.value);
    });
  })();
</script>
