#!/usr/bin/python3

import os
import re
import json

abooks = os.listdir('.')
abooks.remove(".stfolder")

for abook in abooks:
	author, title, lang = abook.split('.')
	author = author.replace('_', ' ').title()
	title = title.replace('_', ' ')

	series = []
	ms = re.match(r"([^0-9]+)([0-9]+) ([^0-9]+)", title)
	if ms:
		series.append(ms.group(1) + f"#{int(ms.group(2))}")
		title = ms.group(3)

	lang = lang.replace('de', 'German')
	lang = lang.replace('en', 'English')

	j = {"metadata": {
		"title": title,
		"authors": [author],
		"series": series,
		"language": lang
	}}
	json.dump(j, open(os.path.join(abook, "metadata.json"), "w"), indent=2)
