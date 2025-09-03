# Braiins Pool Troubleshooting Guide

## Common Connection Issues

### Issue 1: Miner Cannot Connect to Pool

**Symptoms:**
- Miner shows "Stratum connection failed"
- "Pool not responding" errors
- Cannot establish TCP connection

**Solutions:**
1. **Check Internet Connection**
   ```cmd
   ping google.com
   ping stratum.braiins.com
   ```

2. **Verify Pool Configuration**
   - URL: `stratum+tcp://stratum.braiins.com:3333`
   - Username format: `your_username.worker_name`
   - Password: any value (commonly "x")

3. **Firewall Configuration**
   - Allow outbound connections on ports: 3333, 3336, 3334, 3335
   - Add exception for your mining software

4. **Try Alternative Ports**
   - Primary: 3333
   - Backup: 3336
   - SSL: 3334, 3335

### Issue 2: High Rejection Rate

**Symptoms:**
- High percentage of rejected shares
- "Share above target" errors
- Low effective hashrate

**Solutions:**
1. **Check Network Latency**
   ```cmd
   ping stratum.braiins.com
   ```
   Latency should be under 100ms

2. **Verify Miner Configuration**
   - Use correct difficulty setting
   - Update miner firmware
   - Check for overclocking issues

3. **Pool Server Selection**
   - Try different stratum ports
   - Use geographically closer servers

### Issue 3: Worker Appears Offline

**Symptoms:**
- Worker shows offline in pool dashboard
- No shares being submitted
- Zero hashrate reported

**Solutions:**
1. **Check Miner Status**
   - Verify miner is running
   - Check for hardware errors
   - Review miner logs

2. **Network Connectivity**
   - Test internet connection
   - Verify pool connectivity
   - Check router/switch status

3. **Configuration Verification**
   - Double-check username/worker format
   - Verify pool URLs
   - Test with different worker name

### Issue 4: Low Hashrate

**Symptoms:**
- Reported hashrate lower than expected
- Poor mining efficiency
- Inconsistent performance

**Solutions:**
1. **Hardware Check**
   - Monitor temperatures
   - Check power supply stability
   - Verify all mining units are active

2. **Software Optimization**
   - Update mining software
   - Adjust intensity settings
   - Check for background processes

3. **Network Optimization**
   - Use wired connection instead of WiFi
   - Reduce network congestion
   - Configure QoS settings

## Windows-Specific Issues

### Issue 5: Windows Defender Blocking Miner

**Symptoms:**
- Antivirus alerts about mining software
- Miner executable deleted or quarantined
- Access denied errors

**Solutions:**
1. **Add Exclusions**
   - Add miner folder to Windows Defender exclusions
   - Whitelist mining executables
   - Disable real-time protection temporarily

2. **Alternative Antivirus**
   - Consider switching to mining-friendly antivirus
   - Use portable versions of miners
   - Run from excluded directories

### Issue 6: UAC (User Account Control) Issues

**Symptoms:**
- Permission denied errors
- Cannot write to directories
- Elevated privileges required

**Solutions:**
1. **Run as Administrator**
   - Right-click → "Run as administrator"
   - Create elevated shortcuts
   - Modify UAC settings (not recommended)

2. **Alternative Locations**
   - Use user documents folder
   - Create miners folder in user space
   - Avoid system directories

## Diagnostic Commands

### Network Diagnostics
```cmd
# Test basic connectivity
ping stratum.braiins.com

# Test specific ports
telnet stratum.braiins.com 3333
telnet stratum.braiins.com 3336

# Check DNS resolution
nslookup stratum.braiins.com

# Trace network route
tracert stratum.braiins.com
```

### System Diagnostics
```cmd
# Check system resources
tasklist | findstr miner
perfmon

# Check event logs
eventvwr.msc

# Network adapter status
ipconfig /all
netstat -an | findstr 3333
```

## Log Analysis

### Common Error Messages

**"Stratum connection interrupted"**
- Temporary network issue
- Pool server maintenance
- Try backup pool

**"JSON decode failed"**
- Communication protocol error
- Update mining software
- Check pool compatibility

**"Share rejected: duplicate"**
- Clock synchronization issue
- Multiple miners with same worker name
- Network delay causing duplicates

**"Work restart"**
- Normal pool operation
- New block found
- No action needed

## Getting Additional Help

### Log Collection
When seeking help, provide:
1. Mining software and version
2. Hardware specifications
3. Complete error messages
4. Network configuration
5. Relevant log files

### Contact Points
- **Braiins Support:** help.braiins.com
- **Discord Community:** discord.gg/braiins
- **Telegram:** @BraiinsPool
- **Email Support:** support@braiins.com

### Emergency Procedures

1. **Complete Loss of Connection**
   - Switch to backup pools
   - Check local network status
   - Contact ISP if needed

2. **Hardware Failures**
   - Power cycle equipment
   - Check all connections
   - Monitor temperatures

3. **Account Issues**
   - Verify login credentials
   - Check email for notifications
   - Contact pool support

Remember: Most issues are temporary and can be resolved with basic troubleshooting steps.