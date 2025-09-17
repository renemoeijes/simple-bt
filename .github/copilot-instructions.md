# Copilot Instructions for `simple-bt`

## Project Overview
- **Purpose:** A minimal Bluetooth agent for Raspberry Pi, distributed as a DEB package. It ensures seamless Bluetooth audio device switching: when a new device connects, all others are disconnected, and Spotify playback is paused if running.
- **Core Logic:** Implemented in `usr/local/bin/simple-bt-agent.sh` (Expect script). Managed as a systemd service (`lib/systemd/system/simple-bt.service`).

## Key Components
- `pkg/DEBIAN/` — DEB packaging scripts and metadata (`control`, `postinst`, `prerm`).
- `pkg/usr/local/bin/simple-bt-agent.sh` — Main agent logic (Expect script, not Bash!).
- `pkg/lib/systemd/system/simple-bt.service` — Systemd unit for auto-start.

## Build & Install Workflow
- **Build DEB:**
  ```sh
  dpkg-deb --build simple-bt
  ```
- **Install DEB:**
  ```sh
  sudo dpkg -i simple-bt_*.deb
  ```
- **Service Management:**
  - Service is enabled/started by `postinst` script.
  - Use `systemctl status simple-bt.service` to check status.

## Agent Script Patterns
- Written in Expect, not Bash. Use `send`/`expect` for interaction with `bluetoothctl`.
- On new device connection, disconnects all others and (if running) pauses Spotify via DBus.
- Avoids pairing codes and manual intervention: just connect and play.

## Conventions & Integration
- No persistent device pairing: always pairable/discoverable.
- No user prompts or codes.
- Relies on `expect`, `bluez`, and (optionally) `spotifyd`.
- Systemd is required for service management.

## Examples
- See `simple-bt-agent.sh` for event-driven device management.
- See `DEBIAN/postinst` and `prerm` for install/remove hooks.

## When Contributing
- Maintain the "just works" philosophy: minimal user interaction, robust auto-switching.
- Test changes by rebuilding and reinstalling the DEB, then checking service logs.
- Document any new dependencies or service changes in this file and the README.
