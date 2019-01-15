#!/bin/bash

cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

mv -f /tmp/redditapp.service /etc/systemd/system/redditapp.service
systemctl daemon-reload
systemctl enable redditapp.service
systemctl start redditapp.service
