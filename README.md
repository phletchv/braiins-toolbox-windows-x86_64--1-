# Braiins Pool Connection Toolbox for Windows x86_64

This toolbox provides everything you need to connect your mining hardware to **Braiins Pool**, one of the most trusted Bitcoin mining pools in the world.

## Quick Start Guide

### 1. Create Your Braiins Pool Account

1. Visit [https://pool.braiins.com](https://pool.braiins.com)
2. Click "Sign Up" and create your account
3. Verify your email address
4. Set up your payout address (Bitcoin wallet)

### 2. Connection Details

**Braiins Pool Stratum URLs:**
```
stratum+tcp://stratum.braiins.com:3333
stratum+tcp://stratum.braiins.com:3336
```

**For secure connections (SSL):**
```
stratum+ssl://stratum.braiins.com:3334
stratum+ssl://stratum.braiins.com:3335
```

### 3. Worker Configuration

**Username Format:** `your_username.worker_name`
**Password:** Any password (commonly "x" or "123")

Example:
- Username: `john_doe.miner01`
- Password: `x`

## Mining Software Configuration Examples

### For BFGMiner
```bash
bfgminer.exe -o stratum+tcp://stratum.braiins.com:3333 -u your_username.worker_name -p x
```

### For CGMiner
```bash
cgminer.exe --scrypt -o stratum+tcp://stratum.braiins.com:3333 -u your_username.worker_name -p x
```

### For NiceHash Miner
1. Add new pool
2. Algorithm: SHA256
3. Pool Address: `stratum+tcp://stratum.braiins.com:3333`
4. Username: `your_username.worker_name`
5. Password: `x`

### For ASIC Miners (Web Interface)

1. Access your ASIC miner's web interface (usually http://192.168.1.X)
2. Navigate to Mining Configuration/Pool Settings
3. Add pools:
   - **Pool 1:** `stratum+tcp://stratum.braiins.com:3333`
   - **Pool 2:** `stratum+tcp://stratum.braiins.com:3336` (backup)
   - **Pool 3:** `stratum+ssl://stratum.braiins.com:3334` (SSL backup)
4. Worker: `your_username.worker_name`
5. Password: `x`

## Advanced Configuration

### Multiple Workers
You can create multiple workers for different mining rigs:
- `your_username.rig1`
- `your_username.rig2` 
- `your_username.antminer_s19`

### Failover Pools
Always configure backup pools to ensure continuous mining:

**Primary:** `stratum+tcp://stratum.braiins.com:3333`
**Backup 1:** `stratum+tcp://stratum.braiins.com:3336`
**Backup 2:** `stratum+ssl://stratum.braiins.com:3334`

### Monitoring Your Miners

1. Log into your Braiins Pool account at [https://pool.braiins.com](https://pool.braiins.com)
2. Navigate to "Workers" section
3. Monitor hashrate, shares, and earnings in real-time
4. Set up email notifications for offline workers

## Troubleshooting

### Common Issues

**Problem:** Miner not connecting to pool
**Solutions:**
- Check internet connection
- Verify username format: `username.worker_name`
- Try different stratum ports (3333, 3336)
- Check firewall settings

**Problem:** Low hashrate or rejected shares
**Solutions:**
- Check miner temperature and cooling
- Verify stable power supply
- Update miner firmware
- Try different stratum server

**Problem:** Workers showing as offline
**Solutions:**
- Check miner power and network connection
- Verify correct pool URL and credentials
- Restart mining software/hardware
- Check router/firewall configuration

### Network Configuration

**Required Ports:**
- TCP 3333 (Primary stratum)
- TCP 3336 (Backup stratum)
- TCP 3334 (SSL stratum)
- TCP 3335 (SSL stratum backup)

**Firewall Rules:**
Allow outbound connections on above ports to `stratum.braiins.com`

## Security Best Practices

1. **Use SSL connections** when possible for enhanced security
2. **Enable 2FA** on your Braiins Pool account
3. **Use strong passwords** for your pool account
4. **Regular monitoring** - check your workers daily
5. **Secure your payout address** - use a hardware wallet when possible

## Getting Help

### Official Braiins Resources
- **Website:** [https://braiins.com](https://braiins.com)
- **Pool Dashboard:** [https://pool.braiins.com](https://pool.braiins.com)
- **Support:** [https://help.braiins.com](https://help.braiins.com)
- **Discord:** [https://discord.gg/braiins](https://discord.gg/braiins)
- **Telegram:** [@BraiinsPool](https://t.me/BraiinsPool)

### Community Forums
- **Reddit:** r/BitcoinMining
- **BitcoinTalk:** Braiins Pool Thread

## Pool Statistics

Braiins Pool offers:
- **Low fees:** 2.5% pool fee
- **Transparent rewards:** Full reward transparency
- **Professional support:** 24/7 technical support
- **Global infrastructure:** Servers worldwide for low latency
- **Regular payouts:** Daily automatic payouts
- **No minimum:** No minimum payout threshold

## Additional Tools

This toolbox includes configuration templates and scripts to help you:
- Quickly configure multiple miners
- Monitor pool connection status
- Generate worker names automatically
- Set up automated monitoring and alerts

---

**Need help?** Join the Braiins community or contact their support team. Happy mining! ⛏️