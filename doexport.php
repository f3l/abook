<?php

if (@$_GET['action'] != 'export' or !@$_GET['filename']) 
  die('Invalid request!'."\n");

require 'class/abook/abook.php';

Audiobook::doexport($_GET['filename']);

?>
