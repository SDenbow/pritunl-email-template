# Pritunl Email Template Helper

A standalone administration utility that safely adds a configurable VPN setup-guide link to Pritunl user onboarding emails.

Pritunl stores its onboarding templates in its installed Python package. Package upgrades can replace those files and remove local customizations. This project provides a repeatable, idempotent way to check and reapply the customization after an upgrade without tying it to operating-system or Pritunl maintenance scripts.

## Features

- Updates both `KEY_LINK_EMAIL_TEXT` and `KEY_LINK_EMAIL_HTML`
- Preserves Pritunl's `{key_link}` and `{uri_link}` placeholders
- Dynamically locates the active `constants.py`
- Fails closed when the expected template structure is missing or ambiguous
- Creates timestamped backups before each change
- Validates Python syntax before replacing the live file
- Writes changes atomically
- Detects an existing managed block and updates it without duplication
- Supports check-only, noninteractive, restore, and optional restart modes

## Install from Git

```bash
git clone https://github.com/SDenbow/pritunl-email-template.git
cd pritunl-email-template
sudo ./install.sh
```

The command is installed at `/usr/local/sbin/pritunl-email-template`.

For production deployment, use a reviewed tag or pinned commit rather than automatically executing an unreviewed branch.

## Use

Interactive:

```bash
sudo pritunl-email-template
```

Check without changing anything:

```bash
sudo pritunl-email-template --check
```

Apply a specific URL without restarting Pritunl:

```bash
sudo pritunl-email-template \
  --url https://support.example.com/vpn \
  --no-restart
```

Apply and restart without prompts:

```bash
sudo pritunl-email-template \
  --url https://support.example.com/vpn \
  --restart \
  --yes
```

List backups:

```bash
sudo pritunl-email-template --list-backups
```

Restore a backup:

```bash
sudo pritunl-email-template \
  --restore /root/pritunl-email-template-backups/constants.py.2026-07-24-143015
```

## Recommended Pritunl upgrade workflow

```bash
sudo apt update
sudo apt upgrade pritunl
sudo pritunl-email-template --check
sudo pritunl-email-template
```

A Pritunl restart can interrupt existing VPN connections. The utility therefore asks before restarting unless `--restart` or `--no-restart` is supplied.

## Resulting email content

Plain text:

```text
Need help setting up your VPN?
VPN Setup Guide: https://support.example.com/vpn
```

HTML:

```html
<p><strong>Need help setting up your VPN?</strong><br>
<a href="https://support.example.com/vpn">View the VPN Setup Guide</a></p>
```

## Backups and restore warning

Backups are stored in `/root/pritunl-email-template-backups/` and are not automatically deleted.

A backup is a complete copy of Pritunl's `constants.py`. Do not restore a backup from a different Pritunl release without reviewing it; an older complete module may not be compatible with the installed version.

## Uninstall

```bash
sudo ./uninstall.sh
```

Uninstalling removes only the installed command. It does not revert the current Pritunl templates and does not delete backups.

## Requirements

- Linux server running Pritunl
- Root access
- Python 3
- systemd for optional restart handling

## License

MIT License. See [LICENSE](LICENSE).
