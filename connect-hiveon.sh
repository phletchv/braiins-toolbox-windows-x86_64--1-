#!/bin/bash

# Braiins Toolbox - Hiveon OS Connection Script
# This script manages connections to Hiveon OS miners and pools

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/hiveon-config.json"
LOG_FILE="$SCRIPT_DIR/hiveon-connection.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Print colored output
print_color() {
    echo -e "${2}${1}${NC}"
}

# Check if jq is available
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        print_color "Warning: jq is not installed. JSON parsing will be limited." "$YELLOW"
        print_color "Install jq for full functionality: sudo apt-get install jq" "$YELLOW"
        return 1
    fi
    return 0
}

# Validate configuration file
validate_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_color "Error: Configuration file not found: $CONFIG_FILE" "$RED"
        exit 1
    fi
    
    if check_dependencies; then
        if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
            print_color "Error: Invalid JSON in configuration file" "$RED"
            exit 1
        fi
        print_color "✓ Configuration file is valid" "$GREEN"
    fi
}

# Display configuration summary
show_config() {
    print_color "=== Hiveon OS Configuration Summary ===" "$BLUE"
    
    if check_dependencies; then
        local pools=$(jq -r '.pools[] | select(.enabled == true) | "\(.name): \(.url)"' "$CONFIG_FILE")
        local api_url=$(jq -r '.api.hiveon_api_url' "$CONFIG_FILE")
        local monitoring=$(jq -r '.monitoring.enabled' "$CONFIG_FILE")
        
        echo "Enabled Pools:"
        echo "$pools" | while IFS= read -r line; do
            echo "  - $line"
        done
        echo
        echo "API URL: $api_url"
        echo "Monitoring: $monitoring"
    else
        print_color "Configuration file: $CONFIG_FILE" "$BLUE"
        print_color "Use 'jq' for detailed configuration viewing" "$YELLOW"
    fi
    echo
}

# Test pool connectivity
test_pool_connection() {
    local pool_url="$1"
    local pool_name="$2"
    
    # Extract host and port from stratum URL
    local host=$(echo "$pool_url" | sed -n 's|.*://\([^:]*\):.*|\1|p')
    local port=$(echo "$pool_url" | sed -n 's|.*://[^:]*:\([0-9]*\).*|\1|p')
    
    if [[ -n "$host" && -n "$port" ]]; then
        print_color "Testing connection to $pool_name ($host:$port)..." "$BLUE"
        if timeout 10 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
            print_color "✓ $pool_name is reachable" "$GREEN"
            log "SUCCESS: Connection test to $pool_name ($host:$port)"
            return 0
        else
            print_color "✗ $pool_name is not reachable" "$RED"
            log "FAILED: Connection test to $pool_name ($host:$port)"
            return 1
        fi
    else
        print_color "✗ Invalid pool URL format: $pool_url" "$RED"
        return 1
    fi
}

# Test all enabled pools
test_pools() {
    print_color "=== Testing Pool Connections ===" "$BLUE"
    
    if check_dependencies; then
        local success_count=0
        local total_count=0
        
        while IFS= read -r pool_data; do
            local name=$(echo "$pool_data" | jq -r '.name')
            local url=$(echo "$pool_data" | jq -r '.url')
            
            if test_pool_connection "$url" "$name"; then
                ((success_count++))
            fi
            ((total_count++))
        done < <(jq -c '.pools[] | select(.enabled == true)' "$CONFIG_FILE")
        
        echo
        print_color "Connection test results: $success_count/$total_count pools reachable" "$BLUE"
    else
        print_color "Cannot test pools without jq. Please install jq first." "$YELLOW"
    fi
}

