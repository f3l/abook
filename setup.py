#!/usr/bin/python3

from distutils.core import setup

setup(
    name='abook',
    version='5.0.0',
    license='GPLv3',
    description='Tool to maintain audiobook database',
    author='Dominik Heidler',
    author_email='dominik@heidler.eu',
    requires=[],
    packages=['abook'],
    scripts=['bin/abtools'],
    data_files=[
        ('/etc', ['abook.cfg']),
        ('/usr/share/bash-completion/completions', ['completion/abtools']),
    ],
)
