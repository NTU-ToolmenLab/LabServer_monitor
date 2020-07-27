set -xe

echo "create folder"
mkdir -p prometheus_data
mkdir -p grafana_data
sudo chown 472:472 grafana_data
sudo chown 65534:65534 prometheus_data

echo "Build docker for apc exporter"
docker build -t linnil1/apcupsd_exporter -f apcupsd_docker .

echo "Push apc image to self-host registry"
docker tag linnil1/apcupsd_exporter harbor.default.svc.cluster.local/linnil1/apcupsd_exporter
docker push harbor.default.svc.cluster.local/linnil1/apcupsd_exporter

