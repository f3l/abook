#!/bin/bash

if [ "$1" == "" ] ; then
  echo "Usage: $0 <cdrom-dev>"
  exit 1
else
  cddrive=$1
fi

read -p "Name of Audiobook: " name

for i in {10..99} ; do
  abcde -N -o mp3 -p -n -W $i -d $cddrive || break
  eject $cddrive
  echo
  let "cdnum=i-9"
  echo "CD #$cdnum DONE!"
  beep
  read -p "Insert next CD and press ENTER..."
  eject -t $cddrive
done

# rename folder
echo "Setting Foldername to $name"
mv Unknown_Artist-Unknown_Album $name || exit 1

pushd $name > /dev/null
echo "Setting the Titlenames"
e=1
IFS='
'
for line in `ls` ; do
  number=`printf "%.3i\n" $e`
  mv -v $line $number.mp3
  let "e=e+1"
done
echo "Removing the Junk mp3-tags"
IFS='
'
for line in `ls` ; do
  id3v2 -D $line
done
popd > /dev/null
