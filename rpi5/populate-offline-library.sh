#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# DHEERAJ PS5 13.60 - RPI5 OFFLINE PAYLOAD LIBRARY
# Downloads a curated set from the official itsPLK payload mirror, verifies
# SHA-256, builds a local Payload Manager source, and enables a local web server.
#
# Network settings are NOT modified by this script.
# Expected final RPi5 address: 192.168.8.50
# =============================================================================

ROOT="/home/dheeraj/PS5-OFFLINE"
PAYLOADS="$ROOT/payloads"
RPI_IP="192.168.8.50"
PORT="8080"
BASE="https://github.com/itsPLK/ps5-payloads-mirror/releases/download/payloads-mirror"

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

mkdir -p "$PAYLOADS"

download_verified() {
    local file="$1"
    local sha="$2"
    local url="$BASE/$file"
    local tmp="$PAYLOADS/.${file}.part"
    local dst="$PAYLOADS/$file"

    echo
    echo "-------------------------------------------------------------------------------"
    echo "Downloading: $file"

    rm -f "$tmp"

    curl -fL --retry 3 --connect-timeout 20 "$url" -o "$tmp"

    local actual
    actual="$(sha256sum "$tmp" | awk '{print $1}')"

    if [[ "$actual" != "$sha" ]]; then
        echo "[FAIL] SHA256 mismatch: $file"
        echo "Expected: $sha"
        echo "Actual  : $actual"
        rm -f "$tmp"
        return 1
    fi

    mv -f "$tmp" "$dst"
    echo "[PASS] $file"
}

echo
echo "==============================================================================="
echo " DHEERAJ PS5 13.60 - OFFLINE PAYLOAD LIBRARY"
echo "==============================================================================="
echo " Root : $ROOT"
echo " URL  : http://$RPI_IP:$PORT/payloads.json"
echo "==============================================================================="
echo

download_verified "pldmgr_v0.5.2.elf" \
"62b3ba2a4937c2afc502f9a4e7242cca538610ebb4ae2800c7c6f72e7f268e7c"

download_verified "WebKit-Autoloader-Installer_v0.5.1.elf" \
"80083f76383944e1f87c2d4126e4e067cd70bd8013feb538575bc2cb08258a78"

download_verified "kstuff-lite_v1.11.elf" \
"ab9a6cb4d3b1daf139d4d646e402b1cf569071acd64599c936d7a3a6164dc779"

download_verified "ShadowMountPlus_1.7beta2.elf" \
"3f716a7b2220c7e87e87452ae05cad689ef842d3beb4cdad6c526cb6dfc2b6b5"

download_verified "PKG-Manager_v1.4.1.elf" \
"09adaff13b858bb3db519faaea673ee3fa67298081e608d32f6501ed6e9f706e"

download_verified "ps5debug-NG_1.3.2.elf" \
"949b0e6e0fe3f24f4a820319fd76d9ccb92f9770cbb1a64b09a8eca5c1fc9ff3"

download_verified "ps5-web-file-manager_v1.9.elf" \
"711cb076e887fcd55d973ade8b84bb6c22720be295bfde18e32761f6e0479a3e"

download_verified "elfldr_v0.26.elf" \
"ed6d587a057c09d6a95b2176e336d9ffc605e547ac56462128b029e47b8ccea1"

download_verified "ftpsrv_v0.21.1.elf" \
"7d4b31c83eae4e056580482a3a074e1db25922efc74ac1e439473b45d71a5938"

download_verified "klogsrv_v0.9.elf" \
"e828ec144231f81547cb58bc7d2c396fa984be0c2295f31364b58017816dcceb"

download_verified "BFpilot_v0.4.4.elf" \
"5a8237630260026ad054d71fbbe661e433ac9ffa2cb4eea2785769c1eb7ee1c1"

download_verified "nanoDNS_0.4.elf" \
"dcb845f3570771275b22b37534bf924a7f8ae219fb91ef00c6bccab85d1c2420"

download_verified "websrv_v0.34.elf" \
"54730c867c6e1148536fdcb370e63a7762d989ea87b62488ad4caff64d43f263"

download_verified "shsrv_v0.20.elf" \
"fa4ccb2587bb61be317df0d001f668b17ebf9b4aafad87acf691b1fb8da0bd2d"

