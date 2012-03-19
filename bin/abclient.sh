#!/bin/bash

abook_url="http://ran/abook/"

# DO NOT CHANGE ANYTHING BEYOND THIS POINT

abapiurl="$abook_url?api=1"
catapiurl="$abook_url/categories.php?api=1"
plapiurl="$abook_url/play.php?api=1"
exapiurl="$abook_url/doexport.php?action=export"

confdir="$HOME/.abclient/"

if [ ! -d $confdir ] ; then
  mkdir $confdir
fi

case $1 in
  "ls")
    curl -s "$abapiurl" | while read line ; do echo "  $line" ; done
  ;;
  "search")
    search="$2"
    curl -s "$abapiurl&s=$search" | while read line ; do echo "  $line" ; done
  ;;
  "cat")
    categorie="$2"
    if [ "$3" == "search" ] ; then
      search="$4"
    fi
    curl -s "$abapiurl&s=$search&c=$categorie" | while read line ; do echo "  $line" ; done
  ;;
  "lscat")
    curl -s "$catapiurl" | while read line ; do echo "  $line" ; done
  ;;
  "searchcat")
    search="$2"
    curl -s "$catapiurl&s=$search" | while read line ; do echo "  $line" ; done
  ;;
  "play")
    touch $confdir/$2
    pos=`cat $confdir/$2`
    if [ "$pos" != "" ] ; then
      ec=0
    else
      ec=1
    fi
    IFS='
'
    for line in `curl -s "$plapiurl&filename=$2"` ; do
      if [ "$line" == "$pos" ] ; then
        ec=1
      fi
      if [ "$ec" == "1" ] ; then
        echo "$line" > $confdir/$2
        mplayer $abook_url$line
        if [ "$?" -gt "0" ] ; then
          exit
        fi
      fi
    done
  ;;
  "newplay")
    echo > $confdir/$2
    IFS='
'
    for line in `curl -s "$plapiurl&filename=$2"` ; do
      echo "$line" > $confdir/$2
      mplayer $abook_url$line
      if [ "$?" -gt "0" ] ; then
        exit
      fi
    done
  ;;
  "export")
    echo -n "Compressing $2 - please wait ... "
    bst=`curl -s "$exapiurl&filename=$2"`
    if [ "$bst" == "" ] ; then
      echo "DONE"
      getpath="exp/$2.tar"
      echo
      wget $abook_url$getpath
    else
      echo "FAILED"
      echo "$bst" | while read line ; do echo "  $line" ; done
    fi
  ;;
  *)
    # Usage
    echo "abclient FUNCTION"
    echo
    echo "Functions:"
    echo "    ls"
    echo "    search SEARCHTERM"
    echo "    lscat"
    echo "    searchcat SEARCHTERM"
    echo "    cat CATEGORIE"
    echo "    cat CATEGORIE search SEARCHTERM"
    echo "    play ABOOK"
    echo "    newplay ABOOK"
    echo "    export ABOOK"
  ;;
esac
