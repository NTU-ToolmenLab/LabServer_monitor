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

* change this password `- GF_SECURITY_ADMIN_PASSWORD=custom_password`
* change your domain name
* change traefik setting to what you want
* change your internal ip of apc 192.168.1.1

in `prometheus.yml`

change it if you use node-exporter on localhost
```
  - job_name: 'node-exporter'
    scrape_interval: 5s
    static_configs:
         - targets: ['your.internal.ip:9100']
```

If you cannot use apc, maybe you did't set 

`NETIP 0.0.0.0` in `/etc/apcupsd/apcupsd.conf`


## reference
* `grafana_myserver.json` is modified from
   https://grafana.com/dashboards/5573 and https://gist.github.com/mdlayher/962aecd2858454a822bb5ad847168cb0
* `docker-compose.yml` is modified from https://github.com/vegasbrianc/prometheus/blob/master/docker-compose.yml

## TODO
* Add alert manager

# LICENSE
MIT
