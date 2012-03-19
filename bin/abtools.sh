#!/bin/bash

# Don't change this
source /etc/abook/abookrc
export remote_hosts='/etc/abook/remotehosts'

# Get Path to this Script
scname=`basename $0`

pushd `dirname $0` > /dev/null
abooktools="`pwd`/$scname"
popd > /dev/null

my_pwd=`pwd`

if [ "$3" == "API" ] ; then
  abook_api="true"
fi

if [ "$abook_api" == "true" ] ; then
  ecn=""
else
  ecn="-n"
fi

# Sync Functions
function getabook {
  absync_remote_userhost="$2"
  absync_remote_port="$3"
  absync_remote_path="$4"
  rsync --partial-dir=.sync -rzve "ssh -p $absync_remote_port" --size-only \
  --progress --exclude ".*" $absync_remote_userhost:$absync_remote_path/$1/ ./$1/

  if [ "$?" != "0" ] ; then
    getabook $@
  fi
}

function sendabook {
  absync_remote_userhost="$2"
  absync_remote_port="$3"
  absync_remote_path="$4"
  rsync --partial-dir=.sync -rzve "ssh -p $absync_remote_port" --size-only \
  --progress --exclude ".*" ./$1/ $absync_remote_userhost:$absync_remote_path/$1/

  if [ "$?" != "0" ] ; then
    sendabook $@
  fi
}

function remotelist {
  absync_remote_userhost="$1"
  absync_remote_port="$2"
  ssh -p $absync_remote_port $absync_remote_userhost "abtools ls" | sed -e 's/^[ \t]*//'
}

function remotepath {
  absync_remote_userhost="$1"
  absync_remote_port="$2"
  ssh -p $absync_remote_port $absync_remote_userhost "abtools path" | sed -e 's/^[ \t]*//'
}

# Change to abook dir
cd $abook_dir

# Process short commands
case "$1" in
  pl) fnc=playlist ;;
  lg) fnc=logo ;;
  cl) fnc=cleanup ;;
  cw) fnc=chown ;;
  ls) fnc=list ;;
  rl) fnc=remotelist ;;
  rls) fnc=remotelist ;;
  df) fnc=diff ;;
  rd) fnc=remotediff ;;
  rdf) fnc=remotediff ;;
  rg) fnc=get ;;
  rs) fnc=send ;;
  im) fnc=import ;;
  ex) fnc='export' ;;
  *)  fnc=$1 ;;
esac

case "$fnc" in
  playlist)
    if [ "$2" != "" ] && [ -d "$2" ] ; then
      pushd "$2" > /dev/null
        echo $ecn "Generating Playlist for $2 ... "
        ls *.mp3 > playlist.m3u
        echo "OK"
      popd > /dev/null
    elif [ "$2" == "" ] ; then
      ls | while read line ; do
        pushd "$line" > /dev/null
          echo $ecn "Generating Playlist for $line ... "
          ls *.mp3 > playlist.m3u
          echo "OK"
        popd > /dev/null
      done
    else
      echo "$2 does not exist!"
    fi
  ;;
  logo)
    if [ "$2" != "" ] && [ -d "$2" ] ; then
      echo $ecn "Resizing Logo for $2 ... "
      convert -resize 150x150\! -interlace PLANE $2/logo.png $2/logo.png
      echo "OK"
    elif [ "$2" == "" ] ; then
      ls | while read line ; do
        echo $ecn "Resizing Logo for $line ... "
        convert -resize 150x150\! -interlace PLANE $line/logo.png $line/logo.png
        echo "OK"
      done
    else
      echo "$2 does not exist!"
    fi
  ;;
  id3)
    if [ "$2" != "" ] && [ -d "$2" ] ; then
      abook="$2"
      aname=`echo "$abook" | awk -v FS='.' '{print $1}' |\
             awk -v FS='_' -v ORS=' ' '{for(i=3;i<=NF;i++){ print $i } }'`
      aauth=`echo "$abook" | awk -v FS='.' '{print $1}' |\
             awk -v FS='_' '{ printf "%s %s", $1, $2 }'`
      #alng=`echo "$abook" | awk -v FS='.' '{print $2}'`
      ifi=1
      for afile in `cd $abook ; ls *mp3` ; do
        echo $ecn -e "\rSetting ID3-Tags for $abook ... $afile"
        atrack=`echo "$afile" | awk -F '.' '{print $1}'`
        id3v2 -D $abook/$afile > /dev/null
        id3v2 -A "$aname" -a "$aauth" -t "$afile" -T "$atrack" $abook/$afile > /dev/null
        let 'ifi=ifi+1'
      done
      echo -e "\rSetting ID3-Tags for $abook ... OK      "
    elif [ "$2" == "" ] ; then
      ls | while read abook ; do
        aname=`echo "$abook" | awk -v FS='.' '{print $1}' |\
               awk -v FS='_' -v ORS=' ' '{for(i=3;i<=NF;i++){ print $i } }'`
        aauth=`echo "$abook" | awk -v FS='.' '{print $1}' |\
               awk -v FS='_' '{ printf "%s %s", $1, $2 }'`
        #alng=`echo "$abook" | awk -v FS='.' '{print $2}'`
        for afile in `cd $abook ; ls *mp3` ; do
          echo $ecn -e "\rSetting ID3-Tags for $abook ... $afile"
          atrack=`echo "$afile" | awk -F '.' '{print $1}'`
          id3v2 -D $abook/$afile > /dev/null
          id3v2 -A "$aname" -a "$aauth" -t "$afile" -T "$atrack" $abook/$afile > /dev/null
          let 'ifi=ifi+1'
        done
        echo -e "\rSetting ID3-Tags for $abook ... OK      "
      done
    else
      echo "$2 does not exist!"
    fi
  ;;
  chown)
    if [ "$2" != "" ] && [ -d "$2" ] ; then
      echo $ecn "Setting Owner for $2 ... "
      chown -R $abook_user:$abook_group "$2"
      echo "OK"
    elif [ "$2" == "" ] ; then
      echo $ecn "Setting Owner for all ... "
      chown -R $abook_user:$abook_group *
      echo "OK"
    else
      echo "$2 does not exist!"
    fi
  ;;
  list)
    ls | while read line ; do echo "  $line" ; done
  ;;
  remotelist)
    if [ "$2" != "" ] ; then
      # List specified host
      line=`grep "@$2:" $remote_hosts | head -n 1`
      absync_remote_userhost="`echo "$line" | awk -F ':' '{print $1}'`"
      absync_remote_port="`echo "$line" | awk -F ':' '{print $2}'`"
      absync_remote_host="`echo "$absync_remote_userhost" | awk -F '@' '{print $2}'`"
      echo "All audiobooks at $absync_remote_host:"
      remotelist $absync_remote_userhost $absync_remote_port |\
      while read item ; do echo "  $item" ; done
    else
      # List all
      IFS='
