# mrbz_aud — Modul 01: Struktur-Inventar

**Datum:** 2026-03-06
**Status:** OK

## Zusammenfassung

Vollstaendiges Inventar aller relevanten Dateien im mr-bytez Repository erstellt.
132 Dateien im Hauptrepo und 121 Dateien im Secrets-Repo erfasst.
Keine strukturellen Auffaelligkeiten festgestellt.

## Inventar — Hauptrepo

### Uebersicht nach Dateityp

| Typ | Anzahl |
|-----|--------|
| .md | 66 |
| .fish | 52 |
| .sh | 9 |
| .txt | 5 |
| .info | 0 |
| **Gesamt** | **132** (ohne projects/web/, .secrets/, mrbz_aud/reports/) |

### Uebersicht nach Bereich

| Bereich | Anzahl |
|---------|--------|
| Root (/) | 5 |
| .claude/ | 42 |
| projects/infrastructure/ | 31 |
| shared/ | 53 |
| scripts/ | 1 |

### Dateien — Root

| Datum | Pfad |
|-------|------|
| 2026-03-06 | CHANGELOG.md |
| 2026-03-05 | CLAUDE.md |
| 2026-03-05 | DEPLOYMENT.md |
| 2026-03-05 | README.md |
| 2026-03-06 | ROADMAP.md |

### Dateien — .claude/

| Datum | Pfad |
|-------|------|
| 2026-03-06 | .claude/agents/bot/mrbz_aud/mrbz_aud-agent_audit.md |
| 2026-03-06 | .claude/agents/bot/mrbz_aud/mrbz_aud-agent_fix.md |
| 2026-03-06 | .claude/agents/bot/mrbz_aud/mrbz_aud-agent_verify.md |
| 2026-03-06 | .claude/agents/bot/mrbz_aud/mrbz_aud-orchestrator.fish |
| 2026-03-06 | .claude/agents/bot/mrbz_aud/mrbz_aud-README.md |
| 2026-03-01 | .claude/agents/manual/audit-agent.md |
| 2026-03-03 | .claude/agents/manual/deploy-agent.md |
| 2026-02-28 | .claude/agents/manual/docs-agent.md |
| 2026-03-03 | .claude/agents/manual/scaffold-agent.md |
| 2026-02-10 | .claude/archive/migration.md |
| 2026-02-10 | .claude/archive/mrbz-dev-plan.md |
| 2026-03-06 | .claude/CHANGELOG.md |
| 2026-03-06 | .claude/CLAUDE.md |
| 2026-02-28 | .claude/context/ARCHITEKTUR.md |
| 2026-03-05 | .claude/context/claude-ai-projektanweisungen.txt |
| 2026-03-03 | .claude/context/claude-ai-user-preferences.txt |
| 2026-03-03 | .claude/context/deployment.md |
| 2026-02-10 | .claude/context/docker.md |
| 2026-03-05 | .claude/context/documentation.md |
| 2026-02-27 | .claude/context/git.md |
| 2026-02-11 | .claude/context/handoffs/HANDOFF_[Learn][Stack]_mr-bytez-learn-projektplan.md |
| 2026-03-06 | .claude/context/handoffs/HANDOFF_[VPS][SEC]_crowdsec-traefik-authentik-deployment.md |
| 2026-02-28 | .claude/context/HOST_MATRIX.md |
| 2026-03-05 | .claude/context/infrastructure.md |
| 2026-02-11 | .claude/context/integration.md |
| 2026-02-28 | .claude/context/MIGRATION.md |
| 2026-03-05 | .claude/context/policies.md |
| 2026-03-03 | .claude/context/security.md |
| 2026-03-03 | .claude/context/shell.md |
| 2026-03-06 | .claude/context/structure.md |
| 2026-03-05 | .claude/context/tags.md |
| 2026-02-25 | .claude/context/versioning.md |
| 2026-03-05 | .claude/context/webfetch-domains.md |
| 2026-02-28 | .claude/hooks/bash-command-logger.sh |
| 2026-02-28 | .claude/hooks/dual-push-reminder.sh |
| 2026-02-28 | .claude/hooks/fish-syntax-guard.sh |
| 2026-02-28 | .claude/hooks/handoff-lifecycle-check.sh |
| 2026-03-05 | .claude/hooks/pre-commit-docs-check.sh |
| 2026-03-03 | .claude/hooks/secrets-guard.sh |
| 2026-02-28 | .claude/hooks/session-start-info.sh |
| 2026-03-05 | .claude/README.md |
| 2026-03-05 | .claude/ROADMAP.md |

