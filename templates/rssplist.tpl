<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
  <channel>
    <title>{$plabook[2]}</title>
    <link>{$url}play.php?filename={$plabook[0]}</link>
    <language>{$plabook[3]}</language>
    <generator>Abook System</generator>
    <image>
      <url>{$url}{$ABPATH}/{$plabook[0]}/{$LOGO}</url>
      <title>{$plabook[2]}</title>
      <link>{$url}play.php?filename={$plabook[0]}</link>
    </image>
    {foreach key=id item=file from=$playlist}
      <item>
        <title>{$id+1}</title>
        <link>{$url}{$file}</link>
        <enclosure url="{$url}{$file}" type="audio/mpeg"/>
        <guid isPermaLink="true">{$url}{$file}</guid>
      </item>
    {/foreach}
  </channel>
</rss>
