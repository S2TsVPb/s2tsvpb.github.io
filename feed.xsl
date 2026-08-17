<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
<xsl:output method="html" encoding="utf-8" indent="yes"/>
<xsl:template match="/atom:feed">
  <html lang="zh-CN">
  <head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><xsl:value-of select="atom:title"/> (RSS)</title>
    <link rel="icon" type="image/jpeg" href="/assets/favicon.jpeg"/>
    <style>
      :root {
        --bg: #ffffff;
        --text: #333333;
        --link: #0366d6;
        --border: #e5e5e5;
        --muted: #666666;
        --box-bg: #fafafa;
        --code-bg: #f0f0f0;
      }
      html[data-theme="dark"] {
        --bg: #1a1a1a;
        --text: #e0e0e0;
        --link: #66b3ff;
        --border: #333333;
        --muted: #9a9a9a;
        --box-bg: #242424;
        --code-bg: #2d2d2d;
      }
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; max-width: 720px; margin: 2rem auto; padding: 0 1rem; background: var(--bg); color: var(--text); transition: background-color 0.3s, color 0.3s; }
      h1 { border-bottom: 2px solid var(--border); padding-bottom: 0.3rem; }
      h1 a { color: inherit; text-decoration: none; }
      h1 a:hover { text-decoration: underline; }
      .sub { color: var(--muted); }
      .box { background: var(--box-bg); border: 1px solid var(--border); border-radius: 8px; padding: 1.5rem; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
      a { color: var(--link); text-decoration: none; }
      a:hover { text-decoration: underline; }
      .article { margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 1px solid var(--border); }
      .article:last-child { border-bottom: none; }
      .date { color: var(--muted); font-size: 0.9rem; }
      code { background: var(--code-bg); padding: 0.2em 0.4em; border-radius: 3px; word-break: break-all; }
      .snippet { margin-top: 0.3rem; line-height: 1.6; }
      #theme-toggle {
        position: fixed; bottom: 20px; right: 20px; z-index: 1000;
        background: var(--link); color: #fff; border: none; border-radius: 50%;
        width: 45px; height: 45px; font-size: 20px; cursor: pointer;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2); transition: transform 0.2s;
      }
      #theme-toggle:hover { transform: scale(1.1); }
    </style>
  </head>
  <body>
    <button id="theme-toggle" aria-label="切换深色模式">🌙</button>
    <div class="box">
      <!-- 标题变成可点击，直接返回主页 -->
      <h1>
        <a href="{/atom:feed/atom:link[@rel='alternate']/@href}">📡 <xsl:value-of select="atom:title"/></a>
      </h1>
      <p class="sub"><xsl:value-of select="atom:subtitle"/></p>

      <p>这是一个 <strong>RSS 订阅源</strong>。将下方链接复制到你的 RSS 阅读器中，即可接收更新提醒：</p>
      <p><code><xsl:value-of select="atom:link[@rel='self']/@href"/></code></p>

      <h2>📝 最近文章</h2>
      <xsl:for-each select="atom:entry[position() &lt;= 10]">
        <div class="article">
          <a href="{atom:link[@rel='alternate']/@href}"><strong><xsl:value-of select="atom:title"/></strong></a>
          <div class="date"><xsl:value-of select="atom:updated"/></div>
          <div class="snippet"><xsl:value-of select="atom:summary"/></div>
        </div>
      </xsl:for-each>

      <p style="margin-top:2rem; font-size:0.85rem; color:var(--muted);">💡 不了解 RSS？<a href="https://aboutrss.com" target="_blank">点此了解如何订阅</a></p>

      <!-- 返回主页链接 -->
      <p class="back-home">
        <a href="{/atom:feed/atom:link[@rel='alternate']/@href}">← 返回主页</a>
      </p>

    </div>
    <script><![CDATA[
      (function() {
        var toggle = document.getElementById('theme-toggle');
        var root = document.documentElement;
        function applyTheme(theme) {
          if (theme === 'dark') {
            root.setAttribute('data-theme', 'dark');
            toggle.textContent = '☀️';
          } else {
            root.removeAttribute('data-theme');
            toggle.textContent = '🌙';
          }
        }
        var stored = null;
        try { stored = localStorage.getItem('theme'); } catch (e) {}
        if (stored) {
          applyTheme(stored);
        } else {
          applyTheme(window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
        }
        toggle.addEventListener('click', function() {
          var current = root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
          var next = current === 'dark' ? 'light' : 'dark';
          try { localStorage.setItem('theme', next); } catch (e) {}
          applyTheme(next);
        });
      })();
    ]]></script>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
