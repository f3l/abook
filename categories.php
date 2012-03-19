<?php

require 'class/abook/catlist.php';
require 'class/smarty/Smarty.class.php';

$smarty = new Smarty;
$smarty->template_dir = './templates';
$smarty->compile_dir  = './templates/compiled';

$catlist = new Categorielist();

if ( isset($_GET['resetsearch']) )
  unset($_GET['s']);

$catlist->readall();

if (@$_GET['s'])
  $catlist->searchfilter($_GET['s']);

// Assign variebles
$smarty->assign('searchterm', $catlist->searchterm);
$smarty->assign('catlist', $catlist->getparsedlist());
$smarty->assign('api', @$_GET['api']);

$smarty->assign('action', 'Categories');

// Assign constants
$smarty->assign('ABPATH', ABPATH);
$smarty->assign('PLAYLIST', PLAYLIST);
$smarty->assign('CATFOLDER', CATFOLDER);
$smarty->assign('LOGO', LOGO);

$smarty->display('categories.tpl');

?>
