# Fish DRY-Refactoring — Claude Code Kontext

> **Pfad:** `shared/etc/fish/CLAUDE.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-10
> **Aktualisiert:** 2026-03-01
> **Autor:** MR-ByteZ

> **Zweck:** Claude Code Kontext fuer Fish Shell Konfiguration

---

## Projekttyp

Fish Shell DRY-Refactoring — Umstellung von duplizierten Host-Configs auf ein
zentrales System mit Feature-Flags und Shared Conditionals.

## Wichtige Regeln

- **Fish-Syntax:** Kein `&&`, kein `export`, kein `$(cmd)`, kein Heredoc
- **command cat/grep:** Immer `command cat` und `command grep` verwenden
- **Alias-Sicherheit:** cat, ls, grep, df, du, rm, cp, mv = unveraenderte coreutils
- **Nummerierung:** 000-099 Shared, 100-200 Host-spezifisch, 5er-Schritte
- **Header:** Jede neue Datei bekommt den Standard-Header (scaffold-agent)
- **Version:** Neue Dateien starten bei 0.1.0

## Struktur

```
shared/etc/fish/
├── aliases/     Shared Aliases (010-055)
├── conf.d/      Loader (000) + Theme (005) + Host-Flags (008)
├── functions/   Prompt, Helpers
├── themes/      Gruvbox Theme
└── variables/   Pfade
```

## Referenzen

- Handoff: `.claude/context/handoffs/HANDOFF_Fish_Refactor_fish-dry-refactoring.md`
- Shell-Policies: `.claude/context/shell.md`
- Scaffold-Agent: `.claude/agents/scaffold-agent.md`
