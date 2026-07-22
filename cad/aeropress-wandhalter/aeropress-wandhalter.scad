// ============================================================
//  AeroPress Wandhalter - hängend, Entnahme nach vorne
//
//  Beide Teile der (normalen) AeroPress hängen SENKRECHT nach
//  unten durch eine waagerechte Ablageplatte, hintereinander:
//    - vorne:  Korpus  (Sechskant-Flansch liegt in Sechskant-Mulde)
//    - hinten: Kolben  (runder Griffteller liegt in runder Mulde)
//
//  Die Zylinder hängen durch Öffnungen in der Platte, die
//  Flansche liegen oben in 2,5 mm tiefen, 45°-angefasten
//  Profil-Mulden (verhindern unbeabsichtigtes Verrutschen).
//  Nach vorne läuft ein offener Kanal: Teil leicht anheben und
//  nach vorne herausziehen - erst den Korpus, dann den Kolben,
//  der durch dieselbe vordere Öffnung nachrutscht ("nacheinander
//  von vorne"). Einsetzen in umgekehrter Reihenfolge von oben.
//
//  Montage: Rückplatte mit 4 Senkkopfschrauben (4 x 25 o. ä.)
//  seitlich an die Holzwange schrauben.
//
//  Koordinaten: Holzwand = Ebene x=0 (Halter bei x<0),
//  y nach vorne (zum Betrachter), z nach oben.
//  Oberseite der Ablageplatte = z=0.
// ============================================================

$fa = 2;
$fs = 0.4;

// ---------- AeroPress-Maße (VOR DEM DRUCK NACHMESSEN!) ------
chamber_tube_d  = 70;    // Korpus: Rohr-Außendurchmesser
chamber_hex_af  = 92.8;  // Korpus: Sechskant-Flansch Schlüsselweite
                         // (offiziell 107.2 mm über Eck * cos30)
chamber_stub_d  = 76;    // Korpus: Kragen oberhalb des Flanschs
chamber_len     = 121;   // Korpus: Gesamtlänge
chamber_flange_pos = 8;  // Abstand Oberkante -> Flansch-Beginn
plunger_tube_d  = 63;    // Kolben: Rohr-Außendurchmesser
plunger_rim_d   = 83.3;  // Kolben: Griffteller-Durchmesser
plunger_len     = 133;   // Kolben: Gesamtlänge
flange_t        = 6;     // Dicke Flansch / Griffteller

// ---------- Spiel ----------
hole_play   = 4;         // Öffnungen/Kanäle = Rohr-Ø + hole_play
pocket_play = 2.4;       // Profil-Mulden = Flansch + pocket_play
pocket_t    = 2.5;       // Muldentiefe (45° angefast)

// ---------- Aufbau ----------
shelf_t   = 8;           // Ablageplatte
shelf_w   = 126;         // Auskragung von der Holzwand
shelf_l   = 210;         // Tiefe (y)
axis_x    = -64;         // Achsabstand von der Holzwand
y_rear    = 50;          // Lochmitte Kolben (hinten)
y_front   = 152;         // Lochmitte Korpus (vorne)

plate_t   = 8;           // Rückplatte am Holz
plate_top = 40;          // über Plattenoberseite
plate_bot = -50;         // unter Plattenoberseite
fillet    = 18;          // durchgehende Hohlkehle unter der Platte

screw_d      = 4.5;
screw_head_d = 9;

// ---------- abgeleitet ----------
plunger_hole = plunger_tube_d + hole_play;      // 67
chamber_hole = chamber_tube_d + hole_play;      // 74
rim_pocket   = plunger_rim_d + pocket_play;     // 85.7
hex_pocket   = chamber_hex_af + pocket_play;    // 95.2 (Schlüsselweite)

// ============================================================

module rounded_rect(w, h, r) {
    offset(r = r) offset(delta = -r) square([w, h]);
}

// Öffnungen + Kanäle (2D, x-y): beide Löcher, Verbindungskanal,
// Ausgang nach vorne
module through2d() {
    translate([axis_x, y_front]) circle(d = chamber_hole);
    translate([axis_x, y_rear])  circle(d = plunger_hole);
    translate([axis_x - plunger_hole/2, y_rear])
        square([plunger_hole, y_front - y_rear]);
    translate([axis_x - chamber_hole/2, y_front])
        square([chamber_hole, shelf_l - y_front + 1]);
}

