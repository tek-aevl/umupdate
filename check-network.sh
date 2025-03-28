#!/bin/bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\n🔍 Checking default network device..."
DEFAULT_DEV=$(ip route | awk '/default/ {print $5}' | head -n1)

if [[ -z "$DEFAULT_DEV" ]]; then
  echo -e "${RED}❌ No default network device found!${NC}"
  exit 1
else
  echo -e "${GREEN}✅ Default network device: $DEFAULT_DEV${NC}"
fi

# Check gateway
GATEWAY=$(ip route | awk '/default/ {print $3}' | head -n1)

# Detect DHCP server
if command -v resolvectl &>/dev/null; then
  DHCP_SERVER=$(resolvectl status | awk -F': ' '/DHCP Server/ {print $2}' | head -n1)
else
  DHCP_SERVER="unknown"
fi

echo -e "\n🌐 Checking default gateway..."

if [[ "$GATEWAY" == "10.30.0.1" ]]; then
  echo -e "${GREEN}✅ Default gateway is correctly set to 10.30.0.1${NC}"
elif [[ "$GATEWAY" == "10.20.0.1" && "$DHCP_SERVER" == "10.20.0.1" ]]; then
  echo -e "${GREEN}✅ Gateway and DHCP server are both 10.20.0.1 — valid configuration${NC}"
else
  echo -e "${RED}❌ Unexpected gateway configuration:${NC}"
  echo -e "${RED}   Gateway: $GATEWAY${NC}"
  echo -e "${RED}   DHCP Server: $DHCP_SERVER${NC}"
fi

# Check DNS servers
echo -e "\n📡 Checking DNS servers..."
if command -v resolvectl &>/dev/null; then
  DNS_SERVERS=$(resolvectl dns "$DEFAULT_DEV" | awk '{for (i=2; i<=NF; i++) print $i}')
else
  DNS_SERVERS=$(grep "^nameserver" /etc/resolv.conf | awk '{print $2}')
fi

if echo "$DNS_SERVERS" | grep -q "10.30.0.1"; then
  echo -e "${GREEN}✅ DNS server includes 10.30.0.1${NC}"
else
  echo -e "${RED}❌ DNS server is missing 10.30.0.1. Found:${NC}"
  echo "$DNS_SERVERS"
fi
