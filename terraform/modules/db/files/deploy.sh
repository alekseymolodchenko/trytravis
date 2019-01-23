#!/bin/bash

set -e

listen_address=$1

systemctl stop mongod

cat << EOF > /etc/mongod.conf
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true

systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

net:
  port: 27017
  bindIp: ${listen_address}
EOF

systemctl restart mongod
