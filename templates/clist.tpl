<table border="0">
{foreach key=id item=categorie from=$catlist}
  {if $id is even}
    <tr>
  {/if}
    <td>
      <a href="index.php?c={$categorie[0]}"><img src="media/images/folder.png" height="48px" width="48px" border="0" /></a>
    </td>
    <td width="170px">
      <a href="index.php?c={$categorie[0]}">{$categorie[1]}</a>
    </td>
  {if $id is odd}
    </tr>
  {/if}
{/foreach}
</table>
