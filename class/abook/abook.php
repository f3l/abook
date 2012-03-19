<?php

require_once 'defines.php';

class Audiobook {
  var $filename;
  var $author;
  var $title;
  var $lang;

  static function parsefilename($filename) {
    // Get informations about string
    $folder = str_replace('_', ' ', $filename );
    $pos_ln = strrpos($folder, '.');
    $pos_an = strpos( $folder, ' ', strpos($folder, ' ') + 1 );
    $len_fl = strlen($folder);

    // Parse String
    $author = substr( $folder, 0, $pos_an );
    $title = substr( $folder, $pos_an + 1, ($len_fl - $pos_ln) * -1 );
    $lang = substr( $folder, $pos_ln + 1 );
    
    return array($filename, $author, $title, $lang);
  }

  static function doexport($filename) {
    if ( is_dir(ABPATH.'/'.$filename) )
      exec('cd exp ; abook_api="true" abtools export '.$filename);
    else
      die('There is no audiobook called '.$filename."\n");
  }

  function getplaylist() {
    // Check if files are ok
    if ( is_dir(ABPATH.'/'.$this->filename) and file_exists(ABPATH.'/'.$this->filename.'/'.PLAYLIST) ) {
      // Convert Playlist
      $playlist = file_get_contents(ABPATH.'/'.$this->filename.'/'.PLAYLIST);
      $pos_pl = strrpos($playlist, "\n");
      $len_pl = strlen($playlist);
      $playlist = substr( $playlist, 0, ($len_pl - $pos_pl) * -1 );

      $playlist = str_replace("\n", '|'.ABPATH.'/'.$this->filename.'/', $playlist);
      $playlist = ABPATH.'/'.$this->filename.'/'.$playlist;
      return $playlist;
    }
    else
      return null;
  }

  function getplaylist_r() {
    return explode('|', $this->getplaylist());
  }

  function Audiobook($filename) {
    list($this->filename, $this->author, $this->title, $this->lang) = $this->plabook = $this->parsefilename($filename);
  }
}

?>
