<?php

require_once 'defines.php';

class Categorielist {
  var $searchterm;
  var $list;

  function readall() {
    $this->searchterm = null;

    if ( is_dir(ABPATH.'/'.CATFOLDER) ) {

      // Create abook list from dirlist
      foreach ( scandir(ABPATH.'/'.CATFOLDER) as $name ) {
        if ($name == '.' or $name == '..')
          continue;
        $this->list[] = $name;
      }

      if ($this->list)
        return true;
      else
        return false;
    }
    else // When the folder is missing
      die('ERROR: There is no folder at '.ABPATH.'/'.CATFOLDER."\n");
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
      $result[] = array($name, str_replace('_', ' ', $name));
    }
    return $result;
  }

}

?>
