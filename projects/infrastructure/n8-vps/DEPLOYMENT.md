# n8-vps — Deployment

> **Pfad:** `projects/infrastructure/n8-vps/DEPLOYMENT.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Deployment-Anleitung fuer n8-vps Host

---

## SSH-Zugang

```
ssh mrohwer@n8-vps -p 61020
```

- Key-Only (Password disabled)
- SSH-Config: via Secrets-Repo (`.secrets/mrohwer/shared/home/mrohwer/.ssh/config`)
- User: `mrohwer` (sudo NOPASSWD, wheel-Gruppe)

---

## Read-Only Regel

**n8-vps ist read-only fuer Git!**
- Kein `git commit` auf n8-vps
- Kein `git push` auf n8-vps
- Commits nur auf n8-kiste, dann `git pull` auf n8-vps

---

## git pull Workflow

```fish
# Hauptrepo
cd /mr-bytez
git pull origin main

# Secrets-Submodule
cd .secrets
git pull origin main
cd /mr-bytez
```

---

## deploy.fish ausfuehren

```fish
# Secrets deployen (Symlinks, SSH-Keys, .gitconfig)
cd /mr-bytez/.secrets
fish deploy.fish

# Full-Bootstrap (Pakete + Secrets + Symlinks)
fish deploy.fish --full
```

→ Details: `.secrets/deploy.fish --help`

---

## Stacks deployen

```fish
# Traefik (bereits deployed)
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik
docker compose up -d

# Neue Stacks analog
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/<stackname>
docker compose up -d
```

→ Stack-Details: `stacks/<stackname>/DEPLOYMENT.md`

---

## Verwandte Docs

- Root: `DEPLOYMENT.md` (Globaler Deployment-Guide, Anker-System)
- Traefik: `stacks/traefik/DEPLOYMENT.md`
- Secrets: `.secrets/RECOVERY.md` (Disaster Recovery)
