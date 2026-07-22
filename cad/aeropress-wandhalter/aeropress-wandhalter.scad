// ============================================================
//  AeroPress Wandhalter - Ausrichtung wie der bisherige Halter,
//  aber Entnahme NACH VORNE statt zur Seite
//
//  Beide Teile hängen waagerecht nebeneinander, die Achsen
//  zeigen von der Holzwange weg (wie im bisherigen Halter):
//    - vorne:  Korpus  (Sechskant-Flansch in Sechskant-Mulde)
//    - hinten: Kolben  (runder Griffteller in runder Mulde)
//
//  Aufbau: Eine Frontplatte parallel zur Holzwange, dahinter
//  ein 18 mm Spalt. Das Rohr liegt in einem Schlitz der
//  Frontplatte, Griffteller bzw. Flansch sitzen HINTER der
//  Platte in flachen Profil-Mulden (rund / Sechskant) und
//  stützen das Teil gegen Kippen und axiales Herausziehen.
//
//  Die Schlitze führen zur Vorderkante und liegen 3 mm höher
//  als die Sitze (Rast-Vertiefung). Entnahme: Teil ca. 3 mm
//  anheben und gerade NACH VORNE herausziehen - Teller/Flansch
//  gleiten dabei frei durch den Spalt. Erst den Korpus (vorne),
//  dann den Kolben durch dieselbe Öffnung. Einsetzen umgekehrt
//  von vorne. Solange der Korpus hängt, ist der Kolben gesperrt
//  ("nacheinander").
//
//  Montage: Rückplatte mit 4 Senkkopfschrauben an die Holzwange
//  (2 oben über der Deckwand, 2 unten unter der Frontplatte).
//
//  Koordinaten: Holzwand = Ebene x=0 (Halter bei x<0),
//  y nach vorne (zum Betrachter), z nach oben.
//  Achshöhe der Teile = z=0.
// ============================================================

$fa = 2;
$fs = 0.4;

// ---------- AeroPress-Maße (VOR DEM DRUCK NACHMESSEN!) ------
chamber_tube_d  = 70;    // Korpus: Rohr-Außendurchmesser
chamber_hex_af  = 92.8;  // Korpus: Sechskant-Flansch Schlüsselweite
                         // (offiziell 107.2 mm über Eck * cos30)
chamber_stub_d  = 76;    // Korpus: Kragen zwischen Flansch und Trinkrand
chamber_len     = 121;   // Korpus: Gesamtlänge
chamber_flange_pos = 8;  // Abstand Trinkrand -> Flansch-Beginn
plunger_tube_d  = 63;    // Kolben: Rohr-Außendurchmesser
plunger_rim_d   = 83.3;  // Kolben: Griffteller-Durchmesser
plunger_len     = 133;   // Kolben: Gesamtlänge
flange_t        = 6;     // Dicke Flansch / Griffteller

// ---------- Spiel / Raster ----------
slot_play   = 4;         // Schlitz-/Sitzbreite = Rohr-Ø + slot_play
pocket_play = 2.7;       // Profil-Mulden = Flansch + pocket_play
pocket_t    = 2.5;       // Muldentiefe (45° angefast)
notch       = 3;         // Rast: Sitz liegt 3 mm tiefer als der Schlitz

// ---------- Aufbau ----------
fp_t      = 8;           // Frontplatte
gap       = 18;          // Spalt Frontplatte <-> Holzwand (für Teller,
                         // Flansch + Kragen: 2.5+3.5+8 = 14 + Luft)
bp_t      = 8;           // Rückplatte am Holz
holder_l  = 215;         // Tiefe (y) von Front- und Rückplatte
fp_z0     = -54;         // Frontplatte: Unterkante
fp_z1     = 68;          // Frontplatte: Oberkante
bp_z0     = -70;         // Rückplatte: Unterkante
bp_z1     = 82;          // Rückplatte: Oberkante
top_z0    = 60;          // Deckwand: liegt so hoch, dass der Sechskant-
                         // Flansch in jeder Drehstellung durchpasst
y_rear    = 55;          // Sitzmitte Kolben (hinten)
y_front   = 157;         // Sitzmitte Korpus (vorne)

screw_d      = 4.5;
screw_head_d = 9;

// ---------- abgeleitet ----------
plunger_seat = plunger_tube_d + slot_play;      // 67
chamber_seat = chamber_tube_d + slot_play;      // 74
rim_pocket   = plunger_rim_d + pocket_play;     // 86
hex_pocket   = chamber_hex_af + pocket_play;    // 95.5 (Schlüsselweite)
fp_x1 = -bp_t - gap;                            // Rückseite Frontplatte
fp_x0 = fp_x1 - fp_t;                           // Vorderseite Frontplatte

// ============================================================

module rounded_rect(w, h, r) {
    offset(r = r) offset(delta = -r) square([w, h]);
}

