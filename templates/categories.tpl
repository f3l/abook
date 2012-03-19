{if isset($api) }
{php}header('Content-Type: text/plain');{/php}
{include file='apiclist.tpl'}
{else}
{include file='header.tpl'}
{include file='searchform.tpl'}
{include file='clist.tpl'}
{include file='footer.tpl'}
{/if}
