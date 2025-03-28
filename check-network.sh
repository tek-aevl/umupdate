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

echo -e "\n🌐 Checking default gateway..."
GATEWAY=$(ip route | awk '/default/ {print $3}' | head -n1)

if [[ "$GATEWAY"
