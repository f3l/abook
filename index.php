<?php

require 'class/abook/ablist.php';
require 'class/smarty/Smarty.class.php';

$smarty = new Smarty;
$smarty->template_dir = './templates';
$smarty->compile_dir  = './templates/compiled';

$ablist = new Booklist();

if ( isset($_GET['resetsearch']) )
  unset($_GET['s']);

if (@$_GET['c']) {
  $ablist->readcat($_GET['c']);
  $lsw = 'Categorie';
}
else {
  $ablist->readall();
  $lsw = 'All';
}

if (@$_GET['s']) {
  $ablist->searchfilter($_GET['s']);
  $ls = 'Search';
}
else
  $ls = 'List';

if (@$_GET['e'] == 1)
  $smarty->assign('export', 1);

// Assign variebles
$smarty->assign('searchterm', $ablist->searchterm);
$smarty->assign('categorie', $ablist->categorie);
$smarty->assign('categorie_name', str_replace('_', ' ', $ablist->categorie));
$smarty->assign('ablist', $ablist->getparsedlist());
$smarty->assign('api', @$_GET['api']);

$smarty->assign('action', $ls.' '.$lsw);

// Assign constants
$smarty->assign('ABPATH', ABPATH);
$smarty->assign('PLAYLIST', PLAYLIST);
$smarty->assign('CATFOLDER', CATFOLDER);
$smarty->assign('LOGO', LOGO);

$smarty->display('index.tpl');

?>
