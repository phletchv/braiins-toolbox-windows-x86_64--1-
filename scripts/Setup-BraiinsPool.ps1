# Braiins Pool Connection Checker and Setup Tool
# PowerShell script for advanced users

param(
    [string]$Username,
    [string]$Worker,
    [switch]$TestOnly,
    [switch]$Verbose
)

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-PoolConnectivity {
    Write-ColorOutput "Testing Braiins Pool Connectivity..." "Yellow"
    
    # Test DNS resolution
    try {
        $dnsResult = Resolve-DnsName "stratum.braiins.com" -ErrorAction Stop
        Write-ColorOutput "[✓] DNS resolution successful" "Green"
    }
    catch {
        Write-ColorOutput "[✗] DNS resolution failed" "Red"
        return $false
    }
    
    # Test ping
    try {
        $pingResult = Test-Connection "stratum.braiins.com" -Count 1 -Quiet
        if ($pingResult) {
            Write-ColorOutput "[✓] Ping successful" "Green"
        } else {
            Write-ColorOutput "[✗] Ping failed" "Red"
            return $false
        }
    }
    catch {
        Write-ColorOutput "[✗] Ping test failed" "Red"
        return $false
    }
    
    # Test stratum ports
    $ports = @(3333, 3336, 3334, 3335)
    foreach ($port in $ports) {
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $tcpClient.ConnectAsync("stratum.braiins.com", $port).Wait(3000)
            if ($tcpClient.Connected) {
                Write-ColorOutput "[✓] Port $port accessible" "Green"
                $tcpClient.Close()
            } else {
                Write-ColorOutput "[!] Port $port may be blocked" "Yellow"
            }
        }
        catch {
            Write-ColorOutput "[!] Port $port connection failed" "Yellow"
        }
        finally {
            if ($tcpClient) { $tcpClient.Dispose() }
        }
    }
    
    return $true
}

function Get-UserCredentials {
    if (-not $Username) {
        $Username = Read-Host "Enter your Braiins Pool username"
    }
    
    if (-not $Worker) {
        $Worker = Read-Host "Enter worker name (e.g., miner01)"
    }
    
    if ([string]::IsNullOrEmpty($Username) -or [string]::IsNullOrEmpty($Worker)) {
        Write-ColorOutput "Username and worker name are required!" "Red"
        exit 1
    }
    
    return @{
        Username = $Username
        Worker = $Worker
        FullWorker = "$Username.$Worker"
    }
}

function Create-MinerConfigs {
    param($Credentials)
    
    Write-ColorOutput "Creating miner configuration files..." "Yellow"
    
    # Create config directory if it doesn't exist
    $configDir = ".\miner-configs"
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir | Out-Null
    }
    
    # BFGMiner batch file
    $bfgConfig = @"
@echo off
echo Starting BFGMiner for Braiins Pool...
bfgminer.exe -o stratum+tcp://stratum.braiins.com:3333 -u $($Credentials.FullWorker) -p x --failover-only -o stratum+tcp://stratum.braiins.com:3336 -u $($Credentials.FullWorker) -p x
pause
"@
    $bfgConfig | Out-File -FilePath "$configDir\start-bfgminer.bat" -Encoding ASCII
    
    # CGMiner JSON config
    $cgConfig = @{
        pools = @(
            @{
                url = "stratum+tcp://stratum.braiins.com:3333"
                user = $Credentials.FullWorker
                pass = "x"
            },
            @{
                url = "stratum+tcp://stratum.braiins.com:3336"
                user = $Credentials.FullWorker
                pass = "x"
            }
        )
        "api-listen" = $true
        "api-allow" = "127.0.0.1"
        "api-port" = 4028
    }
    $cgConfig | ConvertTo-Json -Depth 3 | Out-File -FilePath "$configDir\cgminer.conf" -Encoding UTF8
    
    # CGMiner batch file
    $cgBatch = @"
@echo off
echo Starting CGMiner for Braiins Pool...
cgminer.exe --config cgminer.conf
pause
"@
    $cgBatch | Out-File -FilePath "$configDir\start-cgminer.bat" -Encoding ASCII
    
    Write-ColorOutput "[✓] Configuration files created in '$configDir'" "Green"
    Write-ColorOutput "  - start-bfgminer.bat" "Cyan"
    Write-ColorOutput "  - start-cgminer.bat" "Cyan"
    Write-ColorOutput "  - cgminer.conf" "Cyan"
}

function Show-Summary {
    param($Credentials)
    
    Write-ColorOutput "`n=========================" "Magenta"
    Write-ColorOutput " Configuration Summary" "Magenta"
    Write-ColorOutput "=========================" "Magenta"
    Write-ColorOutput "Username: $($Credentials.Username)" "White"
    Write-ColorOutput "Worker: $($Credentials.FullWorker)" "White"
    Write-ColorOutput "Pool: stratum+tcp://stratum.braiins.com:3333" "White"
    Write-ColorOutput "Backup: stratum+tcp://stratum.braiins.com:3336" "White"
    Write-ColorOutput "`nNext steps:" "Yellow"
    Write-ColorOutput "1. Copy your miner executable to the 'miner-configs' folder" "White"
    Write-ColorOutput "2. Run the appropriate start-*.bat file" "White"
    Write-ColorOutput "3. Monitor your workers at: https://pool.braiins.com" "White"
    Write-ColorOutput "=========================" "Magenta"
}

# Main execution
Write-ColorOutput "Braiins Pool Setup Tool for Windows" "Magenta"
Write-ColorOutput "====================================" "Magenta"

# Test connectivity first
$connectivityOk = Test-PoolConnectivity

if (-not $connectivityOk) {
    Write-ColorOutput "`nConnectivity issues detected. Please check your network configuration." "Red"
    if (-not $TestOnly) {
        $continue = Read-Host "Continue anyway? (y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            exit 1
        }
    }
}

if ($TestOnly) {
    Write-ColorOutput "`nConnectivity test completed." "Green"
    exit 0
}

# Get credentials and create configs
$credentials = Get-UserCredentials
Create-MinerConfigs -Credentials $credentials
Show-Summary -Credentials $credentials

Write-ColorOutput "`nSetup completed successfully!" "Green"