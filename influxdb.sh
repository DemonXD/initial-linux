#!/bin/bash

source ./.customshell.sh

trap _clean INT QUIT TERM EXIT

sudo curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -

sudo echo "deb https://repos.influxdata.com/ubuntu bionic stable" | \
    sudo tee /etc/apt/sources.list.d/influxdb.list

sudo apt-get update

sudo apt-get install -y influxdb

sudo systemctl enable influxdb

# enable http
sudo sed -ir '/# Determines whether HTTP endpoint is enabled/{ n; s/# //g }' /etc/influxdb/influxdb.conf

# restart influxdb
sudo systemctl stop influxdb && sudo systemctl start influxdb

# set admin account
curl -XPOST "http://localhost:8086/query" --data-urlencode "q=CREATE USER admin WITH PASSWORD 'pass@dba' WITH ALL PRIVILEGES"

_clean() {
    if [ -f "/etc/apt/sources.list.d/influxdb.list" ];then
        sudo rm /etc/apt/sources.list.d/influxdb.list
    fi
}