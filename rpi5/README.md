# Dheeraj RPi5 Offline Payload Library

Dheeraj-specific deployment helpers for a PS5 13.60 offline lab.

These files are not part of upstream `itsPLK/ps5-payload-manager`.

## Purpose

Populate an RPi5 with a curated, checksum-verified local payload repository while Internet access is temporarily available. The generated custom repository remains reachable later over the isolated PS5 Ethernet network.

Expected final RPi5 address: `192.168.8.50`.

Payload Manager custom source URL:

```
http://192.168.8.50:8080/payloads.json
```

The population script does **not** modify Wi-Fi, Ethernet, DNS, or routing.

## Included payloads

- Payload Manager v0.5.2
- WebKit Autoloader Installer v0.5.1
- kstuff-lite v1.11
- ShadowMountPlus 1.7beta2
- PKG Manager v1.4.1
- ps5debug-NG v1.3.2
- PS5 Web File Manager v1.9
- elfldr v0.26
- ftpsrv v0.21.1
- klogsrv v0.9
- BFpilot v0.4.4
- nanoDNS 0.4
- websrv v0.34
- shsrv v0.20

All assets are downloaded from the official `itsPLK/ps5-payloads-mirror` release and checked against the mirror's published SHA-256 values.

## Run

```bash
chmod +x rpi5/populate-offline-library.sh
sudo ./rpi5/populate-offline-library.sh
```

After final network cutover, add this source in Payload Manager:

```
http://192.168.8.50:8080/payloads.json
```
