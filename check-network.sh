#!/bin/bash
# Run this script directly from GitHub:
# bash <(curl -s https://raw.githubusercontent.com/tek-aevl/umupdate/refs/heads/main/check-network.sh)

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

FIX_MODE=false
[[ "$1" == "--fix" ]] && FIX_MODE=true

echo -e "\n🔍 Checking default network device..."
DEFAULT_DEV=$(ip route | awk '/default/ {print $5}' | head -n1)

if [[ -z "$DEFAULT_DEV" ]]; then
  DEFAULT_DEV=$(ip -4 addr show | awk '/state UP/ {print $2}' | sed 's/://g' | head -n1)
fi

if [[ -z "$DEFAULT_DEV" ]]; then
  echo -e "${RED}❌ No active network device found!${NC}"
  exit 1
else
  echo -e "${GREEN}✅ Network device: $DEFAULT_DEV${NC}"
fi

# Get the current gateway
GATEWAY=$(ip route | awk '/default/ {print $3}' | head -n1)

# If missing, infer from local IP
if [[ -z "$GATEWAY" ]]; then
  echo -e "${YELLOW}⚠️  No default gateway found — inferring from subnet...${NC}"
  HOST_IP=$(ip -4 addr show "$DEFAULT_DEV" | awk '/inet / {print $2}' | cut -d'/' -f1 | head -n1)

  if [[ "$HOST_IP" =~ ^10\.20\.0\.[0-9]+$ ]]; then
    GATEWAY="10.20.0.1"
    echo -e "${GREEN}✅ Inferred gateway based on subnet: $GATEWAY${NC}"
  elif [[ "$HOST_IP" =~ ^10\.30\.0\.[0-9]+$ ]]; then
    GATEWAY="10.30.0.1"
    echo -e "${GREEN}✅ Inferred gateway based on subnet: $GATEWAY${NC}"
  else
    echo -e "${RED}❌ Could not infer gateway from IP $HOST_IP${NC}"
    GATEWAY="unknown"
  fi
fi

# Get DHCP server
if command -v resolvectl &>/dev/null; then
  DHCP_SERVER=$(resolvectl status "$DEFAULT_DEV" | awk -F': ' '/DHCP Server/ {print $2}' | head -n1)
else
  DHCP_SERVER="unknown"
fi

# Validate gateway
echo -e "\n🌐 Checking default gateway..."
if [[ "$GATEWAY" == "10.30.0.1" ]]; then
  echo -e "${GREEN}✅ Default gateway is correctly set to 10.30.0.1${NC}"
elif [[ "$GATEWAY" == "10.20.0.1" && "$DHCP_SERVER" == "10.20.0.1" ]]; then
  echo -e "${GREEN}✅ Gateway and DHCP server are both 10.20.0.1 — valid configuration${NC}"
else
  echo -e "${RED}❌ Unexpected gateway configuration:${NC}"
  echo -e "${RED}   Gateway: $GATEWAY${NC}"
  echo -e "${RED}   DHCP Server: $DHCP_SERVER${NC}"
  if $FIX_MODE && [[ "$GATEWAY" != "unknown" ]]; then
    echo -e "${YELLOW}⚙️  Setting gateway to $GATEWAY via $DEFAULT_DEV...${NC}"
    sudo ip route replace default via "$GATEWAY" dev "$DEFAULT_DEV"
    echo -e "${GREEN}✅ Default route updated${NC}"
  fi
fi

# Check DNS
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
  if $FIX_MODE; then
    echo -e "${YELLOW}⚙️  Setting DNS to 10.30.0.1...${NC}"
    echo -e "nameserver 10.30.0.1\noptions edns0 trust-ad\n" | sudo tee /etc/resolv.conf > /dev/null
    echo -e "${GREEN}✅ DNS updated${NC}"
  fi
fi
