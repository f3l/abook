<span id="sbox">
  <form method="get" action="{$smarty.server.SCRIPT_NAME}" id="searchform">
    <input type="text" name="s" id="s" value="{$searchterm}" />
    {if isset($categorie) }
      <input type="hidden" name="c" id="c" value="{$categorie}" />
    {/if}
    {if isset($export) }
      <input type="hidden" name="e" id="e" value="{$export}" />
    {/if}
    <input type="submit" value="&#9166;" style="display: none;" />
    {if isset($searchterm) }
      <input type="submit" name="resetsearch" value="&#9747;" onclick="resetSearchForm();" />
    {/if}
  </form>
</span>
