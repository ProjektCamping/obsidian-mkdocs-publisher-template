# AeroPress Wandhalter – hängend, Entnahme nach vorne

Halter für die **normale AeroPress** an der Holzwange der Kaffeeecke.
Beide Teile hängen **senkrecht nach unten** durch eine waagerechte
Ablageplatte – hintereinander – und werden **nacheinander nach vorne**
entnommen, statt wie bisher seitlich an der großen AeroPress vorbei.

![Schrägansicht](preview-schraeg.png)

## Funktionsprinzip

Die Ablageplatte hat zwei Öffnungen mit Profil-Mulden obenauf
(2,5 mm tief, 45° angefast – wie beim bisherigen Halter):

- **vorne:** Der Korpus hängt durch die Öffnung, sein
  **Sechskant-Flansch** liegt in der **Sechskant-Mulde**.
- **hinten:** Der Kolben hängt durch die Öffnung, sein runder
  **Griffteller** liegt in der **runden Mulde**.

Von der hinteren Öffnung führt ein Kanal durch die vordere Öffnung
bis zur Vorderkante. **Entnahme:** Teil ca. 5 mm anheben (aus der
Mulde heben) und **gerade nach vorne herausziehen** – erst den
Korpus, dann den Kolben, der durch dieselbe vordere Öffnung
nachrutscht. Die Mulden verhindern, dass etwas von allein nach
vorne wandert; solange der Korpus hängt, ist auch der Kolben
formschlüssig gesperrt. Einsetzen in umgekehrter Reihenfolge
einfach von oben.

Beim Sechskant-Flansch eine **Flächenseite zur Wand** drehen, dann
setzt er sich satt in die Mulde.

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
| `plunger_tube_d` | 63 mm | Rohr-Außen-Ø des Kolbens |
| `plunger_rim_d` | 83,3 mm | Griffteller-Ø |
| `flange_t` | 6 mm | Dicke von Teller und Flansch |

Die Öffnungen haben 4 mm, die Mulden 2,4 mm Spiel – kleine
Abweichungen sind unkritisch. STL neu erzeugen:

```sh
openscad --export-format binstl -o aeropress-wandhalter.stl aeropress-wandhalter.scad
```

## Platzbedarf

- Ablageplatte: **210 mm tief × 126 mm** Auskragung von der
  Holzwange, 8 mm stark; Rückplatte 90 mm hoch.
- Die Holzwange sollte also mindestens ~21 cm tief sein.
- Nach unten hängen die Teile bis ca. **133 mm** unter die Platte.
- Nach oben ragen die Flansche ~12 mm über die Platte; zum
  Anheben bei der Entnahme reichen **~2 cm Luft** über der Platte.

## Druck

| Parameter | Empfehlung |
|---|---|
| Material | PETG oder PLA |
| Ausrichtung | Aufrecht auf der **hinteren Stirnkante** (Wandseite y=0) stehend – Ablageplatte und Rückplatte stehen dann senkrecht, keine Stützen nötig |
| Stützstruktur | keine (Brim empfohlen) |
| Wandlinien | 4 |
| Füllung | 25–30 % |
| Schichthöhe | 0,2 mm |

In dieser Ausrichtung verlaufen die Schichten quer zur Platte –
die Biegelast der hängenden Teile wirkt in der Schichtebene, der
Halter ist also voll belastbar.

## Montage

Mit 4 Senkkopf-Holzschrauben 4 × 25 mm an die Holzwange schrauben
(Löcher Ø 4,5 mm mit Senkung: 2 über, 2 unter der Platte; die
unteren vor dem Einhängen der Teile eindrehen). Platte waagerecht
ausrichten, offener Kanal nach vorne.
