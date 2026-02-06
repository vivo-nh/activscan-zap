#!/bin/sh
set -eu

echo "[activscan-zap] START.SH STABLE 2026-02-06"
echo "[activscan-zap] env: PORT=${PORT:-<unset>} ZAP_API_KEY=${ZAP_API_KEY:+<set>}${ZAP_API_KEY:-<unset>}"

: "${PORT:?PORT must be set by Render (Web Service required)}"
: "${ZAP_API_KEY:?ZAP_API_KEY must be set}"

: "${JAVA_TOOL_OPTIONS:=-Xms64m -Xmx256m -XX:+UseSerialGC -Djava.awt.headless=true}"
export JAVA_TOOL_OPTIONS

echo "[activscan-zap] binding: 0.0.0.0:${PORT}"

exec /zap/zap.sh -daemon -host 0.0.0.0 -port "${PORT}" \
  -config api.disablekey=false \
  -config api.key="${ZAP_API_KEY}" \
  -config api.addrs.addr.name=".*" \
  -config api.addrs.addr.regex=true \
  -config database.recoverylog=false \
  -config view.mode=attack \
  -config oast.callback.enabled=false \
  -config autoupdate.check=false \
  -config autoupdate.install=false
