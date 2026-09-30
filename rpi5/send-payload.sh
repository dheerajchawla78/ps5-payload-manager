#!/usr/bin/env bash
set -euo pipefail

PS5_IP="${PS5_IP:-192.168.8.60}"
PORT="${PS5_ELFLDR_PORT:-9021}"
LIB="/home/dheeraj/PS5-OFFLINE/payloads"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <payload-file-or-name>"
    echo
    echo "Examples:"
    echo "  $0 pldmgr_v0.5.2.elf"
    echo "  $0 $LIB/ftpsrv_v0.21.1.elf"
    exit 1
fi

INPUT="$1"

if [[ -f "$INPUT" ]]; then
    FILE="$INPUT"
elif [[ -f "$LIB/$INPUT" ]]; then
    FILE="$LIB/$INPUT"
else
    echo "[FAIL] Payload not found: $INPUT"
    exit 1
fi

echo "==============================================================================="
echo " DHEERAJ PS5 PAYLOAD SENDER"
echo "==============================================================================="
echo " PS5     : $PS5_IP"
echo " Port    : $PORT"
echo " Payload : $FILE"
echo " Size    : $(stat -c '%s' "$FILE") bytes"
echo " SHA256  : $(sha256sum "$FILE" | awk '{print $1}')"
echo "==============================================================================="

if ! timeout 3 bash -c "</dev/tcp/$PS5_IP/$PORT" 2>/dev/null; then
    echo "[FAIL] $PS5_IP:$PORT is not accepting connections."
    echo "       Confirm elfldr is active before sending."
    exit 1
fi

if command -v nc >/dev/null 2>&1; then
    nc "$PS5_IP" "$PORT" < "$FILE"
else
    cat "$FILE" > "/dev/tcp/$PS5_IP/$PORT"
fi

echo "[PASS] Payload transfer completed."
