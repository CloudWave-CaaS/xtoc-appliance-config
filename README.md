# xtoc-appliance-config
eXtended Tactical Operations Center (XTOC) configuration and documentation - an unofficial sentinel appliance release build

# How this works...
- Load the XTOC-Sentinel-v1.x.x appliance OVA
- Power it on and voila!

# Configuration:
- Ubuntu 24.04.1 LTS (Linux 6.8.0-49 Generic)
- Docker build 26.1.3
- OSSEC HIDs v.3.60 (https://github.com/ossec/ossec-docker)
- Zeek v 7.0.4 (https://github.com/zeek/zeek-docker)
- Chronicle Forwarder (https://cloud.google.com/chronicle/docs/install/install-forwarder#installdockerlinux)

## 1.0.0 Notes
- Quality of life improvements:
  - Auto Start Services
  - net-tools, nano, and that sort of stuff..
  - DHCP configuration

## 1.0.1 Notes
- WebGUI - `/var/www/xtoc-config`
  - Node v20.18.1
  - npm 10.8.2 
