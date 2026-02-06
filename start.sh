#!/bin/sh
set -eu

# Tight heap cap for 512MB
: "${JAVA_TOOL_OPTIONS:=-Xms64m -Xmx256m -XX:+UseSerialGC -Djava.awt.headless=true}"
export JAVA_TOOL_OPTIONS

# Require an API key (passed via env var on Render)
: "${ZAP_API_KEY:?ZAP_API_KEY must be set}"

# Start ZAP daemon
# Note: api.disablekey=false means key REQUIRED.
# api.key sets the key.
# api.addrs.addr.name=0.0.0.0 allows remote access (we rely on key + Render private URL).
/zap/zap.sh -daemon -host 0.0.0.0 -port 8090 \
  -config api.disablekey=false \
  -config api.key="${ZAP_API_KEY}" \
  -config api.addrs.addr.name=0.0.0.0 \
  -config api.addrs.addr.regex=false \
  -config database.recoverylog=false \
  -config view.mode=attack
