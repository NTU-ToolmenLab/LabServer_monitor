echo "start pv"
kubectl create -f pv.yml

echo "start monitor pod"
kubectl create -f apcupsd_exporter.yml -f blackbox.yml -f nvidia_exporter.yml -f snmp_default.yml -f snmp_hp.yml -f snmp_router.yml

echo "start grafana and promethus"
helm install lab-monitor --namespace monitor -f monitor.yml stable/prometheus
helm install monitor-grafana --namespace monitor -f grafana.yml stable/grafana
# helm upgrade lab-monitor -f monitor.yml
