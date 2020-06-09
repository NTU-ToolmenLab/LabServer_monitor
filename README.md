# Build monitor for Lab

Use 

* Grafana
* prometheus
* node-exporter
* nvidia_exporter
* apcupsd
* snmp-exporter
* Use Granfana Alerting on Telegram
* blackbox-exporter
* kubernetes-node (k8s)
* kubernetes-metrics (k8s)
* kubernetes-services (k8s)

work with
* docker-compose(Maybe)
* kubernetes
* traefik
* My own LabServer
  see https://github.com/NTU-ToolmenLab/labbox
  Used its OAuth2 to login.

to monitor

* server
* traefik
* gpu
* apc
* nas
* switch
* router
* hp printer
* ping, dns


## Download this project
```
git clone https://github.com/NTU-ToolmenLab/LabServer_monitor
cd LabServer_monitor
```

## Run with docker-compose
in `docker-compose.yml`
* change this password `- GF_SECURITY_ADMIN_PASSWORD=custom_password`
* change your domain name
* change traefik setting to what you want
* change your internal ip of apc 192.168.1.1

and finally,
```
bash setup.sh
```

*Now, I do not have time to maintain docker-compose*

*Please use kubernetes*


## Run with kubernetes
You should modify `k8s/setup.sh`, the header of file defined lots of variables you need to set.

Then, setup and run it.
```
cd k8s
bash setup.sh
bash run.sh
```

## some custom data you need to set

### node-exporter on localhost
I use `node-exporter` on host, so firewall should not block port 9100.


### APC setup
If you cannot access apc data, maybe you did't set 

`NETIP 0.0.0.0` in `/etc/apcupsd/apcupsd.conf`

or blocked by your firewall(port=3551).


### Monitor NAS
To monitor Synology NAS,

you should set up SNMP on NAS https://www.synology.com/en-uk/knowledgebase/DSM/help/DSM/AdminCenter/system_snmp.

And if you don't want to use [generator](https://github.com/prometheus/snmp_exporter/tree/master/generator) to build your own snmp configuration,

you should enable `SNMPv2c` service with default Communitunity Name = `public`.

Reference 
* https://global.download.synology.com/download/Document/MIBGuide/Synology_DiskStation_MIB_Guide.pdf


### Grafana
After start grafana,
set your databse url = `http://lab-monitor-prometheus-server.monitor.svc.cluster.local`,
and import dashboard by json file,
* `board/grafana_myserver.json`
* `board/grafana_myserver_alert.json`  This has Alerting rules and alert on Telegram

Install some plugin:
* piechart https://grafana.com/plugins/grafana-piechart-panel.

Reference
* Modified from
   https://grafana.com/dashboards/5573 and https://gist.github.com/mdlayher/962aecd2858454a822bb5ad847168cb0
* `docker-compose.yml` is modified from https://github.com/vegasbrianc/prometheus/blob/master/docker-compose.yml


### Grafana Alerting by Telegram
Goto alerting -> alerting channel
and create type = telegram

`BOT API Token` is got from BotFather.

You can use tutorial of python bot listening to your group you created,
then, collect `Chat ID` by someone send message.

For me, I need to disable private mode (Disable it by BotFather).

However, grafana alerting cannot work when data have variables(Grafana very big bug).


### Oauth Login
The oauth server configuration should look like:
```
client_id = ""
client_secret = ""
client_name = "grafana"
client_uri = "https://my.domain.ntu.edu.tw:443/monitor/"
grant_types = ["authorization_code"]
redirect_uris = ["https://my.domain.ntu.edu.tw:443/monitor/login/generic_oauth"]
response_types = ["code"]
scope = "profile"
token_endpoint_auth_method = "client_secret_basic"
```

Reference
* http://docs.grafana.org/installation/configuration/


## snmp on router
follow http://jamyy.us.to/blog/2014/11/6863.html

If you cannot enable net-snmp, you can remove and reinstall or just forced-install like
`ipkg install openssl -force-reinstall` to solve some error.

I generate snmp.yml by https://github.com/prometheus/snmp_exporter/tree/master/generator.

You can collect mibs from [here](https://github.com/hardaker/net-snmp/tree/a7bc508a8930a484c3a666cbea4ab226d2a3aa88/mibs)

I download these mibs: `IF-MIB  INET-ADDRESS-MIB.txt  IP-MIB.txt  RFC1213-MIB.txt  SNMPv2-CONF  SNMPv2-MIB.txt  SNMPv2-SMI  SNMPv2-TC`

Generating yml file is `snmp/router_generator.yml`.

The result file is `snmp/router.yml`

grafana board `board/router.json`

Reference 
* https://fatmin.com/2016/02/11/asus-rt-ac66u-installing-the-ipkg-command/
* https://fatmin.com/2013/11/13/install-and-configure-snmp-on-the-asus-rt-ac66u-router/
* http://devopstarter.info/snmp-exporter-generator-tutorial/


### traefik
Configure traefik https://docs.traefik.io/configuration/metrics/.

I create my own board `board/traefik.json`.

Reference:
* https://grafana.com/dashboards/2240
* https://grafana.com/dashboards/4475
* https://grafana.com/dashboards/5851


### HP printer
cd `snmp_exporter/generator`

Go to https://spp.itcs.hp.com/spp://spp.itcs.hp.com/spp/

and download it's mibs by `SDC > public > LaserJet and Digital Sender > Printer Management > MIBS > Phoenix Device MIBs > lj425`,

than get some dependency `IF-MIB RFC1155-SMI.txt  RFC1158-MIB  RFC-1212-MIB.txt  RFC1213-MIB.txt  SNMPv2-SMI  SNMPv2-TC`

put them all into `mibs`.

Execute `docker run -it --rm -v $PWD/mibs:/root/.snmp/mibs -v $PWD:/opt/ prom/snmp-generator`

remove `scan_calibration_download` and `device_redial` in snmp.yml(output yaml file).

then test it `docker run -it --rm -p 9116:9116 -v $PWD/snmp.yml:/etc/snmp_exporter/snmp.yml prom/snmp-exporter`

### Prometheus and grafana
Using helm to install `promethus` and `grafana`.
* https://github.com/helm/charts/tree/master/stable/prometheus
* https://github.com/helm/charts/tree/master/stable/grafana

`nvidia_exporter` `apcupsd_exporter` are used Daemon Set across all nodes.

# LICENSE
MIT
