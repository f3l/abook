The ABOOK-System
----------------

The File/Folder-Structure:
```
  audiobooks
  |~authorname_authorlastname.name_of_the_abook.lang
    |-001.mp3
    |-002.mp3
    |-.....
    |-logo.png
    `-playlist.m3u
```

* lang is the language (ISO 3166)
* the playlist.m3u contains a list of all mp3-files
  e.g. 001.mp3\n002.mp3 ...
* the logo.png is the icon and has to be 350x350px interlaced
* everything has to be written lowercase without spaces

# Lighttpd config
```
server.modules += ( "mod_scgi" )
scgi.protocol = "uwsgi"
scgi.server = ( 
  "/abook" => (( "host" => "127.0.0.1", "port" => 3031, "check-local" => "disable", "docroot" => "/abook/" )), 
)                                                                                                                                                              
server.modules += ( "mod_redirect" )
url.redirect = ( "^/abook$" => "/abook/" )
```
