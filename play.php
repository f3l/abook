<?php

require 'class/abook/abook.php';
require 'class/smarty/Smarty.class.php';

$smarty = new Smarty;
$smarty->template_dir = './templates';
$smarty->compile_dir  = './templates/compiled';

$abook = new Audiobook($_GET['filename']);

// Get URL
if (@$_GET['withauth'] and @$_SERVER['PHP_AUTH_USER'] and @$_SERVER['PHP_AUTH_PW'])
  $auth = $_SERVER['PHP_AUTH_USER'].':'.$_SERVER['PHP_AUTH_PW'].'@';
else
  $auth = '';

$protocol = (@$_SERVER['HTTPS']) ? 'https' : 'http';
$host = $_SERVER['HTTP_HOST'];
$port = $_SERVER['SERVER_PORT'];
$path = str_replace('play.php', '', $_SERVER['PHP_SELF']);
$url = $protocol.'://'.$auth.$host.':'.$port.$path;

// Assign variebles
$smarty->assign('plabook', $abook->plabook);
$smarty->assign('rss', @$_GET['rss']);
$smarty->assign('api', @$_GET['api']);
$smarty->assign('url', $url);

$smarty->assign('action', 'Playing');

if (@$_GET['rss'] or @$_GET['api'])
  $smarty->assign('playlist', $abook->getplaylist_r());
else
  $smarty->assign('playlist', $abook->getplaylist());

// Assign constants
$smarty->assign('ABPATH', ABPATH);
$smarty->assign('PLAYLIST', PLAYLIST);
$smarty->assign('CATFOLDER', CATFOLDER);
$smarty->assign('LOGO', LOGO);

$smarty->display('play.tpl');

?>
