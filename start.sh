#!/bin/sh
set -eu

echo "[activscan-zap] START.SH PROOF 2026-02-06"
echo "[activscan-zap] whoami=$(whoami)"
echo "[activscan-zap] pwd=$(pwd)"
echo "[activscan-zap] list:/zap-service =>"
ls -la /zap-service || true

echo "[activscan-zap] env grep PORT =>"
env | grep -E '(^PORT=|PORT$|RENDER|SERVICE|HTTP)' || true

: "${ZAP_API_KEY:?ZAP_API_KEY must be set}"

# Render must set PORT for Web Services.
if [ -z "${PORT:-}" ]; then
  echo "[activscan-zap] ERROR: PORT is unset. This service is not running as a Render Web Service."
  exit 1
fi

echo "[activscan-zap] PORT=${PORT}"

: "${JAVA_TOOL_OPTIONS:=-Xms64m -Xmx256m -XX:+UseSerialGC -Djava.awt.headless=true}"
export JAVA_TOOL_OPTIONS
echo "[activscan-zap] JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS}"

echo "[activscan-zap] exec: /zap/zap.sh -daemon -host 0.0.0.0 -port ${PORT} ..."
exec /zap/zap.sh -daemon -host 0.0.0.0 -port "${PORT}" \
  -config api.disablekey=false \
  -config api.key="${ZAP_API_KEY}" \
  -config api.addrs.addr.name=".*" \
  -config api.addrs.addr.regex=true \
  -config database.recoverylog=false \
  -config view.mode=attack
