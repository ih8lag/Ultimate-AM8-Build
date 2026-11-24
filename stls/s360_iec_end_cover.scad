// Redrex S-360-24 terminal-end cover for AM8 (PSU mounted vertically on the
// right-side Z 2040, terminal end DOWN, mounting face against the extrusion).
// IEC switch/fuse/C14 module on the BACK face (narrow side toward the rear of the printer).
// Side facing the extrusion is open for wiring into the frame.
// All dimensions in mm. Edit parameters, F6, export STL.
//
// Model axes (as installed):
//   Y = along the PSU; Y=0 is the PSU's terminal end, +Y points DOWN toward the base
//   Z = outward from the extrusion; Z=0 is the PSU mounting face (open side)
//   X = front/back; -X is the BACK of the printer
// Exported STL: rotated so the down-facing end sits on the bed, i.e. same as installed.

/* [PSU] */
psu_w   = 115;
psu_h   = 50;
clr     = 0.4;

/* [Cover] */
wall    = 2.4;
overlap = 52;    // how far the cover reaches up the PSU (open side faces the plate, so no clash)
ext     = 58;    // how far it hangs below the PSU end (needs ~56 for the IEC module)

/* [Side retaining screws: M4 into PSU side holes] */
side_screw_y   = -40;          // PSU side holes: 40 mm up from the terminal end (as seated)
side_screw_zs  = [12.5, 37.5]; // two holes across each 50 mm side face
side_slot_len  = 8.5;          // vertical slot = 4 mm of up/down play
side_screw_d   = 4.5;

/* [IEC module] */
iec_cut_long   = 47.5;
iec_cut_short  = 27.5;
iec_screw_sp   = 40;    // screw spacing, across the short side
iec_screw_d    = 3.4;
iec_side       = -1;    // -1 = back of printer, +1 = front (flip if your mount is mirrored)

/* [Corner notch for HBLFSNF5 brackets at the foot of the 2040] */
notch_w = 19;   // back from the front (2040-side) face
notch_h = 40;   // up from the bottom
notch_d = 22;   // in from the open side (bracket's longest leg ~20 + 2 clearance)

$fn = 48;

iw = psu_w + 2*clr;
ih = psu_h + clr;
ow = iw + 2*wall;
oh = ih + wall;
od = overlap + ext + wall;

module iec_cutout() {
    // long axis runs along Y (vertical when installed), screws across Z
    translate([iec_side*(iw/2 + wall/2), overlap + ext/2, ih/2])
    rotate([0, 90, 0]) {
        cube([iec_cut_short, iec_cut_long, 3*wall], center = true);
        for (s = [-1, 1])
            translate([s*iec_screw_sp/2, 0, 0])
                cylinder(d = iec_screw_d, h = 3*wall, center = true);
    }
}

module side_slots() {
    for (s = [-1, 1], hz = side_screw_zs)
        translate([s*(iw/2 + wall/2), overlap + side_screw_y, hz])
        rotate([0, 90, 0])
        hull() for (d = [-1, 1])
            translate([0, d*(side_slot_len - side_screw_d)/2, 0])
                cylinder(d = side_screw_d, h = 3*wall, center = true);
}

difference() {
    translate([-ow/2, 0, 0]) cube([ow, od, oh]);
    translate([-iw/2, -1, -1]) cube([iw, overlap + ext + 1, ih + 1]);  // open top (PSU) + open extrusion side
    iec_cutout();
    side_slots();
    // notch around the 2040 corner bracket (bottom front corner, from the open side)
    translate([ow/2 - notch_w, od - notch_h, -5]) cube([notch_w + 1, notch_h + 1, notch_d + 5]);
}
