mkdir grafana_data
chown 472:472 grafana_data
mkdir prometheus_data
chown 65534:65534 prometheus_data
docker build -t linnil1/apcupsd_exporter -f apcupsd_docker . 
