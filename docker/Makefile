current_dir = $(shell pwd)

build:
	docker build -t monitoring/influxdb .

run:
	docker run -d --name runInfluxdb -p 8083:8083 -p 8086:8086 -v $(current_dir)/influxdb/data:/influxdb/data -v $(current_dir)/influxdb/influxdb.toml:/influxdb/influxdb.toml monitoring/influxdb
