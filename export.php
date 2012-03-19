<?php

require 'class/abook/abook.php';
require 'class/smarty/Smarty.class.php';

$smarty = new Smarty;
$smarty->template_dir = './templates';
$smarty->compile_dir  = './templates/compiled';

$abook = new Audiobook($_GET['filename']);

// Assign variebles
$smarty->assign('exportfile', $abook->filename);

$smarty->assign('action', 'Exporting');

// Assign constants
$smarty->assign('ABPATH', ABPATH);
$smarty->assign('PLAYLIST', PLAYLIST);
$smarty->assign('CATFOLDER', CATFOLDER);
$smarty->assign('LOGO', LOGO);

$smarty->display('export.tpl');

?>
