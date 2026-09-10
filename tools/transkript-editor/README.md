# Transkript-Editor

Ein Werkzeug zum Prüfen abgetippter Handschrift. Aus Fotos entstandene
Markdown-Dateien enthalten markierte Stellen — überall dort, wo die Lesung
unsicher war. Der Editor führt durch diese Stellen, zeigt das Foto der
Originalseite daneben und schreibt am Ende sauberes Markdown heraus.

Der Text selbst wird dabei **nicht angefasst**: Aus dem Original werden nur
die Markierungen ersetzt, Zeichen für Zeichen bleibt alles andere so, wie es
transkribiert wurde. Keine Rechtschreibkorrektur, keine geglätteten Sätze,
keine stillen Änderungen.

## Benutzen

`index.html` im Browser öffnen — Doppelklick genügt, es braucht keinen Server
und keine Installation. Dann den Ordner mit den `.md`-Dateien **und** den
Seitenfotos hineinziehen.

Alles bleibt auf dem eigenen Rechner. Die Dateien werden nur im Browser
geöffnet, nichts wird hochgeladen; der Zwischenstand liegt im
`localStorage` des Browsers.

## Fotos vorbereiten

Handyfotos tragen ihre Drehung im EXIF statt in den Pixeln — ungedreht
liegen die Seiten im Editor quer. `seiten-aufbereiten.py` richtet sie auf
und legt zusätzlich Lesestreifen an, in denen Handschrift deutlich besser
zu entziffern ist als in der ganzen Seite:

```
pip install Pillow
python3 seiten-aufbereiten.py FOTOS_ORDNER AUSGABE_ORDNER [--ab 6]
```

Heraus kommen `bilder/seite-NN.jpg` für den Editor und `lesen/sNN_1..3.png`
zum Abtippen.

## Markierungen im Markdown

| Schreibweise | Bedeutung |
| --- | --- |
| `{?Hverir}` | Unsichere Stelle, eine Lesung |
| `{?Hverir\|Hverið\|Hverarönd}` | Unsichere Stelle mit Alternativvorschlägen |
| `{?Hverir // Klecks über dem H}` | Mit Hinweis, warum die Stelle unklar ist |
| `{?}` | Unleserlich, gar keine Lesung |
| `{? // ganze Zeile verwaschen}` | Unleserlich, mit Hinweis |

Der erste Eintrag ist die beste Lesung; sie steht im Text und ist im Editor
mit `1` vorbelegt. Die Markierung darf auch mehrere Wörter umfassen, wenn erst
die ganze Wendung Sinn ergibt: `{?ging bis zum Horizont|war endlos}`.

### Seiten und Fotos verbinden

Ein Kommentar bindet den folgenden Text an ein Foto. Beim Prüfen erscheint es
neben der Stelle:

```markdown
<!-- seite: 12 | bilder/tag03_a.jpg -->
```

Die Seitenzahl darf entfallen (`<!-- seite: bilder/tag03_a.jpg -->`), ebenso
das Bild. Pfade gelten relativ zur Markdown-Datei; findet der Editor eine Datei
dort nicht, sucht er sie am Dateinamen im geöffneten Ordner.

Ein `image:` im Frontmatter gilt als Standardbild für die ganze Datei.

## Tastatur

| Taste | Wirkung |
| --- | --- |
| `Enter` | Vorgeschlagene Lesung übernehmen und zur nächsten offenen Stelle |
| `1` … `9` | Den entsprechenden Vorschlag wählen und weiter |
| Lostippen | Springt ins Eingabefeld für eine eigene Lesung |
| `↓` `→` / `↑` `←` | Eine Stelle vor oder zurück, ohne zu entscheiden |
| `Esc` | Editor schließen |
| `Strg`/`Cmd` + `S` | Fertigen Text sichern |

## Herausschreiben

„Fertigen Text sichern" ersetzt die Markierungen durch die getroffenen
Entscheidungen. Eine einzelne Datei kommt als `.md` zurück, mehrere als ZIP.
Einstellbar ist dabei:

- **Seitenkommentare entfernen** — die `<!-- seite: … -->`-Zeilen fliegen raus.
- **Offene Stellen markiert lassen** — noch nicht entschiedene Stellen behalten
  ihre `{?…}`-Klammern, damit sie später wiederzufinden sind.
- **Protokoll mitspeichern** — eine JSON-Datei mit allen Entscheidungen: was
  ursprünglich dastand, was gewählt wurde, und zu welchem Foto es gehört.
- **Platzhalter für Unleserliches** — voreingestellt `[unleserlich]`.

## Ablage

Transkripte und Seitenfotos gehören nicht ins Repository. Der Ordner
`transkripte/` im Projektwurzelverzeichnis ist dafür vorgesehen und per
`.gitignore` ausgenommen:

```
transkripte/
├── tag01.md
├── tag02.md
└── bilder/
    ├── tag01_a.jpg
    └── tag01_b.jpg
```
