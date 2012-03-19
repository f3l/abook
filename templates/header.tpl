<html>
  <head>
    <title>Audio Books: {$action}</title>
    <link rel="icon" href="media/images/sp.png" type="image/png" />
    <link href="media/css/style.css" type="text/css" rel="stylesheet" />
    {if isset($exportfile) }
    <script src="media/js/prototype.js" type="text/javascript"></script>
    <script src="media/js/export.js" type="text/javascript"></script>
    {/if}
    {if isset($ablist) || isset($catlist) }
    <script src="media/js/searchform.js" type="text/javascript"></script>
    {/if}
    {if isset($plabook) }
    <link rel="alternate" type="application/rss+xml" title="RSS" href="{$url}play.php?filename={$plabook[0]}&rss=1" />
    {/if}
  </head>

  {if isset($exportfile)}
  <body onLoad="do_aj_req('{$exportfile}');">
  {else}
  <body>
  {/if}
    <div id="top-bar"> 
      <div id="topbar-inner">
        <a href="index.php">List All</a>&nbsp;&nbsp;
        <a href="categories.php">Categories</a>&nbsp;&nbsp;
        <a href="index.php?e=1">Export</a>
      </div>
    </div>
    <br />
    <center>
    <h2>Audio Books: {$action}</h2>
