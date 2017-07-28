import configparser
import subprocess
import os


"""
Required commands:
- convert
- id3v2
- vorbiscomment
- chown
"""

class AbookSystem(object):
	def __init__(self, configfile="/etc/abook.cfg"):
		self.config = configparser.ConfigParser()
		self.config.read(configfile)
		self.dir = self.config['abook']['dir']
		self.user = self.config['abook']['user']
		self.group = self.config['abook']['group']

	def list_audiobooks(self):
		return map(Audiobook, sorted(next(os.walk(self.dir))[1]))

	def abook_resize_logo(self, audiobook):
		logo_png = self._abfile(audiobook, 'logo.png')
		subprocess.check_call(['convert', '-resize', '350x350!', '-interlace', 'PLANE', logo_png, logo_png])

	def abook_generate_playlist(self, audiobook):
		playlist_m3u = self._abfile(audiobook, 'playlist.m3u')
		is_media_file = lambda f: f.endswith('.mp3') or f.endswith('.mkv') or f.endswith('.ogg')
		with open(playlist_m3u, 'w') as playlist:
			playlist.write("\n".join(sorted(filter(is_media_file, os.listdir(self._abdir(audiobook))))))

	def abook_set_mediatags(self, audiobook, do_yield=False):
		playlist_m3u = self._abfile(audiobook, 'playlist.m3u')
		abook = audiobook if audiobook is Audiobook else Audiobook(audiobook)
		with open(playlist_m3u) as playlist:
			track = 1
			for mediafile in map(lambda s: s.strip(), playlist.readlines()):
				if do_yield:
					yield mediafile
				filepath = self._abfile(audiobook, mediafile)
				if mediafile.endswith('.mp3'):
					subprocess.check_call(['id3v2', '-D', filepath], stdout=subprocess.DEVNULL)
					subprocess.check_call([
						'id3v2',
						'-a', abook.author,
						'-A', abook.title,
						'-t', mediafile,
						'-T', str(track),
						filepath],
						stdout=subprocess.DEVNULL)
				elif mediafile.endswith('.ogg'):
					subprocess.check_call([
						'vorbiscomment', '-w',
						'-t', 'ARTIST=%s' % abook.author,
						'-t', 'ALBUM=%s' % abook.title,
						'-t', 'TITLE=%s' % mediafile,
						'-t', 'TRACKNUMBER=%i' % track,
						filepath])
				#elif mediafile.endswith('.mkv'):
				#TODO: implement mkv tag writing
				track += 1

	def abook_chown(self, audiobook):
		subprocess.check_call(['chown', '-R', '%s:%s' % (self.user, self.group), self._abdir(audiobook)])

	def _abdir(self, audiobook):
		if audiobook is Audiobook:
			dirname = audiobook.dirname
		else:
			dirname = audiobook
		return os.path.join(self.dir, dirname)

	def _abfile(self, audiobook, filename):
		return os.path.join(self._abdir(audiobook), filename)


class Audiobook(object):
	def __init__(self, dirname):
		self.dirname = dirname
		self._author = None
		self._title = None
		self._language = None

	def parse_dirname(self):
		ds = self.dirname.split('.')
		if len(ds) == 3:
			# format: author.title.language
			author, title, self._lang = ds
			self._author = author.replace('_', ' ')
			self._title = title.replace('_', ' ')
		elif len(ds) == 2:
			# format: author_name_title.language
			author_title, self._lang = ds
			self._author = ' '.join(author_title.split('_')[:2])
			self._title = ' '.join(author_title.split('_')[2:])
		else:
			raise Exception("Invalid audiobook dirname: '%s'" % self.dirname)

	def __str__(self):
		return self.dirname

	@property
	def author(self):
		if not self._author:
			self.parse_dirname()
		return self._author

	@property
	def title(self):
		if not self._title:
			self.parse_dirname()
		return self._title

	@property
	def language(self):
		if not self._language:
			self.parse_dirname()
		return self._language