# Test API connectivity
test_api() {
    print_color "=== Testing Hiveon API Connection ===" "$BLUE"
    
    if check_dependencies; then
        local api_url=$(jq -r '.api.hiveon_api_url' "$CONFIG_FILE")
        local timeout=$(jq -r '.api.timeout // 30' "$CONFIG_FILE")
        
        print_color "Testing API endpoint: $api_url" "$BLUE"
        
        if curl -s --connect-timeout "$timeout" --max-time "$timeout" "$api_url" > /dev/null 2>&1; then
            print_color "✓ Hiveon API is reachable" "$GREEN"
            log "SUCCESS: API connection test to $api_url"
        else
            print_color "✗ Hiveon API is not reachable or timed out" "$RED"
            log "FAILED: API connection test to $api_url"
        fi
    else
        print_color "Cannot test API without jq. Please install jq first." "$YELLOW"
    fi
}

# Generate miner configuration
generate_miner_config() {
    local output_file="$SCRIPT_DIR/miner-config-hiveon.conf"
    
    print_color "=== Generating Miner Configuration ===" "$BLUE"
    
    if check_dependencies; then
        local enabled_pools=$(jq -c '.pools[] | select(.enabled == true)' "$CONFIG_FILE")
        local worker_name=$(jq -r '.miner_config.default_worker_name // "worker01"' "$CONFIG_FILE")
        
        {
            echo "# Hiveon OS Miner Configuration"
            echo "# Generated on $(date)"
            echo ""
            
            local pool_index=1
            while IFS= read -r pool_data; do
                local name=$(echo "$pool_data" | jq -r '.name')
                local url=$(echo "$pool_data" | jq -r '.url')
                local user=$(echo "$pool_data" | jq -r '.user')
                local password=$(echo "$pool_data" | jq -r '.password // "x"')
                local algorithm=$(echo "$pool_data" | jq -r '.algorithm // "ethash"')
                
                echo "# Pool $pool_index: $name"
                echo "POOL${pool_index}_URL=\"$url\""
                echo "POOL${pool_index}_USER=\"$user\""
                echo "POOL${pool_index}_PASS=\"$password\""
                echo "POOL${pool_index}_ALGO=\"$algorithm\""
                echo ""
                ((pool_index++))
            done < <(echo "$enabled_pools")
            
            echo "# Miner Settings"
            echo "WORKER_NAME=\"$worker_name\""
            echo "POWER_LIMIT=$(jq -r '.miner_config.power_limit // 80' "$CONFIG_FILE")"
            echo "TEMP_LIMIT=$(jq -r '.miner_config.temperature_limit // 85' "$CONFIG_FILE")"
            echo "FAN_SPEED=\"$(jq -r '.miner_config.fan_speed // "auto"' "$CONFIG_FILE")\""
            
        } > "$output_file"
        
        print_color "✓ Miner configuration written to: $output_file" "$GREEN"
        log "Generated miner configuration: $output_file"
    else
        print_color "Cannot generate miner config without jq. Please install jq first." "$YELLOW"
    fi
}

# Show usage
show_usage() {
    echo "Braiins Toolbox - Hiveon OS Connection Manager"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  config      Show configuration summary"
    echo "  test        Test all connections (pools and API)"
    echo "  test-pools  Test pool connections only"
    echo "  test-api    Test API connection only"
    echo "  generate    Generate miner configuration file"
    echo "  validate    Validate configuration file"
    echo "  help        Show this help message"
    echo ""
    echo "Configuration file: $CONFIG_FILE"
    echo "Log file: $LOG_FILE"
}

# Main execution
main() {
    case "${1:-help}" in
        "config")
            validate_config
            show_config
            ;;
        "test")
            validate_config
            test_pools
            echo
            test_api
            ;;
        "test-pools")
            validate_config
            test_pools
            ;;
        "test-api")
            validate_config
            test_api
            ;;
        "generate")
            validate_config
            generate_miner_config
            ;;
        "validate")
            validate_config
            print_color "✓ Configuration is valid" "$GREEN"
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            print_color "Unknown command: $1" "$RED"
            echo
            show_usage
            exit 1
            ;;
    esac
}

# Initialize log file
echo "=== Hiveon OS Connection Script Started ===" >> "$LOG_FILE"
log "Script executed with arguments: $*"

# Run main function
main "$@"