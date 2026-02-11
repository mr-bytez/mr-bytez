# HANDOFF: Context-Dateien Audit + Opus 4.6 Tooling-Hinweise

## Kontext

Die Context-Dateien in `.claude/context/` sind seit ~3 Tagen nicht aktualisiert worden.
In dieser Zeit wurde viel verändert (Handoff-Policy, Tags, Chat-Benennung v2, Struktur-Umbau).
Gleichzeitig sollen Opus 4.6 Tooling-Hinweise an der richtigen Stelle ergänzt werden.

Chat: https://claude.ai/chat/f5dc8dc4-fa86-4603-93f0-b8d36a2e729f

---

## Aufgabe — 3 Phasen (Schritt für Schritt!)

### Phase 1: Auswerten (ERST DAS — dann Output zeigen und besprechen!)

1. **Git-Log auswerten** der letzten 3 Tage:
   ```fish
   git log --oneline --since="3 days ago" --stat
   ```

2. **Ist-Zustand** der Context-Dateien prüfen:
   - `.claude/context/structure.md` — stimmt die Struktur noch mit dem Repo überein?
   - `.claude/context/infrastructure.md` — sind alle Hosts/Deployments aktuell?
   - Alle anderen `context/*.md` Dateien auf Aktualität prüfen

3. **Delta ermitteln**: Was wurde committed aber NICHT in den Context-Dateien dokumentiert?
   - Neue Dateien/Ordner die in structure.md fehlen
   - Neue Policies die in den Context-Dateien fehlen
   - Veraltete Verweise oder falsche Pfade

4. **Opus 4.6 Tooling**: Welche Context-Datei ist der richtige Ort?
   - infrastructure.md? Neue tooling.md? Woanders?

**STOPP nach Phase 1 — Ergebnisse zeigen und mit User besprechen!**

### Phase 2: Diskutieren

- Delta-Liste durchgehen mit User
- Entscheiden was wo ergänzt wird
- Opus 4.6 Ablageort festlegen

### Phase 3: Deployen

- Änderungen umsetzen (nur nach Freigabe!)
- Commit mit aussagekräftiger Message
- Push zu beiden Remotes (origin + codeberg)

---

## Opus 4.6 — Relevante Features für mr-bytez

Diese Infos sollen an der richtigen Stelle ergänzt werden:

1. **Claude Opus 4.6** verfügbar seit 05.02.2026
2. **Effort Control** (Aufwandssteuerung) — `/effort` in Claude Code: medium/high/max
3. **Agent Teams** (Agenten-Teams) — paralleles Arbeiten, relevant für A2 (Fish DRY-Refactoring)
4. **Context Compaction** (Kontextverdichtung) — relevant für A4 (MCP Server)
5. **1M Token Context Window** (Kontextfenster) — API, relevant für RAG-Workflow mit Qdrant

---

## Regeln

- Source of Truth: `.claude/context/` im Repo
- MD-Update-Regel: Additive-Only (nur ergänzen, nicht kürzen)
- Commit-Format: `[Tag1][Tag2] Beschreibung` — Tags aus context/tags.md
- Push IMMER zu beiden Remotes
- Docs-first Workflow: Erst Docs, dann Code
- Schritt für Schritt — nach jeder Phase Output zeigen und validieren!
