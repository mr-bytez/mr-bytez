#!/usr/bin/env fish
# Secrets-Scanner v2 für mr-bytez Repository
# Schreibt ALLE Vorkommen in Datei zur manuellen Prüfung
# 
# Autor: Michael Rohwer
# Erstellt: 2026-02-04
# Version: 2.0 - Output in Datei

set_color yellow
echo "🔍 MR-ByteZ Secrets-Scanner v2.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Schreibt alle Treffer in secrets-scan-report.md"
set_color normal

# Output-Datei
set -l report_file "secrets-scan-report.md"

# Keywords die wir suchen
set -l keywords \
    password \
    passwd \
    pwd \
    token \
    secret \
    api_key \
    apikey \
    auth \
    credential \
    bearer

# Zähler
set -g total_matches 0
set -g files_with_matches (mktemp)

# Report initialisieren
echo "# Secrets Scan Report" > $report_file
echo "" >> $report_file
echo "**Datum:** "(date +"%Y-%m-%d %H:%M:%S") >> $report_file
echo "**Verzeichnisse:** claude/, docs/" >> $report_file
echo "" >> $report_file
echo "---" >> $report_file
echo "" >> $report_file

echo ""
set_color cyan
echo "📁 Scanne claude/ und docs/..."
set_color normal

# Für jedes Keyword
for keyword in $keywords
    echo "   Scanne: $keyword..."
    
    echo "## Keyword: $keyword" >> $report_file
    echo "" >> $report_file
    
    set -l matches (command grep -rn -i "$keyword" claude/ docs/ 2>/dev/null)
    
    if test -n "$matches"
        set -l count (echo "$matches" | wc -l)
        
        echo "**$count Treffer gefunden**" >> $report_file
        echo "" >> $report_file
        
        # Gruppiere nach Dateien
        set -l current_file ""
        for line in $matches
            # Extrahiere Dateiname
            set -l file (echo "$line" | cut -d: -f1)
            
            if test "$file" != "$current_file"
                set current_file "$file"
                echo "$file" >> $files_with_matches
                echo "" >> $report_file
                echo "### 📄 $file" >> $report_file
                echo "" >> $report_file
                echo '```' >> $report_file
            end
            
            # Zeige komplette Zeile
            echo "$line" >> $report_file
            set total_matches (math $total_matches + 1)
        end
        
        # Schließe Code-Block
        echo '```' >> $report_file
        echo "" >> $report_file
    else
        echo "**Keine Treffer**" >> $report_file
        echo "" >> $report_file
    end
end

# Zusammenfassung
echo "" >> $report_file
echo "---" >> $report_file
echo "" >> $report_file
echo "## 📊 ZUSAMMENFASSUNG" >> $report_file
echo "" >> $report_file

set -l unique_files (sort -u $files_with_matches | wc -l)
echo "- **Dateien mit Treffern:** $unique_files" >> $report_file
echo "- **Gesamt-Treffer:** $total_matches" >> $report_file
echo "" >> $report_file

echo "## 💡 Nächste Schritte" >> $report_file
echo "" >> $report_file
echo "1. ✅ **Harmlos:** Keyword in Doku/Erklärung → OK, nichts tun" >> $report_file
echo "2. 🚨 **Secret:** Echter Wert → Ersetzen durch \`<PASSWORD>\`, \`<TOKEN>\`, etc." >> $report_file
echo "3. ⚠️ **Unklar:** Im Chat mit Claude besprechen" >> $report_file
echo "" >> $report_file
echo "### Beispiele für HARMLOSE Treffer:" >> $report_file
echo '```' >> $report_file
echo '"use password authentication"' >> $report_file
echo '"token-based API"' >> $report_file
echo '"secret management system"' >> $report_file
echo '```' >> $report_file
echo "" >> $report_file
echo "### Beispiele für ECHTE SECRETS (REDACT!):" >> $report_file
echo '```' >> $report_file
echo 'password: MySecret123' >> $report_file
echo 'api_key: sk-1234567890abcdef' >> $report_file
echo 'token: ghp_xxxxxxxxxxxx' >> $report_file
echo '-----BEGIN PRIVATE KEY-----' >> $report_file
echo '```' >> $report_file

# Cleanup
rm -f $files_with_matches

# Ausgabe
echo ""
set_color cyan
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 SCAN ABGESCHLOSSEN"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
set_color normal

echo "📄 Dateien mit Treffern:  $unique_files"
echo "🔑 Gesamt-Treffer:         $total_matches"
echo ""
set_color green
echo "✅ Report erstellt: $report_file"
set_color normal
echo ""
echo "Öffne den Report mit:"
echo "  code $report_file"
echo "  micro $report_file"
echo ""

if test $total_matches -gt 0
    set_color yellow
    echo "⚠️  Prüfung nötig! Lade Report hoch und wir werten gemeinsam aus."
    set_color normal
    exit 1
else
    set_color green
    echo "✅ Keine Keywords gefunden - Sicher!"
    set_color normal
    exit 0
end
