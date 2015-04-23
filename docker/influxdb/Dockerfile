FROM centos:latest

MAINTAINER Stéphane Jeandeaux <stephane.jeandeaux@gmail.com>

RUN curl https://s3.amazonaws.com/influxdb/influxdb-latest-1.x86_64.rpm -o /tmp/influxdb-latest-1.x86_64.rpm
RUN rpm -ivh /tmp/influxdb-latest-1.x86_64.rpm

# configuration
EXPOSE 8083 8086

#DATA for influxdb
#overwrite if you change configuration
VOLUME /influxdb/data 
VOLUME /influxdb/overwrite

COPY influxdb.sh /influxdb/influxdb.sh
RUN chmod +x /influxdb/influxdb.sh

COPY influxdb.toml /influxdb/influxdb.toml
ENV CONFIG /influxdb/influxdb.toml

CMD ["/influxdb/influxdb.sh"]