cat > "$ROOT/payloads.json" <<EOF
{
  "name": "Dheeraj PS5 13.60 Offline Library",
  "payloads": [
    {
      "name": "Payload Manager",
      "filename": "pldmgr_v0.5.2.elf",
      "url": "http://$RPI_IP:$PORT/payloads/pldmgr_v0.5.2.elf",
      "description": "Payload Manager v0.5.2, rebuilt with FW 13.60 support.",
      "version": "v0.5.2",
      "category": "Utilities & Tools",
      "checksum": "62b3ba2a4937c2afc502f9a4e7242cca538610ebb4ae2800c7c6f72e7f268e7c"
    },
    {
      "name": "WebKit Autoloader Installer",
      "filename": "WebKit-Autoloader-Installer_v0.5.1.elf",
      "url": "http://$RPI_IP:$PORT/payloads/WebKit-Autoloader-Installer_v0.5.1.elf",
      "description": "WebKit Autoloader v0.5.1 installer; Relapse supports FW 7.00-13.60.",
      "version": "v0.5.1",
      "category": "Loaders",
      "checksum": "80083f76383944e1f87c2d4126e4e067cd70bd8013feb538575bc2cb08258a78"
    },
    {
      "name": "kstuff-lite",
      "filename": "kstuff-lite_v1.11.elf",
      "url": "http://$RPI_IP:$PORT/payloads/kstuff-lite_v1.11.elf",
      "description": "kstuff-lite v1.11. Load only once per boot.",
      "version": "v1.11",
      "category": "System & Jailbreak",
      "checksum": "ab9a6cb4d3b1daf139d4d646e402b1cf569071acd64599c936d7a3a6164dc779"
    },
    {
      "name": "ShadowMountPlus",
      "filename": "ShadowMountPlus_1.7beta2.elf",
      "url": "http://$RPI_IP:$PORT/payloads/ShadowMountPlus_1.7beta2.elf",
      "description": "Background auto-mounter; normally load after kstuff.",
      "version": "1.7beta2",
      "category": "Utilities & Tools",
      "checksum": "3f716a7b2220c7e87e87452ae05cad689ef842d3beb4cdad6c526cb6dfc2b6b5"
    },
    {
      "name": "PKG Manager",
      "filename": "PKG-Manager_v1.4.1.elf",
      "url": "http://$RPI_IP:$PORT/payloads/PKG-Manager_v1.4.1.elf",
      "description": "Browse and install PKGs from USB, disc, or SMB shares.",
      "version": "v1.4.1",
      "category": "Utilities & Tools",
      "checksum": "09adaff13b858bb3db519faaea673ee3fa67298081e608d32f6501ed6e9f706e"
    },
    {
      "name": "ps5debug-NG",
      "filename": "ps5debug-NG_1.3.2.elf",
      "url": "http://$RPI_IP:$PORT/payloads/ps5debug-NG_1.3.2.elf",
      "description": "PS5 debugger payload; v1.3.2.",
      "version": "1.3.2",
      "category": "Utilities & Tools",
      "checksum": "949b0e6e0fe3f24f4a820319fd76d9ccb92f9770cbb1a64b09a8eca5c1fc9ff3"
    },
    {
      "name": "PS5 Web File Manager",
      "filename": "ps5-web-file-manager_v1.9.elf",
      "url": "http://$RPI_IP:$PORT/payloads/ps5-web-file-manager_v1.9.elf",
      "description": "PS5 file manager with a web interface.",
      "version": "v1.9",
      "category": "Utilities & Tools",
      "checksum": "711cb076e887fcd55d973ade8b84bb6c22720be295bfde18e32761f6e0479a3e"
    },
    {
      "name": "elfldr",
      "filename": "elfldr_v0.26.elf",
      "url": "http://$RPI_IP:$PORT/payloads/elfldr_v0.26.elf",
      "description": "ELF loader; accepts payloads on TCP 9021.",
      "version": "v0.26",
      "category": "Loaders",
      "checksum": "ed6d587a057c09d6a95b2176e336d9ffc605e547ac56462128b029e47b8ccea1"
    },
    {
      "name": "FTP Server",
      "filename": "ftpsrv_v0.21.1.elf",
      "url": "http://$RPI_IP:$PORT/payloads/ftpsrv_v0.21.1.elf",
      "description": "FTP server; listens on TCP 2121.",
      "version": "v0.21.1",
      "category": "Networking & Servers",
      "checksum": "7d4b31c83eae4e056580482a3a074e1db25922efc74ac1e439473b45d71a5938"
    },
    {
      "name": "Kernel Log Server",
      "filename": "klogsrv_v0.9.elf",
      "url": "http://$RPI_IP:$PORT/payloads/klogsrv_v0.9.elf",
      "description": "Redirects /dev/klog to clients on TCP 3232.",
      "version": "v0.9",
      "category": "Networking & Servers",
      "checksum": "e828ec144231f81547cb58bc7d2c396fa984be0c2295f31364b58017816dcceb"
    },
    {
      "name": "BFpilot",
      "filename": "BFpilot_v0.4.4.elf",
      "url": "http://$RPI_IP:$PORT/payloads/BFpilot_v0.4.4.elf",
      "description": "Lightweight browser-based PS5 file manager.",
      "version": "v0.4.4",
      "category": "Utilities & Tools",
      "checksum": "5a8237630260026ad054d71fbbe661e433ac9ffa2cb4eea2785769c1eb7ee1c1"
    },
    {
      "name": "nanoDNS",
      "filename": "nanoDNS_0.4.elf",
      "url": "http://$RPI_IP:$PORT/payloads/nanoDNS_0.4.elf",
      "description": "Local DNS proxy server payload.",
      "version": "0.4",
      "category": "Networking & Servers",
      "checksum": "dcb845f3570771275b22b37534bf924a7f8ae219fb91ef00c6bccab85d1c2420"
    },
    {
      "name": "websrv",
      "filename": "websrv_v0.34.elf",
      "url": "http://$RPI_IP:$PORT/payloads/websrv_v0.34.elf",
      "description": "Simple PS5 web server on TCP 8080.",
      "version": "v0.34",
      "category": "Networking & Servers",
      "checksum": "54730c867c6e1148536fdcb370e63a7762d989ea87b62488ad4caff64d43f263"
    },
    {
      "name": "shsrv",
      "filename": "shsrv_v0.20.elf",
      "url": "http://$RPI_IP:$PORT/payloads/shsrv_v0.20.elf",
      "description": "Telnet-like shell server on TCP 2323.",
      "version": "v0.20",
      "category": "Networking & Servers",
      "checksum": "fa4ccb2587bb61be317df0d001f668b17ebf9b4aafad87acf691b1fb8da0bd2d"
    }
  ]
}
EOF

