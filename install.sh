#!/bin/bash

mkdir -vp /usr/share/abook
cp -rv abook/web/static /usr/share/abook
cp -rv abook/web/templates /usr/share/abook

python3 setup.py install
