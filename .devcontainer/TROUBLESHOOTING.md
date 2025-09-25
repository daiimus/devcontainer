# Evennia + BlightMUD Devcontainer Troubleshooting Guide

This guide helps diagnose and fix common issues with the Evennia + BlightMUD devcontainer.

## Quick Diagnostics

Run the diagnostic script to get a comprehensive system check:
```bash
.devcontainer/diagnostics.sh
```

This will create a detailed log in `~/devcontainer-logs/` with all system information.

## Common Issues and Solutions

### 1. Container Fails to Start

**Symptoms:** Codespace creation fails, container won't build, or build times out

**Solutions:**
- Check if Docker build logs show memory issues
- Try creating the Codespace with more resources (4-core machine type)
- Review the Dockerfile build stages - Rust compilation is memory-intensive

**Debug Commands:**
```bash
# Check available memory during build
free -h

# Monitor build logs
docker build --progress=plain .devcontainer/
```

### 2. BlightMUD Not Found

**Symptoms:** `blightmud` command not found, or BlightMUD fails to start

**Solutions:**
- Verify Rust toolchain: `rustc --version`
- Check if BlightMUD binary exists: `ls -la /usr/local/bin/blightmud`
- Rebuild the container if BlightMUD compilation failed

**Debug Commands:**
```bash
# Check Rust installation
cargo --version

# Try to rebuild BlightMUD manually
cd /tmp && git clone https://github.com/blightmud/blightmud.git
cd blightmud && cargo build --release
```

### 3. Evennia Import Errors

**Symptoms:** `ImportError: No module named 'evennia'`, Python import failures

**Solutions:**
- Reinstall Evennia: `pip install --user --force-reinstall evennia`
- Check Python path: `echo $PYTHONPATH`
- Verify Python version: `python --version` (should be 3.11+)

**Debug Commands:**
```bash
# Check installed packages
pip list | grep evennia

# Test Evennia import
python -c "import evennia; print(evennia.__version__)"
```

### 4. Gelatinous Repository Issues

**Symptoms:** Project not cloned, Git authentication errors, missing files

**Solutions:**
- Manually clone: `git clone https://github.com/daiimus/gelatinous.git ~/workspace/gelatinous`
- Check network connectivity: `ping github.com`
- Verify Git configuration: `git config --list`

**Debug Commands:**
```bash
# Check repository status
cd ~/workspace/gelatinous && git status

# Re-run setup
.devcontainer/setup.sh
```

### 5. Port Forwarding Issues

**Symptoms:** Can't access Evennia web interface, connection refused errors

**Solutions:**
- Check if Evennia is running: `ps aux | grep evennia`
- Verify ports are listening: `netstat -tlnp | grep 4000`
- Start Evennia manually: `cd ~/workspace/gelatinous && evennia start`

**Debug Commands:**
```bash
# Check all listening ports
netstat -tlnp

# Test local connection
telnet localhost 4000
```

### 6. Database Migration Errors

**Symptoms:** Django migration errors, database locked, schema issues

**Solutions:**
- Run migrations manually: `cd ~/workspace/gelatinous && evennia migrate`
- Reset database if corrupted: `rm evennia.db && evennia migrate`
- Check Django settings: `evennia check`

**Debug Commands:**
```bash
# Check migration status
cd ~/workspace/gelatinous
evennia showmigrations

# View Evennia logs
evennia log
```

## Log Files

All setup and diagnostic logs are stored in `~/devcontainer-logs/`:

- `setup.log` - Main setup script output
- `diagnostics-*.log` - System diagnostic reports
- `lifecycle.log` - Container lifecycle events
- `system-packages.log` - Package installation log
- `rust-install.log` - Rust toolchain installation
- `blightmud-*.log` - BlightMUD build logs
- `evennia-install.log` - Evennia installation log

## Recovery Commands

If the environment gets corrupted, try these recovery steps:

1. **Reset Python environment:**
```bash
pip install --user --force-reinstall evennia
```

2. **Re-clone Gelatinous:**
```bash
rm -rf ~/workspace/gelatinous
cd ~/workspace
git clone https://github.com/daiimus/gelatinous.git
```

3. **Reset Evennia database:**
```bash
cd ~/workspace/gelatinous
rm -f evennia.db
evennia migrate
```

4. **Full container rebuild:**
- In VS Code: Command Palette → "Dev Containers: Rebuild Container"
- Or destroy and recreate the Codespace

## Performance Optimization

For slow containers or build issues:

1. **Reduce build parallelism:**
   - Dockerfile already limits Cargo jobs to 2
   - Consider reducing further if memory-constrained

2. **Use pre-built images:**
   - Consider pushing built image to registry
   - Use as base image to skip compilation

3. **Split build stages:**
   - Current multi-stage build helps with caching
   - Intermediate stages can be cached separately

## Getting Help

When reporting issues, include:

1. Output from `.devcontainer/diagnostics.sh`
2. Relevant log files from `~/devcontainer-logs/`
3. Steps to reproduce the problem
4. Codespace machine type and specifications

## Manual Setup Alternative

If the automated setup fails, you can set up manually:

```bash
# Install Evennia
pip install --user evennia

# Clone project
git clone https://github.com/daiimus/gelatinous.git ~/workspace/gelatinous

# Setup Evennia
cd ~/workspace/gelatinous
evennia migrate

# Install BlightMUD (if binary missing)
curl -L https://github.com/blightmud/blightmud/releases/latest/download/blightmud-linux.tar.gz | tar xz
sudo mv blightmud /usr/local/bin/
```

This troubleshooting guide should help identify and resolve most common issues with the devcontainer setup.