---
layout: page
title: 搜索文章🔍
permalink: /search/
---

<noscript>您的浏览器需要启用 JavaScript 才能使用搜索功能。</noscript>

<style>
  #search-container { max-width: 100%; }
  #search-input {
    width: 100%;
    padding: 12px 16px;
    font-size: 16px;
    border: 1px solid #ddd;
    border-radius: 6px;
    margin-bottom: 20px;
    box-sizing: border-box;
    transition: border-color 0.2s;
  }
  #search-input:focus {
    outline: none;
    border-color: #0366d6;
    box-shadow: 0 0 0 3px rgba(3,102,214,0.1);
  }
  #results-container { list-style: none; padding: 0; margin: 0; }
  #results-container li {
    padding: 16px 0;
    border-bottom: 1px solid #eee;
  }
  .result-title { font-size: 18px; font-weight: 600; margin-bottom: 4px; }
  .result-title a { text-decoration: none; color: #0366d6; }
  .result-title a:hover { text-decoration: underline; }
  .result-meta { color: #888; font-size: 0.85rem; margin-bottom: 6px; }
  .result-snippet { color: #444; line-height: 1.5; }
  .no-results { text-align: center; padding: 40px 0; color: #999; }
  /* 高亮样式 */
  mark {
    background-color: #fff3a3;
    padding: 0 2px;
    border-radius: 2px;
  }
  .more-count {
    color: #888;
    font-size: 0.85rem;
    margin-left: 6px;
  }
</style>

<div id="search-container">
  <input type="text" id="search-input" placeholder="输入关键词搜索文章..." autofocus>
  <ul id="results-container"></ul>
</div>

<script>
  (function() {
    var input = document.getElementById('search-input');
    var resultsList = document.getElementById('results-container');
    var postsData = [];

    // 加载 search.json
    fetch('{{ "/search.json" | relative_url }}')
      .then(response => response.json())
      .then(data => {
        postsData = data;
      })
      .catch(err => {
        console.error('搜索数据加载失败:', err);
        resultsList.innerHTML = '<li class="no-results">搜索功能暂不可用，请稍后重试。</li>';
      });

    // HTML 转义，防止 XSS
    function escapeHtml(str) {
      return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    // 高亮关键词：先转义文本，再对转义后的关键词进行高亮
    function highlight(text, keyword) {
      var escapedText = escapeHtml(text);
      var escapedKeyword = escapeHtml(keyword);
      if (!escapedKeyword) return escapedText;
      var regex = new RegExp('(' + escapedKeyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
      return escapedText.replace(regex, '<mark>$1</mark>');
    }

    // 统计关键词在文本中出现的次数（不区分大小写）
    function countMatches(text, keyword) {
      var escapedKeyword = keyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      var regex = new RegExp(escapedKeyword, 'gi');
      var matches = text.match(regex);
      return matches ? matches.length : 0;
    }

    // 生成包含第一处匹配的摘要片段
    function makeSnippet(content, keyword, maxLength) {
      maxLength = maxLength || 80;
      var lowerContent = content.toLowerCase();
      var lowerKeyword = keyword.toLowerCase();
      var index = lowerContent.indexOf(lowerKeyword);
      if (index === -1) {
        // 如果关键词不在内容中，回退到显示开头一段
        return content.substring(0, maxLength);
      }

      var half = Math.floor(maxLength / 2);
      var start = Math.max(0, index - half);
      var end = Math.min(content.length, index + keyword.length + half);

      var snippet = content.substring(start, end);
      // 添加省略号表示截断
      if (start > 0) snippet = '…' + snippet;
      if (end < content.length) snippet = snippet + '…';

      return snippet;
    }

    // 搜索函数
    function performSearch(query) {
      resultsList.innerHTML = '';
      if (!query.trim()) return;

      var keyword = query.trim();
      var keywordLower = keyword.toLowerCase();
      var results = [];

      postsData.forEach(function(post) {
        var haystack = (post.title + ' ' + (post.excerpt || '') + ' ' + (post.content || '') + ' ' + (post.categories || []).join(' ')).toLowerCase();
        if (haystack.indexOf(keywordLower) !== -1) {
          results.push(post);
        }
      });

      if (results.length === 0) {
        resultsList.innerHTML = '<li class="no-results">没有找到相关文章，换个关键词试试</li>';
        return;
      }

      results.slice(0, 15).forEach(function(post) {
        var li = document.createElement('li');
        var highlightedTitle = highlight(post.title, keyword);

        // 生成摘要片段
        var snippetText = makeSnippet(post.content || post.excerpt || '', keyword, 120);
        var highlightedSnippet = highlight(snippetText, keyword);

        // 统计全文和标题中该关键词出现的总次数
        var totalMatches = countMatches(post.title, keyword) + countMatches(post.content || '', keyword);
        var remaining = totalMatches > 1 ? totalMatches - 1 : 0;

        var remainingHtml = remaining > 0 ? '<span class="more-count">余下 ' + remaining + ' 处</span>' : '';

        li.innerHTML = `
          <div class="result-title"><a href="${post.url}">${highlightedTitle}</a></div>
          <div class="result-meta">${post.date || ''} · ${post.categories ? post.categories.join(', ') : ''}</div>
          <div class="result-snippet">${highlightedSnippet} ${remainingHtml}</div>
        `;
        resultsList.appendChild(li);
      });
    }

    // 处理中文输入法组合事件
    var composing = false;
    input.addEventListener('compositionstart', function() {
      composing = true;
    });
    input.addEventListener('compositionend', function() {
      composing = false;
      performSearch(input.value);
    });
    input.addEventListener('input', function() {
      if (!composing) {
        performSearch(input.value);
      }
    });
  })();
</script>