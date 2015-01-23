#!/bin/bash

FOLDER_CONFIG=/tmp/monitoring/config

INFLUXDB_CONFIG=$FOLDER_CONFIG/influxdb.toml
GRAFANA_CONFIG=$FOLDER_CONFIG/grafana.js
GRAFANA_DASH=$FOLDER_CONFIG/dash.json

NGINX_CONFIG=$FOLDER_CONFIG/nginx_grafana
STATSD_CONFIG=$FOLDER_CONFIG/statsd.js



INFLUXDB_PKG=influxdb-latest-1.x86_64.rpm
INFLUXDB_URL=http://s3.amazonaws.com/influxdb/$INFLUXDB_PKG

GRAFANA_HOST=127.0.0.1
GRAFANA_PORT=8080
GRAFANA_VER=grafana-1.8.1
GRAFANA_PKG=$GRAFANA_VER.tar.gz
GRAFANA_URL=http://grafanarel.s3.amazonaws.com/$GRAFANA_PKG

HTTP_USER=user
HTTP_PASSWORD=changeit

sudo yum -y update
sudo yum history sync

###############################################################################################################################################
#                                                                                                                                             #
# Influxdb                                                                                                                                    #
#                                                                                                                                             #
###############################################################################################################################################


#install influxdb
#download
wget $INFLUXDB_URL 
sudo rpm -ivh $INFLUXDB_PKG
#copy configuration
sudo cp $INFLUXDB_CONFIG /opt/influxdb/shared/config.toml
sudo chown influxdb:influxdb /opt/influxdb/shared/config.toml

sudo mkdir /mnt/opt/influxdb/shared/data -p
sudo chown influxdb:influxdb /mnt/opt/influxdb -R

#start
sudo chkconfig --level 2345 influxdb on
sudo /etc/init.d/influxdb start

###############################################################################################################################################
#                                                                                                                                             #
# nginx                                                                                                                                       #
#                                                                                                                                             #
###############################################################################################################################################
#install grafana with nginx
wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
sudo rpm -ivh nginx-release-centos-6-0.el6.ngx.noarch.rpm
sudo yum -y install nginx

#htpasswd
sudo yum -y install httpd-tools
sudo htpasswd -dbc /etc/nginx/.htpasswd $HTTP_USER $HTTP_PASSWORD

#Installation configuration
sudo rm /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/example_ssl.conf
sudo sed -e "s|#GRAFANA_PORT#|$GRAFANA_PORT|g;s|#GRAFANA_HOST#|$GRAFANA_HOST|g" $NGINX_CONFIG -e  "w /etc/nginx/conf.d/grafana.conf"

sudo chkconfig --level 2345 nginx on
sudo chown nginx:nginx /etc/nginx/.htpasswd
sudo service nginx start


###############################################################################################################################################
#                                                                                                                                             #
# Grafana                                                                                                                                     #
#                                                                                                                                             #
###############################################################################################################################################
# Download the latest grafana version
wget $GRAFANA_URL
sudo tar xvfz $GRAFANA_PKG -C /usr/share

sudo mkdir -p /var/www/
sudo ln  -s /usr/share/$GRAFANA_VER -d /var/www/grafana
sudo sed -e "s|#SERVER_GRAFANA#|http://$GRAFANA_HOST:$GRAFANA_PORT|g" $GRAFANA_CONFIG -e  "w /var/www/grafana/config.js"
sudo cp $GRAFANA_DASH /var/www/grafana/app/dashboards/dash.json
sudo chown nginx:nginx /var/www/grafana/ -R



#SELinux
sudo yum -y install policycoreutils-python
sudo semanage port -a -t http_port_t -p tcp 8086


#Node JS
sudo yum -y groupinstall "Development Tools"
wget http://nodejs.org/dist/v0.10.33/node-v0.10.33-linux-x64.tar.gz
sudo tar zxf node-v0.10.33-linux-x64.tar.gz -C /usr/local/

#statd
wget https://github.com/etsy/statsd/archive/v0.7.2.tar.gz --no-check-certificate
sudo tar zxf v0.7.2.tar.gz -C /usr/local
sudo cp $STATSD_CONFIG /usr/local/statsd-0.7.2/config.js
/usr/local/node-v0.10.33-linux-x64/bin/node  /usr/local/statsd-0.7.2/stats.js  /usr/local/statsd-0.7.2/config.js &





#create graphite (user and db)
#create dashboard grafana (user and db)
#db graphite
curl -X POST "127.0.0.1:8086/db?u=root&p=root" --data '{"name": "graphite"}' --noproxy 127.0.0.1  -v 
curl -X POST "127.0.0.1:8086/db/graphite/users?u=root&p=root" --data '{"name": "graphite", "password": "graphite"}' --noproxy 127.0.0.1  -v 

#user grafana
curl -X POST "127.0.0.1:8086/db?u=root&p=root" --data '{"name": "grafana"}' --noproxy 127.0.0.1  -v 
curl -X POST "127.0.0.1:8086/db/grafana/users?u=root&p=root" --data '{"name": "grafana", "password": "grafana"}' --noproxy 127.0.0.1  -v 

# add cluster admin
curl -X POST '127.0.0.1:8086/cluster_admins/root?u=root&p=root' -d '{"password": "changeit"}' --noproxy 127.0.0.1  -v 

sudo yum -y install nc
echo "local.grafana.devil 666 `date +%s`" | nc 127.0.0.1 2003
