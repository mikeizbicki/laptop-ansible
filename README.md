# Laptop Configuration Management

An automated system for maintaining consistent software and configurations across multiple Debian laptops using Ansible in pull mode.

## Install

Run this command on each laptop you want to manage:

```bash
curl -fsSL https://raw.githubusercontent.com/mikeizbicki/laptop-ansible/master/install.sh | bash
```

This command will:
- install ansible
- run ansible-pull on this repo
- setup cron to run ansible-pull hourly

## Manual updates

You can trigger a manual update (instead of waiting for cron) with the following command:
```
ansible-pull -U https://github.com/mikeizbicki/laptop-ansible
```
