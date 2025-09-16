# simple-bt

A simple Bluetooth agent for Raspberry Pi, designed for installation via a DEB package.
Just connect and play. no codes, no old connections, stutter etc. Just connect and play.


## Structure
- `DEBIAN/` — Contains package metadata and scripts (`control`, `postinst`, `prerm`).
- `lib/systemd/system/simple-bt.service` — Systemd service file for the agent.
- `usr/local/bin/simple-bt-agent.sh` — The agent's shell script.

## Installation
1. Build a DEB package from this directory:
   ```sh
   dpkg-deb --build simple-bt
   ```
2. Install the package:
   ```sh
   sudo dpkg -i simple-bt.deb
   ```

## Usage
- The service will be started automatically via systemd.
- The script `simple-bt-agent.sh` contains the logic for the Bluetooth agent.

## Author
- [R. Moeijes] (https://github.com/renemoeijes)