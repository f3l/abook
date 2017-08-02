#!/bin/bash

mkdir -vp /usr/share/abook
cp -rv abook/web/static /usr/share/abook
cp -rv abook/web/templates /usr/share/abook

cp -v abook-web.service /etc/systemd/system/
systemctl daemon-reload

python3 setup.py install
