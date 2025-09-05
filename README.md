# xtoc-appliance-config
eXtended Tactical Operations Center (XTOC) configuration and documentation - an unofficial sentinel appliance release build

# How this works...
- Load the XTOC-Sentinel-v1.x.x appliance OVA
- Power it on and voila!

# Configuration:
- Run install/setup_containers.sh
  - Docker build 26.1.3
  - OSSEC HIDs v.3.60 (https://github.com/ossec/ossec-docker)
  - Zeek v 7.0.4 (https://github.com/zeek/zeek-docker)
  - Chronicle Forwarder (https://cloud.google.com/chronicle/docs/install/install-forwarder#installdockerlinux)

# XTOC-Sentinel-x.x.x
## 0.0.1 Notes
- Ubuntu 22.04.5 LTS (Linux 5.15.0-126 Generic)
- VBOX Guest Additions + NAGENT autostart e.g. visit: N-Able Central (https://n-able.com)

## 1.0.0 Notes
- Ubuntu 24.04.1 LTS (Linux 6.8.0-49 Generic)
- Quality of life improvements:
  - Auto Start Services
  - net-tools, nano, and that sort of stuff..
  - DHCP configuration

## 1.0.1 Notes
- Ubuntu 24.04.1 LTS (Linux 6.8.0-49 Generic)
- Run install/setup_node.sh (make sure that /mnt/ is available--- you may need VBOXSF)
- WebGUI - `/var/www/xtoc-config/`
  - Node v20.18.1
  - npm 10.8.2
 
## 1.0.2 Notes
- Runas Service (`systemctl status xtoc-config.service`
- `xtocsvc`

## 2.0.0 Notes
- Added PackageManager

# XTOC-VSCAN-x.x.x
## 1.0.0 Notes
- Ubuntu 24.04.1 LTS
- Run install/setup_vscan.sh
- Make sure you have at least 20GB.
