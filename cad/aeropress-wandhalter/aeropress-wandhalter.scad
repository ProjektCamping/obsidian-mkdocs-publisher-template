// ============================================================
//  AeroPress Wandhalter mit Entnahme nach vorne
//
//  Beide Teile der (normalen) AeroPress liegen waagerecht mit
//  der Achse zum Betrachter, hintereinander auf gleicher Höhe:
//    - hinten: Kolben  (Griffteller in runder Profil-Nut)
//    - vorne:  Korpus  (Sechskant-Flansch in Sechskant-Nut)
//
//  Jedes Teil liegt auf zwei Kamm-Scheiben:
//    1. Profil-Scheibe (12 mm): dreilagige Nut - der Flansch/
//       Teller fällt in sein Profil (Sechskant bzw. rund) und
//       ist dadurch axial in beide Richtungen gesperrt.
//    2. Sattel-Scheibe weiter vorne: trägt das Rohr. Ihr Maul
//       ist oberhalb der Mulde verbreitert, damit Teller bzw.
//       Flansch beim Herausziehen hindurchpassen.
//
//  Entnahme: Teil ca. 2 cm anheben und gerade nach vorne
//  herausziehen. Erst den Korpus (vorne), dann den Kolben -
//  der Kolben kommt dabei über die (dann leeren) vorderen
//  Scheiben hinweg. Einsetzen in umgekehrter Reihenfolge.
//
//  Montage: Rückplatte mit 4 Senkkopfschrauben (4 x 25 o. ä.)
//  an die Holzwange, Teile-Achsen zeigen zum Betrachter.
//
//  Koordinaten: Holzwand = Ebene x=0 (Halter bei x<0),
//  y nach vorne (zum Betrachter), z nach oben.
// ============================================================

$fa = 2;
$fs = 0.4;

// ---------- AeroPress-Maße (VOR DEM DRUCK NACHMESSEN!) ------
chamber_tube_d  = 70;    // Korpus: Rohr-Außendurchmesser
chamber_hex_af  = 92.8;  // Korpus: Sechskant-Flansch Schlüsselweite
                         // (offiziell 107.2 mm über Eck * cos30)
chamber_stub_d  = 76;    // Korpus: Kragen oberhalb/hinter dem Flansch
chamber_len     = 121;   // Korpus: Gesamtlänge
chamber_flange_pos = 8;  // Abstand Oberkante -> Flansch-Beginn
plunger_tube_d  = 63;    // Kolben: Rohr-Außendurchmesser
plunger_rim_d   = 83.3;  // Kolben: Griffteller-Durchmesser
plunger_len     = 133;   // Kolben: Gesamtlänge
flange_t        = 6;     // Dicke Flansch / Griffteller

// ---------- Spiel ----------
slot_play   = 2.2;       // Rohr-Mulden = Rohr-Ø + slot_play
pocket_play = 2.4;       // Profil-Nuten = Flansch + pocket_play
groove_w    = flange_t + 1;   // Nutbreite (axial)

// ---------- Aufbau ----------
plate_t   = 8;           // Rückplatte (liegt am Holz an)
wall      = 6;           // Material um Ausschnitte
z_axis    = 50;          // Achshöhe beider Teile über Plattenmitte
axis_x    = -64;         // Achsabstand von der Holzwand
corner_r  = 6;           // Eckenradius
fin_x1    = -126;        // linke Kante aller Scheiben (einheitlich)
fin_z0    = -10;         // Unterkante aller Scheiben

// Kolben-Station (hinten)
pf_y     = 5.5;          // Profil-Scheibe: Rückseite
pf_top   = 27;           // Profil-Scheibe: Oberkante
ps_y     = 90;           // Sattel-Scheibe: Rückseite
ps_t     = 6;
ps_top   = 42;
ps_mouth = 27.5;         // ab hier verbreitertes Maul

// Korpus-Station (vorne)
cf_y     = 149;
cf_top   = 24;
cs_y     = 214;
cs_t     = 6;
cs_top   = 42;
cs_mouth = 22;

plate_l  = 230;          // Rückplatte: Tiefe (y)
plate_z0 = -12;
plate_z1 = 55;

screw_d      = 4.5;
screw_head_d = 9;

// ---------- abgeleitet ----------
wall_t         = (12 - groove_w) / 2;      // Wanddicke der Profil-Scheiben
plunger_groove = plunger_rim_d + pocket_play;
chamber_groove = chamber_hex_af + pocket_play;
plunger_slot   = plunger_tube_d + slot_play;
chamber_slot   = chamber_tube_d + slot_play;
rim_pass       = plunger_rim_d + 3.2;                 // Maul für Griffteller
hex_pass       = chamber_hex_af / cos(30) + 3.2;      // Maul für Sechskant

// ============================================================

module rounded_rect(w, h, r) {
    offset(r = r) offset(delta = -r) square([w, h]);
}

// Sechskant mit Fläche unten/oben, sw = Schlüsselweite
module hex2d(sw) {
    circle(d = sw / cos(30), $fn = 6);
}

