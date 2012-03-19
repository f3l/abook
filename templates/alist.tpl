<table border="0">
{foreach key=id item=abook from=$ablist}
  {if $id is even}
    <tr>
  {/if}
    <td>
      <a href="play.php?filename={$abook[0]}"><img src="{$ABPATH}/{$abook[0]}/{$LOGO}" height="150px" width="150px" border="0" /></a>
    </td>
    <td width="280px">
      <a href="play.php?filename={$abook[0]}">{$abook[2]}</a>
      <br /><br />
      <em>{$abook[1]}</em> - {$abook[3]}
      <br /><br /><br />
    </td>
  {if $id is odd}
    </tr>
  {/if}
{/foreach}
</table>
