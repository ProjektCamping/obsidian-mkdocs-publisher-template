// ============================================================
//  SKÅDIS Flaschenhaken
//  Trocknungshaken für Fahrrad-Trinkflaschen (500 ml & 750 ml)
//  an der IKEA SKÅDIS Lochplatte.
//
//  Die gespülte Flasche wird ohne Deckel kopfüber mit der
//  Öffnung auf den schrägen Stab gesteckt und tropft ab.
//  Beide Flaschengrößen haben den gleichen genormten Hals
//  (Öffnung innen ca. 34–36 mm), daher passt ein Haken für beide.
//
//  Montage: beide Clips in zwei übereinanderliegende
//  SKÅDIS-Schlitze stecken und den Haken nach unten schieben.
// ============================================================

$fa = 2;
$fs = 0.4;

// ---------- SKÅDIS-Norm ----------
board_t   = 5.1;   // Plattenstärke SKÅDIS [mm]
slot_w    = 5;     // Schlitzbreite [mm]
slot_h    = 15;    // Schlitzhöhe [mm]
pitch     = 40;    // vertikaler Lochabstand (Mitte-Mitte) [mm]

// ---------- Grundplatte ----------
plate_w   = 28;    // Breite
plate_h   = 58;    // Höhe (überdeckt zwei Schlitze)
plate_t   = 6;     // Dicke
plate_r   = 8;     // Eckenradius

// ---------- Einhängeclips ----------
tab_w     = slot_w - 0.4;      // 4.6 mm – Spiel im Schlitz
tab_h     = 6;                 // Höhe des Durchsteck-Arms
tab_len   = board_t + 0.5;     // Arm reicht durch die Platte
hook_drop = 5;                 // Hakenlänge nach unten (Einhängeweg)
hook_t    = 3;                 // Hakendicke hinter der Platte
// Einsteck-Check: tab_h + hook_drop = 11 mm < slot_h (15 mm)  -> passt

// ---------- Trocknungsstab ----------
rod_d      = 16;   // Stabdurchmesser (Flaschenöffnung innen >= 30 mm)
rod_len    = 120;  // Stablänge entlang der Achse
rod_angle  = 30;   // Neigung nach oben gegenüber der Horizontalen
root_d     = 26;   // Verstärkungskegel am Stabfuß
root_len   = 16;
collar_d   = 36;   // Stopp-Kragen: hält den Flaschenrand auf Abstand
collar_t   = 9;
collar_pos = 45;   // Position des Kragens entlang der Stabachse

// ============================================================

module plate_2d() {
    offset(r = plate_r) offset(delta = -plate_r)
        square([plate_w, plate_h], center = true);
}

// Ein Clip: Arm durch den Schlitz, Haken greift hinter die Platte.
// Ursprung: Plattenrückseite (z=0), y = Unterkante des Arms im
// eingehängten Zustand (liegt auf der Schlitz-Unterkante auf).
module clip() {
    // Durchsteck-Arm (ragt 1 mm in die Platte, sauberes Verschmelzen)
    translate([-tab_w/2, 0, -tab_len])
        cube([tab_w, tab_h, tab_len + 1]);
    // Haken nach unten, hinter der Platte
    translate([-tab_w/2, -hook_drop, -tab_len - hook_t])
        cube([tab_w, hook_drop + tab_h, hook_t]);
}

// Stab mit Fußverstärkung, Kragen und runder Spitze,
// Achse entlang +z (wird später geneigt).
module rod() {
    // Fußkegel
    cylinder(d1 = root_d, d2 = rod_d, h = root_len);
    // Stab
    cylinder(d = rod_d, h = rod_len);
    // Runde Spitze zum leichten Aufstecken
    translate([0, 0, rod_len]) sphere(d = rod_d);
    // Stopp-Kragen (beidseitig angefast, 3 mm breiter Rand)
    translate([0, 0, collar_pos - collar_t/2]) {
        cylinder(d1 = rod_d + 4, d2 = collar_d, h = collar_t/2 - 1.5);
        translate([0, 0, collar_t/2 - 1.5])
            cylinder(d = collar_d, h = 3);
        translate([0, 0, collar_t/2 + 1.5])
            cylinder(d1 = collar_d, d2 = rod_d + 4, h = collar_t/2 - 1.5);
    }
}

module flaschenhaken() {
    // Grundplatte (Rückseite bei z=0, Vorderseite bei z=plate_t)
    linear_extrude(plate_t) plate_2d();

    // Zwei Clips im 40-mm-Raster
    for (c = [-pitch/2, pitch/2])
        translate([0, c - slot_h/2, 0]) clip();

    // Geneigter Trocknungsstab an der Plattenvorderseite
    translate([0, 0, plate_t])
        rotate([-rod_angle, 0, 0])
            rod();
}

flaschenhaken();
