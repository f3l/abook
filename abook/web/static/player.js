window.addEventListener("load", function() {
	console.log("load");
	var current = 0;
	var player = document.getElementById('player');
	var playlist = document.getElementById('playlist');

	var last_current = getCookie("PLAYTRACK_"+player.getAttribute('data-dirname'));
	if (last_current != "") {
		play(last_current, 1);
		player.currentTime = getCookie("PLAYPOS_"+player.getAttribute('data-dirname'));
	}

	player.addEventListener('play', function(e) {
		if ('mediaSession' in navigator) {
			navigator.mediaSession.metadata = new MediaMetadata({
				title: getPlaylistTracks()[current],
				artist: player.getAttribute('data-artist'),
				album: player.getAttribute('data-album'),
				artwork: [{ src: player.getAttribute('data-baseurl') + 'logo.png', sizes: '150x150', type: 'image/png' }]
			});
		}
		setCookie("PLAYTRACK_"+player.getAttribute('data-dirname'), current, 365);
		setCookie("PLAYPOS_"+player.getAttribute('data-dirname'), player.currentTime, 365);
	});

	player.addEventListener('pause', function(e) {
		setCookie("PLAYPOS_"+player.getAttribute('data-dirname'), player.currentTime, 365);
	});

	player.addEventListener('timeupdate', function(e) {
		setCookie("PLAYPOS_"+player.getAttribute('data-dirname'), player.currentTime, 365);
	});

	player.addEventListener('ended', function(e) {
		play(current + 1);
	});

	playlist.addEventListener('change', function(e) {
		play(playlist.value);
	});

	document.getElementById('prev_track').addEventListener('click', function(e) {
		play(current - 1);
	});

	document.getElementById('next_track').addEventListener('click', function(e) {
		play(current + 1);
	});

	if ('mediaSession' in navigator) {
		navigator.mediaSession.setActionHandler('seekbackward', function() {
			player.currentTime -= 10;
		});

		navigator.mediaSession.setActionHandler('seekforward', function() {
			player.currentTime += 10;
		});

		/*
		--> Prevent user from clicking wrong button
		navigator.mediaSession.setActionHandler('previoustrack', function() {
			play(current - 1);
		});

		navigator.mediaSession.setActionHandler('nexttrack', function() {
			play(current + 1);
		});
		*/
	}

	function play(index, pause) {
		index = Number(index);
		console.log("play("+index+")");
		if (index >= 0 && index < getPlaylistTracks().length) {
			current = Number(index);
			playlist.value = current;
			player.src = player.getAttribute('data-baseurl') + getPlaylistTracks()[current];
			if (!pause) {
				player.load();
				player.play();
			}
		}
	}

	function getPlaylistTracks() {
		return Array.apply(null, playlist.options).map(function(el) { return el.label; });
	}

	function setCookie(cname, cvalue, exdays) {
		var d = new Date();
		d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
		var expires = "expires="+d.toUTCString();
		document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
	}

	function getCookie(cname) {
		var name = cname + "=";
		var ca = document.cookie.split(';');
		for(var i = 0; i < ca.length; i++) {
			var c = ca[i];
			while (c.charAt(0) == ' ') {
				c = c.substring(1);
			}
			if (c.indexOf(name) == 0) {
				return c.substring(name.length, c.length);
			}
		}
		return "";
	}
}); 

