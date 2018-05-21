# Build monitor with docker-compose

Use 

* traefik
* grafana
* prometheus
* node-exporter
* nvidia-smi
* apcaccess

to monitor.

## Build this project
clone and run setup

```
git clone --recursive https://github.com/linnil1/LabServer_monitor.git
cd LabServer_monitor
bash setup.sh
```

## some custom data you need to set
in `docker-compose.yml`

change this password `- GF_SECURITY_ADMIN_PASSWORD=custom_password`

in `prometheus.yml`

change it if you use node-exporter on localhost
```
  - job_name: 'node-exporter'
    scrape_interval: 5s
    static_configs:
         - targets: ['your.ip:9100']
```

change it
```
  - job_name: 'apcupsd'
    scrape_interval: 5s
    static_configs:
         - targets: ['your.ip:9162']
```

## reference
* `grafana_myserver.json` is modified from
   https://grafana.com/dashboards/5573 and https://gist.github.com/mdlayher/962aecd2858454a822bb5ad847168cb0
* `docker-compose.yml` is modified from https://github.com/vegasbrianc/prometheus/blob/master/docker-compose.yml

## TODO
* Make apcupsd_exporter within mynet instead of host network.

# LICENSE
MIT
