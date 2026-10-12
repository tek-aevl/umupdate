read -r -p "Run Speedtest? (y/N): " response
if [[ "$response" == "Y" || "$response" == "y" ]]; then
    echo "$USER@$HOSTNAME speedtest"
    
    # Check if speedtest is installed. If not, pull the direct binary from Ookla
    if ! command -v speedtest &> /dev/null && [ ! -f /bin/speedtest ]; then
        echo -e "${YELLOW}Speedtest not found. Fetching official binary from speedtest.net...${NC}"
        
        # Determine system architecture
        ARCH=$(uname -m)
        if [[ "$ARCH" == "x86_64" ]]; then
            ST_URL="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz"
        elif [[ "$ARCH" == "aarch64" ]]; then
            ST_URL="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-aarch64.tgz"
        elif [[ "$ARCH" == *"arm"* ]]; then
            ST_URL="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-armhf.tgz"
        else
            echo -e "${RED}Unsupported architecture: $ARCH. Cannot install speedtest.${NC}"
            ST_URL=""
        fi
        
        # Download and extract *only* the speedtest executable directly to /bin
        if [[ -n "$ST_URL" ]]; then
            curl -fsSL "$ST_URL" | sudo tar zx -C /bin speedtest
            sudo chmod +x /bin/speedtest
        fi
    fi

    # Verify the installation succeeded before trying to run it
    if command -v speedtest &> /dev/null || [ -f /bin/speedtest ]; then
        # Try with --secure first and capture output/exit status
        # (Added accept flags so the official Ookla CLI doesn't freeze the script asking for EULA consent on first run)
        output=$(speedtest --secure --accept-license --accept-gdpr 2>&1)
        
        # If it failed due to an unknown option (which Ookla's official binary will do for --secure)
        if [[ "$output" == *"Unknown option"* ]] || [[ $? -ne 0 ]]; then
            output=$(speedtest --accept-license --accept-gdpr 2>&1)
        fi
        
        if command -v lolcat &> /dev/null; then
            echo "$output" | lolcat
        else
            echo "$output"
        fi
    else
        echo -e "${RED}Speedtest installation failed. Cannot run test.${NC}"
    fi

elif [[ -z "$response" || "$response" == "N" || "$response" == "n" ]]; then
    echo "Not running speedtest : System uptime: $(uptime)"
else
    echo "Invalid input."
fi