### Dateien — projects/infrastructure/

| Datum | Pfad |
|-------|------|
| 2026-02-28 | projects/infrastructure/n8-archstick/root/home/mrohwer/.config/fish/aliases/110-n8-archstick.fish |
| 2026-02-08 | projects/infrastructure/n8-archstick/root/home/mrohwer/.config/fish/functions/n8archstick-test.fish |
| 2026-02-28 | projects/infrastructure/n8-book/root/home/mrohwer/.config/fish/aliases/110-n8-book.fish |
| 2026-02-02 | projects/infrastructure/n8-book/root/home/mrohwer/.config/fish/functions/n8-book-test.fish |
| 2026-02-28 | projects/infrastructure/n8-bookchen/root/home/mrohwer/.config/fish/aliases/110-n8-bookchen.fish |
| 2026-02-02 | projects/infrastructure/n8-bookchen/root/home/mrohwer/.config/fish/functions/n8-bookchen-test.fish |
| 2026-02-28 | projects/infrastructure/n8-broker/root/home/mrohwer/.config/fish/aliases/110-n8-broker.fish |
| 2026-02-02 | projects/infrastructure/n8-broker/root/home/mrohwer/.config/fish/functions/n8-broker-test.fish |
| 2026-02-17 | projects/infrastructure/n8-kiste/HARDWARE.md |
| 2026-02-28 | projects/infrastructure/n8-kiste/root/home/mrohwer/.config/fish/aliases/110-n8-kiste.fish |
| 2026-02-02 | projects/infrastructure/n8-kiste/root/home/mrohwer/.config/fish/functions/n8-kiste-test.fish |
| 2026-02-28 | projects/infrastructure/n8-maxx/root/home/mrohwer/.config/fish/aliases/110-n8-maxx.fish |
| 2026-02-02 | projects/infrastructure/n8-maxx/root/home/mrohwer/.config/fish/functions/n8-maxx-test.fish |
| 2026-02-06 | projects/infrastructure/n8-station/HARDWARE.md |
| 2026-02-28 | projects/infrastructure/n8-station/root/home/mrohwer/.config/fish/aliases/110-n8-station.fish |
| 2026-02-02 | projects/infrastructure/n8-station/root/home/mrohwer/.config/fish/functions/n8-station-test.fish |
| 2026-03-06 | projects/infrastructure/n8-vps/CHANGELOG.md |
| 2026-03-05 | projects/infrastructure/n8-vps/.claude/CLAUDE.md |
| 2026-03-05 | projects/infrastructure/n8-vps/.claude/context/hardware.md |
| 2026-03-04 | projects/infrastructure/n8-vps/DEPLOYMENT.md |
| 2026-03-05 | projects/infrastructure/n8-vps/docs/n8-vps-server-dokumentation.md |
| 2026-03-05 | projects/infrastructure/n8-vps/README.md |
| 2026-03-05 | projects/infrastructure/n8-vps/ROADMAP.md |
| 2026-02-28 | projects/infrastructure/n8-vps/root/home/mrohwer/.config/fish/aliases/110-n8-vps.fish |
| 2026-02-02 | projects/infrastructure/n8-vps/root/home/mrohwer/.config/fish/functions/n8-vps-test.fish |
| 2026-03-05 | projects/infrastructure/n8-vps/stacks/authentik/DEPLOYMENT.md |
| 2026-03-05 | projects/infrastructure/n8-vps/stacks/authentik/README.md |
| 2026-03-04 | projects/infrastructure/n8-vps/stacks/crowdsec/DEPLOYMENT.md |
| 2026-03-04 | projects/infrastructure/n8-vps/stacks/crowdsec/README.md |
| 2026-03-02 | projects/infrastructure/n8-vps/stacks/traefik/DEPLOYMENT.md |
| 2026-03-02 | projects/infrastructure/n8-vps/stacks/traefik/README.md |

### Dateien — shared/

