# Migration — Fish DRY-Refactoring

> **Pfad:** `.claude/context/MIGRATION.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-28
> **Aktualisiert:** 2026-02-28
> **Autor:** MR-ByteZ
> **Zweck:** Vollstaendiges Alt→Neu Mapping aller Fish-Dateien

---

## Shared Aliases (git mv)

| Alt | Neu | Aenderung |
|-----|-----|-----------|
| aliases/10-nav.fish | aliases/010-nav.fish | Nummer + Alias-Umbenennung (rm→rmi, cp→cpi, mv→mvi) |
| aliases/20-eza.fish | aliases/015-eza.fish | Nummer + Alias-Umbenennung (ls→el) |
| aliases/30-docker.fish | aliases/020-docker.fish | Nur Nummer |
| aliases/40-git.fish | aliases/025-git.fish | Nur Nummer |
| aliases/50-systemd.fish | aliases/030-systemd.fish | Nur Nummer |
| aliases/60-pacman.fish | aliases/035-pacman.fish | Nur Nummer |
| aliases/65-fastfetch.fish | aliases/040-fastfetch.fish | Nur Nummer |
| aliases/90-misc.fish | aliases/045-misc.fish | Nummer + Alias-Umbenennung (cat→bcat, grep→rg, df→duf, du→dust) |

## Shared Conf.d (git mv)

| Alt | Neu |
|-----|-----|
| conf.d/00-loader.fish | conf.d/000-loader.fish |
| conf.d/00-theme.fish | conf.d/005-theme.fish |

## Shared Neu erstellen

| Datei | Inhalt | Quelle |
|-------|--------|--------|
| aliases/008-host-flags.fish | Feature-Flags (switch/case auf hostname) | NEU |
| aliases/050-gui.fish | GUI-Aliases (Flatpak, Power, Lock) | Merge aus 7x 70-desktop.fish |
| aliases/055-dev.fish | DEV-Aliases (rsync, rclone, curl helpers) | NEU |

## Host-Dateien — Entfallen

| Alt | Grund |
|-----|-------|
| variables/10-display.fish (6 Hosts) | → konsolidiert in 008-host-flags.fish |
| variables/10-host.fish (2 Hosts) | → konsolidiert in 008-host-flags.fish |
| aliases/70-desktop.fish (7 Hosts) | → ersetzt durch Shared 050-gui.fish |
| aliases/70-server.fish (n8-vps) | → entfaellt (Duplikate entfernen) |

## Host-Dateien — Umbenennung (git mv)

| Alt | Neu |
|-----|-----|
| aliases/80-n8-kiste.fish | aliases/110-n8-kiste.fish |
| aliases/80-n8-station.fish | aliases/110-n8-station.fish |
| aliases/80-n8-book.fish | aliases/110-n8-book.fish |
| aliases/80-n8-bookchen.fish | aliases/110-n8-bookchen.fish |
| aliases/80-n8-broker.fish | aliases/110-n8-broker.fish |
| aliases/80-n8-maxx.fish | aliases/110-n8-maxx.fish |
| aliases/80-n8-archstick.fish | aliases/110-n8-archstick.fish |
| aliases/80-n8-vps.fish | aliases/110-n8-vps.fish |

## Alias-Umbenennung (Inhaltlich)

| Original-Befehl | Alter Alias | Neuer Alias | Risiko |
|-----------------|-------------|-------------|--------|
| cat | cat (→bat) | bcat | HOCH |
| ls | ls (→eza) | el | HOCH |
| grep | grep (→rg) | rg | HOCH |
| df | df (→duf) | duf | HOCH |
| du | du (→dust) | dust | HOCH |
| rm | rm (→rm -Iv) | rmi | MITTEL |
| cp | cp (→cp -iv) | cpi | MITTEL |
| mv | mv (→mv -iv) | mvi | MITTEL |

**Regel:** cat, ls, grep, df, du, rm, cp, mv = unveraenderte coreutils nach Migration.

## Referenzen

- Architektur: `.claude/context/ARCHITEKTUR.md`
- Handoff: `.claude/context/handoffs/HANDOFF_Fish_Refactor_fish-dry-refactoring_v3.md`
