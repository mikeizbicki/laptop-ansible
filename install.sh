#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/mikeizbicki/laptop-ansible"
CRON_JOB="0 * * * * /usr/bin/ansible-pull -U $REPO_URL > /var/log/ansible-pull.log 2>&1"
TEMP_CRON="/tmp/cron_backup.$$"

echo "Installing ansible laptop configuration..."

# Install required packages (idempotent)
echo "Installing/updating required packages..."
sudo apt-get update -qq
sudo apt-get install -y ansible git

# Test ansible-pull once to verify setup
echo "Testing ansible-pull..."
ansible-pull -U "$REPO_URL" --check

# Backup current crontab (atomic operation)
echo "Setting up cron job..."
crontab -l > "$TEMP_CRON" 2>/dev/null || touch "$TEMP_CRON"

# Check if cron job already exists (idempotent)
if ! grep -Fq "ansible-pull -U $REPO_URL" "$TEMP_CRON"; then
    echo "Adding ansible-pull cron job..."
    echo "$CRON_JOB" >> "$TEMP_CRON"
    crontab "$TEMP_CRON"
    echo "Cron job added successfully"
else
    echo "Cron job already exists, skipping..."
fi

# Clean up temp file
rm -f "$TEMP_CRON"

# Run initial sync
echo "Running initial configuration sync..."
ansible-pull -U "$REPO_URL"

echo "Installation complete! Ansible will now run hourly via cron."