| Datum | Pfad |
|-------|------|
| 2026-03-03 | shared/deployment/derive_key.fish |
| 2026-03-03 | shared/deployment/derive_key.README.md |
| 2026-03-03 | shared/deployment/generate_pwd.fish |
| 2026-03-03 | shared/deployment/pack-secrets.fish |
| 2026-03-03 | shared/deployment/unpack-secrets.fish |
| 2026-03-04 | shared/etc/claude-code/statusline.sh |
| 2026-02-28 | shared/etc/fish/aliases/010-nav.fish |
| 2026-02-28 | shared/etc/fish/aliases/015-eza.fish |
| 2026-02-28 | shared/etc/fish/aliases/020-docker.fish |
| 2026-02-28 | shared/etc/fish/aliases/025-git.fish |
| 2026-02-28 | shared/etc/fish/aliases/030-systemd.fish |
| 2026-02-28 | shared/etc/fish/aliases/035-pacman.fish |
| 2026-03-03 | shared/etc/fish/aliases/040-fastfetch.fish |
| 2026-02-28 | shared/etc/fish/aliases/045-misc.fish |
| 2026-02-28 | shared/etc/fish/aliases/050-gui.fish |
| 2026-02-28 | shared/etc/fish/aliases/055-dev.fish |
| 2026-03-05 | shared/etc/fish/CHANGELOG.md |
| 2026-03-05 | shared/etc/fish/CLAUDE.md |
| 2026-02-28 | shared/etc/fish/conf.d/000-loader.fish |
| 2026-03-03 | shared/etc/fish/conf.d/005-theme.fish |
| 2026-02-28 | shared/etc/fish/conf.d/008-host-flags.fish |
| 2026-03-05 | shared/etc/fish/conf.d/010-ulimits.fish |
| 2026-03-01 | shared/etc/fish/DEPLOYMENT.md |
| 2026-02-28 | shared/etc/fish/functions/fish_greeting.fish |
| 2026-02-28 | shared/etc/fish/functions/fish_mode_prompt.fish |
| 2026-02-28 | shared/etc/fish/functions/fish_prompt.fish |
| 2026-02-28 | shared/etc/fish/functions/fish_right_prompt.fish |
| 2026-03-03 | shared/etc/fish/functions/host-test.fish |
| 2026-03-01 | shared/etc/fish/functions/mr-bytez-info.fish |
| 2026-02-28 | shared/etc/fish/functions/__mr_docker_status.fish |
| 2026-02-28 | shared/etc/fish/functions/__mr_git_status.fish |
| 2026-02-28 | shared/etc/fish/functions/__mr_host_color.fish |
| 2026-02-28 | shared/etc/fish/functions/__mr_smart_pwd.fish |
| 2026-02-28 | shared/etc/fish/functions/theme.fish |
| 2026-03-01 | shared/etc/fish/README.md |
| 2026-03-04 | shared/etc/fish/ROADMAP.md |
| 2026-03-01 | shared/etc/fish/skills/DEBUGGING.md |
| 2026-03-01 | shared/etc/fish/skills/NEUER_HOST.md |
| 2026-03-01 | shared/etc/fish/skills/NEUES_CONDITIONAL.md |
| 2026-03-04 | shared/etc/fish/themes/mr-bytez.fish |
| 2026-02-28 | shared/etc/fish/variables/010-paths.fish |
| 2026-03-03 | shared/home/mrohwer/.config/fish/config.fish |
| 2026-02-28 | shared/lib/banner.fish |
| 2026-03-04 | shared/lib/format.fish |
| 2026-03-03 | shared/packages/desktop-packages.txt |
| 2026-02-28 | shared/packages/dev-packages.txt |
| 2026-03-04 | shared/packages/min-packages.txt |
| 2026-02-17 | shared/usr/local/bin/hwi/CHANGELOG.md |
| 2026-02-17 | shared/usr/local/bin/hwi/CLAUDE.md |
| 2026-02-17 | shared/usr/local/bin/hwi/DEPLOYMENT.md |
| 2026-03-04 | shared/usr/local/bin/hwi/hwi.sh |
| 2026-02-17 | shared/usr/local/bin/hwi/README.md |
| 2026-03-05 | shared/usr/local/bin/hwi/ROADMAP.md |

### Dateien — scripts/

| Datum | Pfad |
|-------|------|
| 2026-03-03 | scripts/scan-secrets.fish |

## Inventar — Secrets-Repo

### Uebersicht

