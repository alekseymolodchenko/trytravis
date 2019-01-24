#!/bin/bash
set -e

database_address=$1
USER_HOME=$HOME

git clone -b monolith https://github.com/express42/reddit.git $USER_HOME/reddit
cd $USER_HOME/reddit
bundle install

echo "export DATABASE_URL=${database_address}" >> $USER_HOME/.bash_profile

sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
