#!/usr/bin/env python3
"""Bereitet fotografierte Tagebuchseiten fuers Abtippen auf.

Handyfotos tragen ihre Drehung im EXIF statt in den Pixeln - ohne das
Anwenden liegen die Seiten quer und sind deutlich schlechter zu lesen.
Ausserdem ist eine ganze Seite am Stueck zu klein aufgeloest, um
Handschrift sicher zu entziffern; darum entstehen zusaetzlich drei
ueberlappende Streifen pro Seite.

    python3 seiten-aufbereiten.py FOTOS_ORDNER AUSGABE_ORDNER [--ab 6]

Ergebnis:
    AUSGABE_ORDNER/bilder/seite-06.jpg   aufgerichtet, fuer den Editor
    AUSGABE_ORDNER/lesen/s06_1.png       Streifen zum Abtippen
    AUSGABE_ORDNER/lesen/s06_2.png
    AUSGABE_ORDNER/lesen/s06_3.png

Die Seiten werden nach Dateiname sortiert durchnummeriert. Bei Handyfotos
(IMG_2041.jpg, IMG_2042.jpg, ...) stimmt das; bei zufaellig benannten
Dateien vorher umbenennen, sonst geraet die Seitenfolge durcheinander.

Braucht Pillow:  pip install Pillow
"""
import argparse
import os
import sys

try:
    from PIL import Image, ImageOps, ImageEnhance
except ImportError:
    sys.exit("Pillow fehlt.  Bitte installieren mit:  pip install Pillow")

ENDUNGEN = (".jpg", ".jpeg", ".png", ".heic", ".heif", ".webp", ".tif", ".tiff")


def aufbereiten(quelle, ziel, ab=1):
    bilder = os.path.join(ziel, "bilder")
    lesen = os.path.join(ziel, "lesen")
    os.makedirs(bilder, exist_ok=True)
    os.makedirs(lesen, exist_ok=True)

    dateien = sorted(f for f in os.listdir(quelle) if f.lower().endswith(ENDUNGEN))
    if not dateien:
        sys.exit(f"Keine Bilder in {quelle} gefunden.")

    for versatz, name in enumerate(dateien):
        nr = ab + versatz
        im = ImageOps.exif_transpose(Image.open(os.path.join(quelle, name)))

        # Fuer den Editor: aufgerichtet, in Farbe, volle Aufloesung.
        seite = os.path.join(bilder, f"seite-{nr:02d}.jpg")
        im.convert("RGB").save(seite, quality=88, optimize=True)

        # Zum Abtippen: grau, kontrastreicher, geschaerft, in Streifen.
        g = ImageOps.autocontrast(im.convert("L"), cutoff=2)
        g = ImageEnhance.Contrast(g).enhance(1.35)
        g = ImageEnhance.Sharpness(g).enhance(2.0)
        breite, hoehe = g.size
        anteile = [(0.00, 0.40), (0.34, 0.72), (0.66, 1.00)]
        for teil, (oben, unten) in enumerate(anteile, 1):
            aus = g.crop((0, int(hoehe * oben), breite, int(hoehe * unten)))
            aus = aus.resize((1500, int(aus.height * 1500 / aus.width)), Image.LANCZOS)
            aus.save(os.path.join(lesen, f"s{nr:02d}_{teil}.png"))

        print(f"{name}  ->  seite-{nr:02d}.jpg  + 3 Streifen")

    print(f"\nFertig. {len(dateien)} Seiten in {ziel}")
    print("Zum Abtippen die Streifen in lesen/ ansehen, nicht die ganzen Seiten.")


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("quelle", help="Ordner mit den Handyfotos")
    p.add_argument("ziel", help="Ordner fuer das Ergebnis")
    p.add_argument("--ab", type=int, default=1,
                   help="Nummer der ersten Seite (Standard 1)")
    a = p.parse_args()
    aufbereiten(a.quelle, a.ziel, a.ab)