// Profil-Mulden (2D)
module rim_pocket2d() {
    translate([axis_x, y_rear]) circle(d = rim_pocket);
}
module hex_pocket2d() {
    // Fläche zeigt zur Holzwand -> maximaler Wandabstand
    translate([axis_x, y_front]) rotate(30)
        circle(d = hex_pocket / cos(30), $fn = 6);
}

// 45°-angefaste Mulde, von der Plattenoberseite (z=0) nach unten
module pocket(depth) {
    hull() {
        translate([0, 0, 0.05]) linear_extrude(0.01) children();
        translate([0, 0, -depth]) linear_extrude(0.01)
            offset(delta = -depth) children();
    }
}

// 2 mm Fase an den Oberkanten der Öffnungen/Kanäle
module top_chamfer() {
    hull() {
        translate([0, 0, 0.05]) linear_extrude(0.01)
            offset(delta = 2) through2d();
        translate([0, 0, -2]) linear_extrude(0.01) through2d();
    }
}

// Ablageplatte
module shelf() {
    difference() {
        translate([-shelf_w, 0, -shelf_t])
            cube([shelf_w, shelf_l, shelf_t]);
        translate([0, 0, -shelf_t - 0.1])
            linear_extrude(shelf_t + 0.2) through2d();
        pocket(pocket_t) rim_pocket2d();
        pocket(pocket_t) hex_pocket2d();
        top_chamfer();
    }
}

// Rückplatte mit 4 Senkkopf-Schraublöchern
module backplate() {
    screw_pos = [[45, 25], [165, 25], [45, -32], [165, -32]];  // [y, z]
    difference() {
        translate([0, 0, plate_bot])
            rotate([0, -90, 0])              // 2D-x -> z, Extrusion -> -x
                linear_extrude(plate_t)
                    rounded_rect(plate_top - plate_bot, shelf_l, 6);
        for (p = screw_pos)
            translate([-plate_t - 0.1, p[0], p[1]]) {
                rotate([0, 90, 0])
                    cylinder(d = screw_d, h = plate_t + 0.2);
                rotate([0, 90, 0])
                    cylinder(d1 = screw_head_d + 0.2, d2 = screw_d,
                             h = (screw_head_d - screw_d)/2 + 0.1);
            }
    }
}

// durchgehende Hohlkehle (45°) unter der Platte an der Rückplatte
module under_fillet() {
    translate([0, shelf_l, 0])
        rotate([90, 0, 0])
            linear_extrude(shelf_l)
                polygon([[-plate_t, -shelf_t],
                         [-plate_t, -shelf_t - fillet],
                         [-plate_t - fillet, -shelf_t]]);
}

module halter() {
    shelf();
    backplate();
    under_fillet();
}

// Transparente AeroPress-Teile zur Passkontrolle (nur Vorschau)
show_aeropress = true;
module ghosts() {
    // Kolben hinten: Teller in der runden Mulde
    color("SteelBlue", 0.35) translate([axis_x, y_rear, 0]) {
        translate([0, 0, -pocket_t]) cylinder(d = plunger_rim_d, h = flange_t);
        translate([0, 0, -pocket_t - (plunger_len - flange_t)])
            cylinder(d = plunger_tube_d, h = plunger_len - flange_t);
    }
    // Korpus vorne: Sechskant-Flansch in der Sechskant-Mulde
    color("IndianRed", 0.35) translate([axis_x, y_front, 0]) {
        translate([0, 0, -pocket_t]) rotate(30)
            linear_extrude(flange_t)
                circle(d = chamber_hex_af / cos(30), $fn = 6);
        translate([0, 0, -pocket_t + flange_t])
            cylinder(d = chamber_stub_d, h = chamber_flange_pos);
        translate([0, 0, -pocket_t - (chamber_len - chamber_flange_pos - flange_t)])
            cylinder(d = chamber_tube_d,
                     h = chamber_len - chamber_flange_pos - flange_t);
    }
}

halter();
if (show_aeropress && $preview) ghosts();