'
      for line in `cat $remote_hosts` ; do
        absync_remote_userhost="`echo "$line" | awk -F ':' '{print $1}'`"
        absync_remote_port="`echo "$line" | awk -F ':' '{print $2}'`"
        absync_remote_host="`echo "$absync_remote_userhost" | awk -F '@' '{print $2}'`"
        echo "All audiobooks at $absync_remote_host:"
        remotelist $absync_remote_userhost $absync_remote_port |\
        while read item ; do echo "  $item" ; done
        echo
      done
    fi
  ;;
  peers)
    IFS='
'
    for line in `cat $remote_hosts` ; do
      absync_remote_userhost="`echo "$line" | awk -F ':' '{print $1}'`"
      absync_remote_host="`echo "$absync_remote_userhost" | awk -F '@' '{print $2}'`"
      echo "  $absync_remote_host"
    done
  ;;
  diff)
    if [ "$2" != "" ] ; then
      parm="`ls | sed ':a;N;$!ba;s/\n/ -e /g'`"
      parm="-e $parm"
      # List specified host
      line=`grep "@$2:" $remote_hosts | head -n 1`
      absync_remote_userhost="`echo "$line" | awk -F ':' '{print $1}'`"
      absync_remote_port="`echo "$line" | awk -F ':' '{print $2}'`"
      absync_remote_host="`echo "$absync_remote_userhost" | awk -F '@' '{print $2}'`"
      echo "The following new audiobooks are available at $absync_remote_host:"
      echo "`remotelist $absync_remote_userhost $absync_remote_port | grep -v $parm |\
             while read item ; do echo "  $item" ; done`"
    fi
  ;;
  remotediff)
    if [ "$2" != "" ] ; then
      # List specified host
      line=`grep "@$2:" $remote_hosts | head -n 1`
      absync_remote_userhost="`echo "$line" | awk -F ':' '{print $1}'`"
      absync_remote_port="`echo "$line" | awk -F ':' '{print $2}'`"
      absync_remote_host="`echo "$absync_remote_userhost" | awk -F '@' '{print $2}'`"
      parm="`remotelist $absync_remote_userhost $absync_remote_port | sed ':a;N;$!ba;s/\n/ -e /g'`"
      parm="-e $parm"
      echo "The following audiobooks can be sent to $absync_remote_host:"
      echo "`ls | grep -v $parm |\
             while read item ; do echo "  $item" ; done`"
    fi
  ;;
  get)
    if [ "$2" != "" ] ; then
      if [ "$3" != "" ] ; then
        # Search at specified Host
        line=`grep "@$3:" $remote_hosts | head -n 1`
        absync_remote_userhost="`echo "$line" | awk -F ':' '{print $1}'`"
        absync_remote_port="`echo "$line" | awk -F ':' '{print $2}'`"
        absync_remote_host="`echo "$absync_remote_userhost" | awk -F '@' '{print $2}'`"
        echo $ecn "Searching for $2 at $absync_remote_host ... "
        if remotelist $absync_remote_userhost $absync_remote_port | grep -qi "$2" ; then
          echo "FOUND"
          notfound=false
        else
          echo "NOT FOUND"
          notfound=true
        fi
      else
        # Search at all Hosts
        IFS='
