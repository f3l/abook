{if isset($rss) }
{php}header('Content-Type: application/rss+xml');{/php}
{include file='rssplist.tpl'}
{elseif isset($api) }
{php}header('Content-Type: text/plain');{/php}
{include file='apiplist.tpl'}
{else}
{include file='header.tpl'}
<h3>{$plabook[2]}</h3>
<img src="{$ABPATH}/{$plabook[0]}/{$LOGO}" height="150px" width="150px" border="0" />
<br /><br />
<em>{$plabook[1]}</em> - {$plabook[3]}
<br /><br />
{include file='player.tpl'}
<br /><br />
<a href="javascript:history.back();">&lt;&lt; BACK</a>
{include file='footer.tpl'}
{/if}
