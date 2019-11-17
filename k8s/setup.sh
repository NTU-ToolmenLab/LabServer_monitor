NAS_IP='192.168.1.5'
NAS_PATH='/volume1/'
IP_SWITCH='192.168.1.2'
IP_ROUTER='192.168.1.1'
IP_NAS='192.168.1.5'
IP_HP_PRINTER='192.168.1.123'
DOMAIN_NAME='my.domain.ntu.edu.tw'
DOMAIN_PORT='443'
oauth_api='/oauth/profile'
oauth_auth='/oauth/authorize'
oauth_token='/oauth/token'
oauth_id=''
oauth_secret=''

echo "Change all variables"
sed -i "s~{{\s*NAS_IP\s*}}~$NAS_IP~g" pv.yml
sed -i "s~{{\s*NAS_PATH\s*}}~$NAS_PATH~g" pv.yml
sed -i "s~{{\s*IP_SWITCH\s*}}~$IP_SWITCH~g" monitor.yml
sed -i "s~{{\s*IP_ROUTER\s*}}~$IP_ROUTER~g" monitor.yml
sed -i "s~{{\s*IP_NAS\s*}}~$IP_NAS~g" monitor.yml
sed -i "s~{{\s*IP_HP_PRINTER\s*}}~$IP_HP_PRINTER~g" monitor.yml
sed -i "s/my.domain.ntu.edu.tw/$DOMAIN_NAME/g" monitor.yml grafana.yml
sed -i "s~{{\s*oauth_api\s*}}~$oauth_api~g" grafana.yml
sed -i "s~{{\s*oauth_auth\s*}}~$oauth_auth~g" grafana.yml
sed -i "s~{{\s*oauth_token\s*}}~$oauth_token~g" grafana.yml
sed -i "s~{{\s*oauth_id\s*}}~$oauth_id~g" grafana.yml
sed -i "s~{{\s*oauth_secret\s*}}~$oauth_secret~g" grafana.yml
sed -i "s/\:443/\:$DOMAIN_PORT/g" grafana.yml

# docker build
# where registry-svc is registry for docker
echo "Build docker file for apc"
docker build docker_apcupsd_exporter -t harbor.default.svc.cluster.local/linnil1/apcupsd_exporter
docker push harbor.default.svc.cluster.local/linnil1/apcupsd_exporter

echo "create folder"
mkdir ../prometheus_data
mddir ../grafana_data
sudo chown 472:472 ../grafana_data
