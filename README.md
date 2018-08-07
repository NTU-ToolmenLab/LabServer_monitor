# Build monitor with docker-compose

Use 

* traefik
* grafana
* prometheus
* node-exporter
* nvidia-smi
* apcaccess
* snmp-exporter
* Use Granfana Alerting on Telegram

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


### nodeexporter on localhost
in `prometheus.yml`

change it if you use node-exporter on localhost

```
  - job_name: 'node-exporter'
    scrape_interval: 5s
    static_configs:
         - targets: ['your.internal.ip:9100']
```

### nodeexporter on localhost
in `prometheus.yml`

change you target ip to your nas.

```
  - job_name: 'snmp_nas'
    scrape_interval: 15s
    scrape_timeout: 15s
    metrics_path: /snmp
    params:
      module: [synology]
      target: [192.168.1.2]
    static_configs:
      - targets: ['snmpexporter:9116']
```

### APC setup
If you cannot use apc, maybe you did't set 

`NETIP 0.0.0.0` in `/etc/apcupsd/apcupsd.conf`

### snmpexporter
To monitor Synology,

you should set up SNMP in NAS https://www.synology.com/en-uk/knowledgebase/DSM/help/DSM/AdminCenter/system_snmp

And if you don't want to use [generator](https://github.com/prometheus/snmp_exporter/tree/master/generator),

you should enable `SNMPv2c` service and set Communitunity Name = `public`

### Grafana
After start grafana,
import dashboard by json file,
* `grafana_myserver.json`
* `grafana_myserver_alert.json` This has Alerting rules and alert on Telegram

## reference
* Modified from
   https://grafana.com/dashboards/5573 and https://gist.github.com/mdlayher/962aecd2858454a822bb5ad847168cb0
* `docker-compose.yml` is modified from https://github.com/vegasbrianc/prometheus/blob/master/docker-compose.yml
* Reference of `snmp_synology` https://global.download.synology.com/download/Document/MIBGuide/Synology_DiskStation_MIB_Guide.pdf

## Alert on Telegram
goto alerting -> alerting channel
and create type = telegram

`BOT API Token` is gotten from BotFather

invite bot into your group.

To me, I need to disable private mode (Disable it at BotFather)

`Chat ID` is your bot listen on your group ID.
You can use tutorial python bot to listen to your group,
then, you can collect groupID by someone send message after to attach your bot in it.

However, grafana alerting cannot work at template data.

# LICENSE
MIT