cat > "$ROOT/offline_repo_server.py" <<'PYEOF'
#!/usr/bin/env python3
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
import os

ROOT = "/home/dheeraj/PS5-OFFLINE"
HOST = "0.0.0.0"
PORT = 8080

class Handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

os.chdir(ROOT)
print(f"Dheeraj PS5 offline repository: http://{HOST}:{PORT}/payloads.json")
ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()
PYEOF

chmod +x "$ROOT/offline_repo_server.py"

(
    cd "$PAYLOADS"
    sha256sum * > "$ROOT/MANIFEST.sha256"
)

cat > /tmp/dheeraj-ps5-offline-repo.service <<EOF
[Unit]
Description=Dheeraj PS5 Offline Payload Repository
After=network.target

[Service]
Type=simple
User=dheeraj
WorkingDirectory=$ROOT
ExecStart=/usr/bin/python3 $ROOT/offline_repo_server.py
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

$SUDO install -m 0644 /tmp/dheeraj-ps5-offline-repo.service \
    /etc/systemd/system/dheeraj-ps5-offline-repo.service

$SUDO systemctl daemon-reload
$SUDO systemctl enable --now dheeraj-ps5-offline-repo.service

if [[ -d /home/dheeraj ]]; then
    $SUDO chown -R dheeraj:dheeraj "$ROOT"
fi

echo
echo "==============================================================================="
echo " POPULATION COMPLETE"
echo "==============================================================================="
echo " Payloads : $(find "$PAYLOADS" -maxdepth 1 -type f | wc -l)"
echo " Manifest : $ROOT/MANIFEST.sha256"
echo " Source   : http://$RPI_IP:$PORT/payloads.json"
echo
echo " Service:"
$SUDO systemctl --no-pager --full status dheeraj-ps5-offline-repo.service | sed -n '1,12p'
echo
echo "Local test:"
curl -fsS "http://127.0.0.1:$PORT/payloads.json" | sed -n '1,6p'
echo
echo "IMPORTANT: This script did NOT alter eth0, wlan0, DNS, or routing."
echo "==============================================================================="
