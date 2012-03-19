{if isset($api) }
{php}header('Content-Type: text/plain');{/php}
{include file='apialist.tpl'}
{else}
{include file='header.tpl'}
{if isset($categorie) }
  <h3>{$categorie_name}</h3>
{elseif isset($export) }
  <h3>Export Audiobook</h3>
{/if}
{include file='searchform.tpl'}
{if isset($export) }
  {include file='elist.tpl'}
{else}
  {include file='alist.tpl'}
{/if}
{include file='footer.tpl'}
{/if}
