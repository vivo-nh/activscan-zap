#!/bin/sh
set -eu

echo "[activscan-zap] Booting..."

# Render provides the port to listen on
: "${PORT:=8090}"

# Tight heap cap for low-memory plans (adjust if you have more RAM)
: "${JAVA_TOOL_OPTIONS:=-Xms64m -Xmx256m -XX:+UseSerialGC -Djava.awt.headless=true}"
export JAVA_TOOL_OPTIONS

# Require an API key (passed via env var on Render)
: "${ZAP_API_KEY:?ZAP_API_KEY must be set}"

echo "[activscan-zap] Using PORT=${PORT}"
echo "[activscan-zap] JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS}"

# Start ZAP daemon
# - host 0.0.0.0 => listen on all interfaces (required on Render)
# - port $PORT => required on Render
# - api.disablekey=false => key REQUIRED
# - Allow all source IPs (we rely on API key); this avoids proxy/IP mismatches on Render
exec /zap/zap.sh -daemon -host 0.0.0.0 -port "${PORT}" \
  -config api.disablekey=false \
  -config api.key="${ZAP_API_KEY}" \
  -config api.addrs.addr.name=".*" \
  -config api.addrs.addr.regex=true \
  -config database.recoverylog=false \
  -config view.mode=attack
