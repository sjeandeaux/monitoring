current_dir = $(shell pwd)

build:
	docker build -t sjeandeaux/influxdb .
clean-run:
	docker rm runInfluxdb
log:
	docker logs runInfluxdb
exec:
	docker exec -ti runInfluxdb /bin/bash
run:
	docker run -d --name runInfluxdb -p 8084:8083 -p 8086:8086  -v $(current_dir)/data:/influxdb/data  sjeandeaux/influxdb
run-overwrite:
	docker run -d --name runInfluxdb -p 8083:8083 -p 8086:8086  -e CONFIG=/influxdb/overwrite/influxdb.toml -v $(current_dir)/data:/influxdb/data -v $(current_dir)/overwrite:/influxdb/overwrite  sjeandeaux/influxdb
