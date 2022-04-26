#!/bin/bash

source ./.customshell.sh

wget -qO- https://repos.influxdata.com/influxdb.key | sudo tee /etc/apt/trusted.gpg.d/influxdb.asc >/dev/null

echo "deb https://repos.influxdata.com/debian stable main" | sudo tee /etc/apt/sources.list.d/influxdb.list

sudo apt-get update && sudo apt-get install -y telegraf
sudo systemctl enable telegraf
sudo systemctl stop telegraf

influx <<EOF
CREATE USER telegraf WITH PASSWORD 'pass@dba'
CREATE DATABASE telegraf
exit
EOF

# monified telegraf.conf
sed -i '/\[\[outputs.influxdb\]\]/a \
  urls=["http://localhost:8086"]\
  database="telegraf"\
  retention_policy=""\
  precision="s"\
  timeout="5s"\
  username="telegraf"\
  password="pass\@dba"' /etc/telegraf/telegraf.conf

#
sudo systemctl start telegraf