'
        for line in `cat $remote_hosts` ; do
          absync_remote_userhost="`echo "$line" | awk -F ':' '{print $1}'`"
          absync_remote_port="`echo "$line" | awk -F ':' '{print $2}'`"
          absync_remote_host="`echo "$absync_remote_userhost" | awk -F '@' '{print $2}'`"
          echo $ecn "Searching for $2 at $absync_remote_host ... "
          if remotelist $absync_remote_userhost $absync_remote_port | grep -qi "$2" ; then
            echo "FOUND"
            notfound=false
            break
          else
            echo "NOT FOUND"
            notfound=true
          fi
        done
      fi
      if [ "$notfound" == "true" ] ; then
        exit 1
      else
        trap "kill $$" SIGINT
        echo "Getting $2 from $absync_remote_host - Starting Sync"
        # Creating local directory
        mkdir -v $abook_dir/$2
        remote_path=`remotepath $absync_remote_userhost $absync_remote_port`
        getabook $2 $absync_remote_userhost $absync_remote_port $remote_path
        # 'Cleanup' Tasks
        $abooktools cleanup $2
      fi
    fi
  ;;
  send)
    if [ "$2" != "" ] ; then
      if  [ -d "$2" ] ; then
        IFS='
'
        for line in `cat $remote_hosts` ; do
          absync_remote_userhost="`echo "$line" | awk -F ':' '{print $1}'`"
          absync_remote_port="`echo "$line" | awk -F ':' '{print $2}'`"
          absync_remote_host="`echo "$absync_remote_userhost" | awk -F '@' '{print $2}'`"
          if [ "$3" != "" ] && [ "$3" != "$absync_remote_host" ] ; then
            continue
          fi
          trap "kill $$" SIGINT
          echo "Sending $2 to $absync_remote_host - Starting Sync"
          # Creating foreign directory
          remote_path=`remotepath $absync_remote_userhost $absync_remote_port`
          ssh -p $absync_remote_port $absync_remote_userhost "mkdir -v $remote_path/$2/"
          sendabook $2 $absync_remote_userhost $absync_remote_port $remote_path
        done
      else
        echo "$2 does not exist!"
      fi
    fi
  ;;
  cleanup)
    # 'Cleanup' Tasks
    $abooktools playlist $2
    $abooktools logo $2
    $abooktools id3 $2
    $abooktools chown $2
  ;;
  import)
    if [ "$2" != "" ] ; then
      filename=`basename $2`
      filepath=`dirname $2`
      filepath=`cd $my_pwd ; cd $filepath ; pwd`
      imfile="$filepath/$filename"
      exdir=`tar -tf $imfile | head -n 1 | tr -d '/'`
      usage=`du -sk $imfile | cut -f1`
      let 'cp=usage / 1000'
      tar -x --checkpoint=$cp --checkpoint-action="echo=." -f $imfile 2>&1 | while read i ; do
        let 'p = p+1'
        echo $ecn -e "\rUncompressing $2 ... $p%"
      done
      if [ "$abook_api" != "true" ] ; then
        echo -e "\rUncompressing $2 ... OK  "

        # 'Cleanup' Tasks
        $abooktools cleanup $exdir
      else
        echo "$exdir"
      fi
    fi
  ;;
  export)
    if [ "$2" != "" ] ; then
      usage=`du -sk $2 | cut -f1`
      let 'cp=usage / 1000'
      tar -c --checkpoint=$cp --checkpoint-action="echo=." -f $my_pwd/$2.tar $2 2>&1 | while read i ; do
        let 'p = p+1'
        echo $ecn -e "\rCompressing $2 ... $p%"
      done
      if [ "$abook_api" != "true" ] ; then
        echo -e "\rCompressing $2 ... OK  "
        echo "$2.tar created!"
      fi
    fi
  ;;
  path)
    echo "  $abook_dir"
  ;;
  *)
    # Usage
    echo "abtools FUNCTION"
    echo
    echo "Functions:"
    echo "    playlist [abook]"
    echo "    logo [abook]"
    echo "    id3 [abook]"
    echo "    chown [abook]"
    echo "    cleanup [abook]"
    echo "    list"
    echo "    remotelist [host]"
    echo "    diff host"
    echo "    remotediff host"
    echo "    peers"
    echo 
    echo "Syncing:"
    echo "    get abook [host]"
    echo "    send abook [host]"
    echo "    import abook.tar"
    echo "    export abook"
  ;;
esac
