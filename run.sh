set -xe

echo "Change basic setting from config.yaml"
docker run --rm -it -v "$PWD:/app" dcagatay/j2cli k8s/pv.yml config.yaml -o k8s/pv.yml
docker run --rm -it -v "$PWD:/app" dcagatay/j2cli k8s/pv.yml k8s/grafana.yml config.yaml -o k8s/grafana.yml
docker run --rm -it -v "$PWD:/app" dcagatay/j2cli k8s/pv.yml k8s/monitor.yml config.yaml -o k8s/monitor.yml

echo "start pv"
kubectl create -f pv.yml

echo "start monitor pod"
kubectl create -f apcupsd_exporter.yml -f blackbox.yml -f nvidia_exporter.yml -f snmp_default.yml -f snmp_hp.yml -f snmp_router.yml

echo "start grafana and promethus"
helm install lab-monitor --namespace monitor -f monitor.yml --version 9.3.1 stable/prometheus
helm install monitor-grafana --namespace monitor -f grafana.yml stable/grafana
# helm upgrade lab-monitor stable/grafana --namespace monitor -f monitor.yml