// 2D-Profile in der (y,z)-Ebene; rotate([90,0,90]) extrudiert
// sie entlang +x.
module yz_extrude(x_from, thickness) {
    translate([x_from, 0, 0])
        rotate([90, 0, 90])
            linear_extrude(thickness)
                children();
}

// Sechskant, Flächen oben/unten, sw = Schlüsselweite
module hex2d(sw) {
    circle(d = sw / cos(30), $fn = 6);
}

// Sitze + Schlitze zur Vorderkante (Schlitze 'notch' höher)
module through2d() {
    translate([y_rear, 0])  circle(d = plunger_seat);
    translate([y_front, 0]) circle(d = chamber_seat);
    translate([y_rear, notch - plunger_seat/2])
        square([holder_l - y_rear + 1, plunger_seat]);
    translate([y_front, notch - chamber_seat/2])
        square([holder_l - y_front + 1, chamber_seat]);
}

// Profil-Mulden (2D)
module rim_pocket2d() {
    translate([y_rear, 0]) circle(d = rim_pocket);
}
module hex_pocket2d() {
    translate([y_front, 0]) hex2d(hex_pocket);
}

// 45°-angefaste Mulde in der Rückseite der Frontplatte
module pocket(depth) {
    hull() {
        yz_extrude(fp_x1 - 0.05, 0.1) children();
        yz_extrude(fp_x1 - depth, 0.01) offset(delta = -depth) children();
    }
}

// Frontplatte mit Sitzen, Schlitzen und Mulden
module frontplate() {
    difference() {
        yz_extrude(fp_x0, fp_t)
            translate([0, fp_z0]) square([holder_l, fp_z1 - fp_z0]);
        yz_extrude(fp_x0 - 0.1, fp_t + 0.2) through2d();
        pocket(pocket_t) rim_pocket2d();
        pocket(pocket_t) hex_pocket2d();
        // 2 mm Fase an der Vorderseite (Einführhilfe)
        hull() {
            yz_extrude(fp_x0 - 0.05, 0.1) offset(delta = 2) through2d();
            yz_extrude(fp_x0 + 2, 0.01) through2d();
        }
    }
}

// Rückplatte mit 4 Senkkopf-Schraublöchern
module backplate() {
    screw_pos = [[45, 74], [170, 74], [45, -62], [170, -62]];   // [y, z]
    difference() {
        yz_extrude(-bp_t, bp_t)
            translate([0, bp_z0])
                rounded_rect(holder_l, bp_z1 - bp_z0, 6);
        for (p = screw_pos)
            translate([-bp_t - 0.1, p[0], p[1]]) {
                rotate([0, 90, 0])
                    cylinder(d = screw_d, h = bp_t + 0.2);
                rotate([0, 90, 0])
                    cylinder(d1 = screw_head_d + 0.2, d2 = screw_d,
                             h = (screw_head_d - screw_d)/2 + 0.1);
            }
    }
}

module halter() {
    frontplate();
    backplate();
    // Deckwand oben (verbindet beide Platten, überspannt den Spalt)
    translate([fp_x0, 0, top_z0]) cube([-fp_x0, holder_l, fp_z1 - top_z0]);
    // Rückwand am hinteren Ende
    translate([fp_x0, 0, fp_z0]) cube([-fp_x0, 8, fp_z1 - fp_z0]);
}

// Transparente AeroPress-Teile zur Passkontrolle (nur Vorschau)
show_aeropress = true;
module ghosts() {
    // Kolben hinten: Teller in der runden Mulde hinter der Platte
    color("SteelBlue", 0.35) translate([0, y_rear, 0]) {
        translate([fp_x1 - pocket_t, 0, 0])
            rotate([0, 90, 0]) cylinder(d = plunger_rim_d, h = flange_t);
        translate([fp_x1 - pocket_t - (plunger_len - flange_t), 0, 0])
            rotate([0, 90, 0]) cylinder(d = plunger_tube_d,
                                        h = plunger_len - flange_t);
    }
    // Korpus vorne: Sechskant-Flansch in der Sechskant-Mulde
    color("IndianRed", 0.35) translate([0, y_front, 0]) {
        translate([fp_x1 - pocket_t, 0, 0])
            rotate([0, 90, 0]) rotate([0, 0, 90])
                linear_extrude(flange_t) hex2d(chamber_hex_af);
        translate([fp_x1 - pocket_t + flange_t, 0, 0])
            rotate([0, 90, 0]) cylinder(d = chamber_stub_d,
                                        h = chamber_flange_pos);
        translate([fp_x1 - pocket_t
                   - (chamber_len - chamber_flange_pos - flange_t), 0, 0])
            rotate([0, 90, 0]) cylinder(d = chamber_tube_d,
                 h = chamber_len - chamber_flange_pos - flange_t);
    }
}

halter();
if (show_aeropress && $preview) ghosts();
