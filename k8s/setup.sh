IP_SWITCH='192.168.1.1'
IP_ROUTER='192.168.1.2'
IP_NAS='192.168.1.3'
IP_HP_PRINTER='192.168.1.9'
NAS_MONITOR_PATH='/path'
home='\/home\/admin\/LabServer_monitor'

# replace word
echo "Change domain name and port and sql password"
sed -i "s/\$IP_SWITCH/$IP_SWITCH/g" monitor.yml
sed -i "s/\$IP_ROUTER/$IP_ROUTER/g" monitor.yml
sed -i "s/\$IP_NAS/$IP_NAS/g" monitor.yml pv*.yml
sed -i "s/\$IP_HP_PRINTER/$IP_HP_PRINTER/g" monitor.yml
sed -i "s/\$NAS_MONITOR_PATH/$NAS_MONITOR_PATH/g" pv.yml
sed -i "s/\~/$home/g" blackbox.yml hp_snmp.yml

# docker build
# where registry-svc is registry for docker
docker build nvidia_smi_exporter -t registry-svc.default.svc.cluster.local:5002/linnil1/nvidia_smi_exporter
docker push registry-svc.default.svc.cluster.local:5002/linnil1/nvidia_smi_exporter
docker build docker_apcupsd_exporter -t registry-svc.default.svc.cluster.local:5002/linnil1/apcupsd_exporter
docker push registry-svc.default.svc.cluster.local:5002/linnil1/apcupsd_exporter

echo "start monitor pod"
kubectl create -f apcupsd_exporter.yml -f blackbox.yml -f nvidia_smi_exporter.yml -f snmp_default.yml -f snmp_hp.yml -f snmp_router.yml

mkdir ../prometheus_data
mddir ../grafana_data
sudo chown 472:472 ../grafana_data

echo "start pv"
kubectl create -f pv_prometheus.yml
helm install --name lab-monitor --namespace monitor stable/prometheus --values=monitor.yml
kubectl create -f pv_grafana.yml
helm install --name monitor-grafana --namespace monitor stable/grafana --values=grafana.yml
