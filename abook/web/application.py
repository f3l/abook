#!/usr/bin/python3

import os
import sys
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__) + '/' + '../..'))

from abook import AbookSystem, Audiobook
from flask import Flask, render_template, request, config
from collections import OrderedDict


a = AbookSystem()

app = Flask(__name__)
app.config['AUDIOBOOKS_PATH'] = a.config['web']['audiobooks_path']


@app.route('/')
def list():
	abooks = a.list_audiobooks()
	if 'a' in request.args:
		abooks = filter(lambda ab: ab.author == request.args['a'], abooks)
	if 'l' in request.args:
		abooks = filter(lambda ab: ab.language == request.args['l'], abooks)
	if 's' in request.args:
		abooks = filter(lambda ab: request.args['s'].lower() in ab.dirname.lower().replace('_', ' ').replace('.', ' '), abooks)
	if 'a' in request.args or 'l' in request.args or 's' in request.args:
		return render_template("search.html", abooks=abooks)
	return render_template("list.html", abooks=abooks)

@app.route('/authors')
def authors():
	authors = OrderedDict()
	for abook in a.list_audiobooks():
		authors[abook.author] = authors.get(abook.author, 0) + 1
	return render_template("authors.html", authors=authors)

@app.route('/languages')
def languages():
	languages = {}
	for abook in a.list_audiobooks():
		languages[abook.language] = languages.get(abook.language, 0) + 1
	return render_template("languages.html", languages=languages)

@app.route('/abook/<audiobook>')
def abook(audiobook):
	tracks = [s.strip() for s in open(a.abfile(audiobook, 'playlist.m3u')).readlines()]
	return render_template("abook.html", abook=Audiobook(audiobook), playlist=tracks)


def external_url_handler(error, endpoint, values):
	"Looks up an external URL when `url_for` cannot build a URL."
	# This is an example of hooking the build_error_handler.
	# Here, lookup_url is some utility function you've built
	# which looks up the endpoint in some external URL registry.
	#url = lookup_url(endpoint, **values)
	if endpoint == 'audiobooks':
		url = app.config['AUDIOBOOKS_PATH'] + '%(audiobook)s/%(file)s' % values
	if url is None:
		# External lookup did not have a URL.
		# Re-raise the BuildError, in context of original traceback.
		exc_type, exc_value, tb = sys.exc_info()
		if exc_value is error:
			raise exc_type(exc_value).with_traceback(tb)
		else:
			raise error
	# url_for will use this result, instead of raising BuildError.
	return url

app.url_build_error_handlers.append(external_url_handler)


if __name__ == '__main__':
	app.run(host='0.0.0.0', debug=True)
else:
	app.template_folder = "/usr/share/abook/templates"
	app.static_folder = "/usr/share/abook/static"
