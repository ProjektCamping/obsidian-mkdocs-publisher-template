# AeroPress Wandhalter – Entnahme nach vorne

Halter für die **normale AeroPress** an der Holzwange der Kaffeeecke.
Beide Teile hängen **genauso ausgerichtet wie im bisherigen Halter** –
waagerecht nebeneinander, Achsen von der Holzwange weg zeigend, der
Stempel auf der runden Aufnahme, der Korpus auf dem Sechskant – aber
sie werden **nacheinander nach vorne** entnommen statt zur Seite,
wo die große AeroPress im Weg hängt.

![Schrägansicht](preview-schraeg.png)

## Funktionsprinzip

Eine Frontplatte steht parallel zur Holzwange, dahinter ein 18 mm
breiter Spalt:

- Das **Rohr** liegt in einem Schlitz der Frontplatte in einer
  3 mm tiefen Rast-Vertiefung (Sitz).
- **Griffteller** (rund) bzw. **Sechskant-Flansch** sitzen HINTER
  der Frontplatte in flachen, 45°-angefasten Profil-Mulden – sie
  stützen das Teil gegen Kippen und verriegeln es axial: Man kann
  die AeroPress nicht versehentlich nach links herausziehen.
- Die Schlitze führen zur **Vorderkante**.

**Entnahme:** Teil ca. 3 mm anheben und gerade **nach vorne
herausziehen** – Teller/Flansch gleiten dabei frei durch den Spalt.
Erst den Korpus (vorne), dann den Kolben durch dieselbe Öffnung.
Solange der Korpus hängt, ist der Kolben formschlüssig gesperrt
(„nacheinander"). Einsetzen umgekehrt: von vorne einschieben, am
Sitz ins Raster abgesenkt – fertig. Die Deckwand liegt so hoch,
dass der Sechskant-Flansch in jeder Drehstellung durch den Spalt
passt; einrasten tut er satt mit einer Fläche nach unten.

## Dateien

| Datei | Inhalt |
|---|---|
| `aeropress-wandhalter.scad` | Parametrisches OpenSCAD-Modell |
| `aeropress-wandhalter.stl` | Druckfertiges Mesh |
| `preview-*.png` | Vorschau (transparent: AeroPress zur Passkontrolle) |

## Maße – bitte vor dem Druck nachmessen!

Alle AeroPress-Maße stehen als Variablen am Dateianfang. Offizielle
Herstellerangaben sind eingearbeitet (Korpus 121 mm, Sechskant
107,2 mm über Eck ≙ 92,8 mm Schlüsselweite; Kolben 133 mm,
Teller Ø 83,3 mm). **Mit Messschieber prüfen:**

| Variable | angenommen | messen |
|---|---|---|
| `chamber_tube_d` | 70 mm | Rohr-Außen-Ø des Korpus |
| `chamber_hex_af` | 92,8 mm | Sechskant-Flansch: Schlüsselweite (Fläche zu Fläche) |
| `chamber_stub_d` | 76 mm | Ø des Kragens zwischen Flansch und Trinkrand |
| `chamber_flange_pos` | 8 mm | Abstand Trinkrand → Flansch |
| `plunger_tube_d` | 63 mm | Rohr-Außen-Ø des Kolbens |
| `plunger_rim_d` | 83,3 mm | Griffteller-Ø |
| `flange_t` | 6 mm | Dicke von Teller und Flansch |

Schlitze haben 4 mm, Mulden 2,7 mm Spiel – kleine Abweichungen
sind unkritisch. STL neu erzeugen:

```sh
openscad --export-format binstl -o aeropress-wandhalter.stl aeropress-wandhalter.scad
```

## Platzbedarf

- An der Holzwange: **215 mm tief × 152 mm hoch** (Rückplatte).
- Auskragung: Frontplatte endet 34 mm vor der Wange, die Teile
  ragen bis ca. **156 mm** von der Wange ab (wie bisher seitlich).
- Zum Entnehmen nach vorne ca. 15 cm freier Zugriff vor dem Halter.

## Druck

| Parameter | Empfehlung |
|---|---|
| Material | PETG oder PLA |
| Ausrichtung | Aufrecht auf der **hinteren Stirnkante** (y=0) stehend – alle Wände stehen dann senkrecht, keine Stützen nötig |
| Stützstruktur | keine (Brim empfohlen) |
| Wandlinien | 4 |
| Füllung | 25–30 % |
| Schichthöhe | 0,2 mm |

In dieser Ausrichtung wirken die Lasten der hängenden Teile in der
Schichtebene – der Halter ist voll belastbar.

## Montage

Mit 4 Senkkopf-Holzschrauben 4 × 25 mm an die Holzwange
(Löcher Ø 4,5 mm mit Senkung: 2 oben über der Deckwand, 2 unten
unter der Frontplatte – beide Reihen sind frei zugänglich).
Offene Schlitzseite nach vorne, Platte waagerecht ausrichten.
