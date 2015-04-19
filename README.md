#Monitoring

##Stack

* [CentOS](http://www.centos.org/)
* [Grafana](http://grafana.org/)
* [Influxdb](http://influxdb.com/)
* [Statsd](https://github.com/etsy/statsd/)
* [Nginx](http://nginx.org/)
* [Vagrant](https://www.vagrantup.com/)
* [Docker](https://www.docker.com/)

##Information

* [Grafana](http://localhost:8080/grafana)
* [Influxdb](http://localhost:8083)


###Command to send a metric
```sh
echo "local.grafana.devil 666 `date +%s`" | nc 127.0.0.1 2003
```

