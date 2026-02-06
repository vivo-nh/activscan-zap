#!/bin/sh
set -eu

echo "[activscan-zap] Starting..."

# Render sets PORT for Web Services. Fail fast if missing.
: "${PORT:?PORT must be set by Render for a Web Service}"
: "${ZAP_API_KEY:?ZAP_API_KEY must be set}"

# Tight heap cap for low-memory plans
: "${JAVA_TOOL_OPTIONS:=-Xms64m -Xmx256m -XX:+UseSerialGC -Djava.awt.headless=true}"
export JAVA_TOOL_OPTIONS

echo "[activscan-zap] PORT=${PORT}"
echo "[activscan-zap] JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS}"

# Start ZAP daemon bound to Render's port.
# Allow all source IPs but require API key (stable behind proxies).
exec /zap/zap.sh -daemon -host 0.0.0.0 -port "${PORT}" \
  -config api.disablekey=false \
  -config api.key="${ZAP_API_KEY}" \
  -config api.addrs.addr.name=".*" \
  -config api.addrs.addr.regex=true \
  -config api.addrs.addrlocalhost=true \
  -config database.recoverylog=false \
  -config view.mode=attack