| Bereich | Anzahl |
|---------|--------|
| Root (.secrets/) | 11 |
| n8-kiste | 8 |
| n8-station | 6 |
| n8-vps | 77 |
| shared | 19 |
| **Gesamt** | **121** (ohne .git/) |

### Dateien — .secrets/ Root

| Datum | Pfad |
|-------|------|
| 2026-03-04 | .secrets/CHANGELOG.md |
| 2026-03-03 | .secrets/CLAUDE.md |
| 2026-03-04 | .secrets/deploy.fish |
| 2026-03-03 | .secrets/deployment/symlinks.db |
| 2026-02-24 | .secrets/domains.csv |
| 2026-02-24 | .secrets/.gitignore |
| 2026-03-04 | .secrets/mrohwer.tar.age |
| 2026-03-03 | .secrets/README.md |
| 2026-03-03 | .secrets/RECOVERY.md |
| 2026-03-04 | .secrets/ROADMAP.md |
| 2026-03-03 | .secrets/SECRETS.md |

### Dateien — .secrets/mrohwer/infrastructure/n8-kiste/

| Datum | Pfad |
|-------|------|
| 2026-02-25 | etc/hosts |
| 2026-02-25 | home/mrohwer/.ssh/authorized_keys |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519 |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_forgejo |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_forgejo.pub |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519.pub |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_tinyssh_unlock |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_tinyssh_unlock.pub |

### Dateien — .secrets/mrohwer/infrastructure/n8-station/

| Datum | Pfad |
|-------|------|
| 2026-02-25 | etc/hosts |
| 2026-02-25 | home/mrohwer/.ssh/authorized_keys |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519 |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_forgejo |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_forgejo.pub |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519.pub |

### Dateien — .secrets/mrohwer/infrastructure/n8-vps/

| Bereich | Anzahl |
|---------|--------|
| etc/hosts | 1 |
| .ssh/ | 1 |
| backup/ | 7 |
| cloud/cloudflare/ | 8 |
| cloud/hetzner/ | 21 |
| databases/ | 1 |
| services/adguard/ | 2 |
| services/authentik/ | 18 |
| services/crowdsec/ | 4 |
| services/nextcloud/ | 2 |
| services/portainer/ | 1 |
| services/traefik/ | 1 |
| services/watchtower/ | 1 |
| ssl/ | 5 |
| vpn/ | 4 |
| **Gesamt n8-vps** | **77** |

### Dateien — .secrets/mrohwer/shared/

| Datum | Pfad |
|-------|------|
| 2026-02-24 | home/mrohwer/.gitconfig |
| 2026-02-25 | home/mrohwer/.secrets/ai/mr-bytez_deepseek_api_key.secret |
| 2026-02-25 | home/mrohwer/.secrets/api/codeberg.token |
| 2026-02-25 | home/mrohwer/.secrets/api/github.token |
| 2026-02-25 | home/mrohwer/.secrets/cloud/codeberg/m.rohwer@mr-bytez.de |
| 2026-02-25 | home/mrohwer/.secrets/cloud/protonmail/protonmail_wiederherstellungs.secret |
| 2026-02-25 | home/mrohwer/.secrets/cloud/rclone/rclone_config_password.secret |
| 2026-03-03 | home/mrohwer/.secrets/cloud/rclone/README.md |
| 2026-03-03 | home/mrohwer/.secrets/licenses/README.md |
| 2026-03-03 | home/mrohwer/.secrets/licenses/tinymediamanager/README.md |
| 2026-02-25 | home/mrohwer/.secrets/licenses/tinymediamanager/tmm_license.license |
| 2026-02-25 | home/mrohwer/.secrets/personal/edge_browser_passwords.ods.age |
| 2026-02-25 | home/mrohwer/.secrets/tools/generate_bcrypt_hash |
| 2026-02-25 | home/mrohwer/.secrets/vpn/mullvad/mullvad_vpn_login.id |
| 2026-02-25 | home/mrohwer/.ssh/config |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_codeberg |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_codeberg.pub |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_github |
| 2026-02-25 | home/mrohwer/.ssh/id_ed25519_github.pub |

## Findings

Keine Findings. Das Inventar dient als Basis fuer die weiteren Module.

## Statistik

- Gepruefte Dateien: 253 (132 Hauptrepo + 121 Secrets)
- Findings: 0 (0 KRITISCH, 0 MITTEL, 0 INFO, 0 NEEDS_REVIEW)
