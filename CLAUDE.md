# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is mr-bytez?

Personal infrastructure meta-repository for managing a reproducible, multi-host Arch Linux setup. Single source of truth at `/mr-bytez` with a stable system anchor at `/opt/mr-bytez/current -> /mr-bytez`. All system symlinks reference the anchor, not the checkout directly.

**Language:** All documentation is in German. Commit messages, docs, and comments should be in German unless the user specifies otherwise.

## Repository Structure

- `shared/` — Shared configs deployed to all hosts (Fish shell, Micro editor, SSH templates, secrets submodule)
- `projects/infrastructure/<hostname>/` — Per-host configs for 8 physical hosts (n8-kiste, n8-station, n8-vps, n8-book, n8-bookchen, n8-maxx, n8-broker, n8-archstick)
- `projects/web/` — Web projects (gitignored)
- `scripts/` — Automation scripts (hwi hardware info, scan-secrets.fish)
- `shared/deployment/symlinks.db` — JSON database of all deployable symlinks
- `.claude/plans/` — Architecture decision records and implementation plans

## Key Architecture

### Fish Shell Config (shared/etc/fish/)

Hierarchical loader system (`conf.d/00-loader.fish`) with priority-based override:
- `00-09` — Theme + base (shared only)
- `10-69` — Shared aliases/variables, then host-specific
- `70-79` — Host category overrides (Desktop/Server)
- `80-89` — Host-specific overrides (highest)
- `90-99` — User tweaks

Debug mode: `set -x FISH_LOADER_DEBUG 1`

Theme system (`conf.d/00-theme.fish`): Gruvbox-based with semantic color variables (`theme_primary`, `theme_error`, etc.) and helper functions (`__msg`, `__success`, `__warn`, `__error`, `__header`).

### Symlink Deployment

All system symlinks go through the stable anchor:
```
/etc/fish -> /opt/mr-bytez/current/shared/etc/fish
/usr/local/share/micro -> /opt/mr-bytez/current/shared/usr/local/share/micro
```

Forbidden: deploying `~/.ssh/config` (template only), SSH private keys, user state files.

### Secrets

Private submodule at `shared/home/mrohwer/.secrets/` — Age-encrypted only, never plaintext in main repo, never symlinked to system.

## Mandatory Policies

### Fish-First

Fish is the reference shell. No bash heredocs (`cat <<EOF`). Use `printf '%s\n' ... > file` for file generation. All shell examples must be in Fish syntax.

### cat/bat Alias Trap

`cat` may be aliased to `bat`. When reading tokens/keys, always use `command cat` or `/usr/bin/cat`. Sanitize with: `string replace -a \r '' | string trim`

### Git Commit Format

```
[Category1][Category2] Concise descriptive message

- Detail 1
- Detail 2
```

Categories: `[Docs]`, `[Config]`, `[Fish]`, `[Docker]`, `[Security]`, `[Fix]`, `[Feature]`, `[Refactor]`, `[Deploy]`, `[Test]`, `[Release]`, `[Submodule]`, `[Cleanup]`, `[Hotfix]`

Commits must answer: **what** changed, **why**, and **where**. Vague messages like `[Fix] Fixed bug` or `[Docs] Update` are not acceptable.

### Git Remotes & Push

Two remotes: `origin` (GitHub) and `codeberg` (Codeberg mirror). Push to both:
```fish
git push origin main && git push codeberg main
```

All commits must be made on **n8-kiste** only. n8-vps is read-only (`git pull` only).

### Documentation Workflow

When changing configs, deployment, security policies, or repo structure: update docs **first** in the same session, then commit. Affected files: README.md, DEPLOYMENT.md, PROJECT_NOTES.md, CHANGELOG.md. Central markdown files are **additive only** — no removals without explicit permission.

## Key Reference Files

- `PROJECT_NOTES.md` — All repo policies and working conventions (read this for detailed rules)
- `DEPLOYMENT.md` — Full deployment guide with 9-step quickstart
- `ROADMAP.md` — Current priorities and phase planning
- `CHANGELOG.md` — Version history (currently v0.6.1)

## Current Development Priority

Claude Development Container (Docker Stack) — highest priority, no dependencies, ready to start. Architecture documented in `.claude/plans/mrbz-dev-plan.md`.
