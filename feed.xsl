<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
<xsl:output method="html" encoding="utf-8" indent="yes"/>
<xsl:template match="/atom:feed">
  <html>
  <head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><xsl:value-of select="atom:title"/> (RSS)</title>
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; max-width: 720px; margin: 2rem auto; padding: 0 1rem; background: #fff; color: #333; }
      h1 { border-bottom: 2px solid #eee; padding-bottom: 0.3rem; }
      h1 a { color: inherit; text-decoration: none; }
      h1 a:hover { text-decoration: underline; }
      .sub { color: #666; }
      .box { background: #fafafa; border-radius: 8px; padding: 1.5rem; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
      a { color: #0366d6; text-decoration: none; }
      a:hover { text-decoration: underline; }
      .article { margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 1px solid #eee; }
      .article:last-child { border-bottom: none; }
      .date { color: #888; font-size: 0.9rem; }
      code { background: #eee; padding: 0.2em 0.4em; border-radius: 3px; word-break: break-all; }
    </style>
  </head>
  <body>
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
          <div style="margin-top:0.3rem"><xsl:value-of select="atom:summary" disable-output-escaping="yes"/></div>
        </div>
      </xsl:for-each>

      <p style="margin-top:2rem; font-size:0.85rem; color:#999;">💡 不了解 RSS？<a href="https://aboutrss.com" target="_blank">点此了解如何订阅</a></p>

      <!-- 返回主页链接 -->
      <p class="back-home">
        <a href="{/atom:feed/atom:link[@rel='alternate']/@href}">← 返回主页</a>
      </p>
      
    </div>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>