// nach oben offener Kanal, rundes Profil
module chan_circle(d) {
    hull() {
        translate([axis_x, z_axis]) circle(d = d);
        translate([axis_x, z_axis + 300]) circle(d = d);
    }
}

// nach oben offener Kanal, Sechskant-Profil
module chan_hex(sw) {
    hull() {
        translate([axis_x, z_axis]) hex2d(sw);
        translate([axis_x, z_axis + 300]) hex2d(sw);
    }
}

// Rohr-Mulde mit verbreitertem Maul ab Höhe zm
module chan_mouth(w_seat, w_mouth, zm) {
    chan_circle(w_seat);
    translate([axis_x - w_mouth/2, zm]) square([w_mouth, 300]);
}

// Scheiben-Rohling (Profil x-z, Dicke t, Rückseite bei y0)
module fin_slab(y0, t, z_top) {
    translate([0, y0 + t, 0])
        rotate([90, 0, 0])
            linear_extrude(t)
                translate([fin_x1, fin_z0])
                    rounded_rect(-fin_x1 - 4, z_top - fin_z0, corner_r);
}

// Ausschnitt über einen y-Bereich (children = 2D-Profil in x-z)
module cut_layer(y0, y1) {
    translate([0, y1, 0])
        rotate([90, 0, 0])
            linear_extrude(y1 - y0)
                children();
}

// Rückplatte mit 4 Senkkopf-Schraublöchern
module backplate() {
    screw_pos = [[55, -2], [55, 46], [197, -2], [197, 46]];   // [y, z]
    difference() {
        translate([0, 0, plate_z0])
            rotate([0, -90, 0])                // 2D-x -> z, Extrusion -> -x
                linear_extrude(plate_t)
                    rounded_rect(plate_z1 - plate_z0, plate_l, corner_r);
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

module halter() {
    backplate();

    // ---- Kolben: Profil-Scheibe (Rückwand massiv als Anschlag,
    //      Mitte runde Nut für den Griffteller, Vorderwand Rohr-Mulde)
    difference() {
        fin_slab(pf_y, 12, pf_top);
        cut_layer(pf_y + wall_t, pf_y + wall_t + groove_w)
            chan_circle(plunger_groove);
        cut_layer(pf_y + wall_t + groove_w, pf_y + 12 + 0.1)
            chan_circle(plunger_slot);
    }
    // ---- Kolben: Sattel-Scheibe
    difference() {
        fin_slab(ps_y, ps_t, ps_top);
        cut_layer(ps_y - 0.1, ps_y + ps_t + 0.1)
            chan_mouth(plunger_slot, rim_pass, ps_mouth);
    }

    // ---- Korpus: Profil-Scheibe (Rückwand Kragen-Mulde,
    //      Mitte Sechskant-Nut, Vorderwand Rohr-Mulde)
    difference() {
        fin_slab(cf_y, 12, cf_top);
        cut_layer(cf_y - 0.1, cf_y + wall_t)
            chan_circle(chamber_stub_d + 3);
        cut_layer(cf_y + wall_t, cf_y + wall_t + groove_w)
            chan_hex(chamber_groove);
        cut_layer(cf_y + wall_t + groove_w, cf_y + 12 + 0.1)
            chan_circle(chamber_slot);
    }
    // ---- Korpus: Sattel-Scheibe
    difference() {
        fin_slab(cs_y, cs_t, cs_top);
        cut_layer(cs_y - 0.1, cs_y + cs_t + 0.1)
            chan_mouth(chamber_slot, hex_pass, cs_mouth);
    }
}

// Transparente AeroPress-Teile zur Passkontrolle (nur Vorschau)
show_aeropress = true;
module ghosts() {
    // Kolben: Teller in der Nut der hinteren Profil-Scheibe
    color("SteelBlue", 0.35) translate([axis_x, 0, z_axis]) {
        translate([0, pf_y + wall_t + 0.5, 0])
            rotate([-90, 0, 0]) cylinder(d = plunger_rim_d, h = flange_t);
        translate([0, pf_y + wall_t + 0.5 + flange_t, 0])
            rotate([-90, 0, 0]) cylinder(d = plunger_tube_d,
                                         h = plunger_len - flange_t);
    }
    // Korpus: Sechskant-Flansch in der Nut der vorderen Profil-Scheibe
    color("IndianRed", 0.35) translate([axis_x, 0, z_axis]) {
        translate([0, cf_y + wall_t + 0.5 - chamber_flange_pos, 0])
            rotate([-90, 0, 0]) cylinder(d = chamber_stub_d,
                                         h = chamber_flange_pos);
        translate([0, cf_y + wall_t + 0.5, 0])
            rotate([-90, 0, 0]) linear_extrude(flange_t)
                hex2d(chamber_hex_af);
        translate([0, cf_y + wall_t + 0.5 + flange_t, 0])
            rotate([-90, 0, 0]) cylinder(d = chamber_tube_d,
                 h = chamber_len - chamber_flange_pos - flange_t);
    }
}

halter();
if (show_aeropress && $preview) ghosts();
