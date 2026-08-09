<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
<xsl:output method="html" doctype-system="about:legacy-compat"/>
<xsl:template match="/rss/channel">
  <html>
  <head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><xsl:value-of select="title"/> (RSS)</title>
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; max-width: 700px; margin: 2rem auto; padding: 0 1rem; background: #fafafa; color: #333; }
      h1 { border-bottom: 2px solid #ccc; padding-bottom: 0.3rem; }
      .sub { color: #666; margin-top: -1rem; }
      .box { background: white; border-radius: 8px; padding: 1.5rem; box-shadow: 0 1px 4px rgba(0,0,0,0.1); }
      a { color: #0366d6; text-decoration: none; }
      a:hover { text-decoration: underline; }
      .article { margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 1px solid #eee; }
      .article:last-child { border-bottom: none; }
      .date { color: #888; font-size: 0.9rem; }
    </style>
  </head>
  <body>
    <div class="box">
      <h1>📡 <xsl:value-of select="title"/></h1>
      <p class="sub"><xsl:value-of select="description"/></p>
      <p>这是一个 <strong>RSS 订阅源</strong>。将下面的链接复制到你的 RSS 阅读器中，即可接收更新提醒：</p>
      <p style="background: #f0f0f0; padding: 0.5rem; border-radius: 4px; word-break: break-all;">
        <code><xsl:value-of select="atom:link/@href"/></code>
      </p>

      <h2>📝 最近文章</h2>
      <xsl:for-each select="item[position() &lt;= 10]">
        <div class="article">
          <a href="{link}"><strong><xsl:value-of select="title"/></strong></a>
          <div class="date"><xsl:value-of select="pubDate"/></div>
          <div style="margin-top:0.3rem"><xsl:value-of select="description" disable-output-escaping="yes"/></div>
        </div>
      </xsl:for-each>

      <p style="margin-top:2rem; font-size:0.85rem; color:#999;">
        💡 不了解 RSS？<a href="https://aboutrss.com" target="_blank">点此了解如何订阅</a>
      </p>
    </div>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>