docker pull prom/node-exporter
docker pull prom/prometheus
docker pull grafana/grafana
docker pull prom/snmp-exporter
mkdir grafana_data
chown 472:472 grafana_data
mkdir prometheus_data
chown 65534:65534 grafana_data
docker build -t linnil1/nvidia-smi nvidia_smi_exporter
docker build -t linnil1/apcupsd_exporter docker_apcupsd_exporter
