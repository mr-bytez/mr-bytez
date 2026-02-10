# Claude Code Task Queue

**Zweck:** Aufgaben-Uebergabe von Claude.ai an Claude Code.

## Workflow

1. Claude.ai erstellt `NEXT.md` in diesem Ordner
2. Claude Code liest und fuehrt die Aufgabe aus
3. Nach Abschluss: `NEXT.md` loeschen (im selben Commit)
4. Naechste Aufgabe wird bei Bedarf von Claude.ai erstellt

## Regeln

- Immer nur EINE aktive Aufgabe (`NEXT.md`)
- Task-Datei wird nach Erledigung geloescht
- Commit-Message referenziert die erledigte Aufgabe
- Bei Unklarheiten: NICHT raten — User fragen
