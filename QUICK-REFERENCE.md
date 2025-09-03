# Braiins Pool Quick Reference Card

## Essential Connection Details

| Setting | Value |
|---------|-------|
| **Pool URL (Primary)** | `stratum+tcp://stratum.braiins.com:3333` |
| **Pool URL (Backup)** | `stratum+tcp://stratum.braiins.com:3336` |
| **Pool URL (SSL)** | `stratum+ssl://stratum.braiins.com:3334` |
| **Username Format** | `your_username.worker_name` |
| **Password** | `x` (or any value) |
| **Pool Fee** | 2.5% |

## Quick Commands

### BFGMiner
```bash
bfgminer.exe -o stratum+tcp://stratum.braiins.com:3333 -u username.worker -p x
```

### CGMiner
```bash
cgminer.exe -o stratum+tcp://stratum.braiins.com:3333 -u username.worker -p x
```

### Connection Test
```cmd
ping stratum.braiins.com
telnet stratum.braiins.com 3333
```

## Required Firewall Ports
- **3333** (Primary)
- **3336** (Backup)
- **3334** (SSL Primary)
- **3335** (SSL Backup)

## Important URLs
- **Pool Dashboard:** https://pool.braiins.com
- **Support:** https://help.braiins.com
- **Discord:** https://discord.gg/braiins

## Worker Naming Tips
- Use descriptive names: `username.antminer_s19_garage`
- Keep it simple: `username.rig1`
- Avoid spaces and special characters

## Emergency Checklist
- [ ] Check internet connection
- [ ] Verify pool URLs
- [ ] Confirm username format
- [ ] Test with backup pool
- [ ] Check firewall settings
- [ ] Review miner logs