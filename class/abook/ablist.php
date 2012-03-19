<?php

require_once 'defines.php';
require 'abook.php';

class Booklist {
  var $categorie;
  var $searchterm;
  var $list;

  function readall() {
    $this->categorie = null;
    $this->searchterm = null;

    if ( is_dir(ABPATH) ) {

      // Create abook list from dirlist
      foreach ( scandir(ABPATH) as $name ) {
        if ($name == '.' or $name == '..' or $name == CATFOLDER)
          continue;
        $this->list[] = $name;
      }

      if ($this->list)
        return true;
      else
        return false;
    }
    else // When the folder is missing
      die('ERROR: There is no folder at '.ABPATH."\n");
  }

  function readcat($categorie) {
    $this->categorie = $categorie;
    $this->searchterm = null;
    
    if ( file_exists(ABPATH.'/'.CATFOLDER.'/'.$this->categorie) ) {

      // Create abook list from categories file
      foreach ( file(ABPATH.'/'.CATFOLDER.'/'.$this->categorie, FILE_IGNORE_NEW_LINES) as $name )
        $this->list[] = $name;

      if ($this->list)
        return true;
      else
        return false;
    }
    else // When the categorie is missing
      die('There is no categorie called '.$this->categorie."\n");
  }

  function searchfilter($searchterm) {
    $this->searchterm = $searchterm;
    $searchterm = str_replace(' ', '_', $searchterm);

    if (!$this->list)
      return null;

    $result = null;
    foreach ($this->list as $name) {
      if ( strpos($name, $searchterm) === false )
        continue;
      $result[] = $name;
    }

    $this->list = $result;

    if ($this->list)
      return true;
    else
      return false;
  }

  function getparsedlist() {
    if (!$this->list)
      return null;
    $result = null;
    foreach ($this->list as $name) {
      $result[] = Audiobook::parsefilename($name);
    }
    return $result;
  }

}

?>
