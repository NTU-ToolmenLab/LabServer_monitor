echo "start pv"
kubectl create -f pv.yml

echo "start monitor pod"
kubectl create -f apcupsd_exporter.yml -f blackbox.yml -f nvidia_exporter.yml -f snmp_default.yml -f snmp_hp.yml -f snmp_router.yml

echo "start grafana and promethus"
helm install --name lab-monitor --namespace monitor stable/prometheus --values=monitor.yml
helm install --name monitor-grafana --namespace monitor stable/grafana --values=grafana.yml
