FROM centos:latest

MAINTAINER Stéphane Jeandeaux <stephane.jeandeaux@gmail.com>

RUN curl https://s3.amazonaws.com/influxdb/influxdb-latest-1.x86_64.rpm -o /tmp/influxdb-latest-1.x86_64.rpm
RUN rpm -ivh /tmp/influxdb-latest-1.x86_64.rpm

# configuration
EXPOSE 8083 8086

#config.toml
VOLUME ["/influxdb/influxdb.toml", "/influxdb/data"]

CMD ["influxdb", "-config=/influxdb/influxdb.toml"]
