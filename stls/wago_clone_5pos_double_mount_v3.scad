// Double mount for 5-position Wago-style lever connectors (clones)
// Flat back for mounting on aluminium extrusion (e.g. 2020) with M5 T-nuts.
// All dimensions in mm.

/* [Connector] */
CL = 35.0;      // connector length (along the levers)
CD = 21.0;      // connector depth (wire-entry direction)
CH = 11.0;      // connector height (reference only)

/* [Fit] */
TOL   = 0.3;    // clearance per side, depth
TOLX  = 0.5;    // clearance per side, length
// side snap-lip overhang into each pocket, listed left to right
// as seen looking at the open wire side, levers up
LIPS  = [0.55, 0.55];

/* [Body] */
N     = 2;      // number of connectors
BASE  = 3.0;    // base plate thickness
WALL  = 2.4;    // end / divider wall thickness
BACK  = 2.0;    // back wall thickness
WALLH = 8.0;    // wall height above base
FLIPH = 2.0;    // front lip height above base
FLIPT = 1.6;    // front lip thickness

/* [Mounting] */
TAB   = 11.0;   // screw tab length at each end
HOLE  = 5.5;    // screw clearance hole (M5)
HEAD  = 9.2;    // screw head seat diameter
PUSH  = 8.0;    // push-out hole under each pocket

$fn = 48;

PL = CL + 2*TOLX;   // pocket length
PD = CD + 2*TOL;    // pocket depth
L  = 2*TAB + N*PL + (N+1)*WALL;
D  = PD + BACK;
x0 = TAB;

// sloped snap lip on a wall face; dir = +1 points +X, -1 points -X
module side_lip(xpos, dir, lip) {
    translate([xpos, PD - 0.5, BASE + WALLH - 2.4])
        mirror([dir < 0 ? 1 : 0, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(PD - 1.0)
                    polygon([[0, 0], [lip, 0.6], [lip, 1.2], [0, 2.2]]);
}

module mount() {
    difference() {
        union() {
            // base plate
            cube([L, D, BASE]);
            // back wall
            translate([x0, PD, 0]) cube([N*PL + (N+1)*WALL, BACK, BASE + WALLH]);
            // end + divider walls with side lips
            for (i = [0 : N]) {
                wx = x0 + i*(PL + WALL);
                translate([wx, 0, 0]) cube([WALL, PD, BASE + WALLH]);
                if (i > 0) side_lip(wx, -1, LIPS[i-1]);
                if (i < N) side_lip(wx + WALL, +1, LIPS[i]);
            }
            // front: base extension, lips, wall stubs
            translate([0, -FLIPT, 0]) cube([L, FLIPT, BASE]);
            for (i = [0 : N-1])
                translate([x0 + WALL + i*(PL + WALL), -FLIPT, BASE]) cube([PL, FLIPT, FLIPH]);
            for (i = [0 : N])
                translate([x0 + i*(PL + WALL), -FLIPT, 0]) cube([WALL, FLIPT, BASE + FLIPH]);
        }
        // push-out holes
        for (i = [0 : N-1])
            translate([x0 + WALL + i*(PL + WALL) + PL/2, PD/2, -1])
                cylinder(h = BASE + 2, d = PUSH);
        // screw holes + head seats
        for (sx = [TAB/2, L - TAB/2]) {
            translate([sx, D/2, -1]) cylinder(h = BASE + 2, d = HOLE);
            translate([sx, D/2, BASE - 1]) cylinder(h = 2, d = HEAD);
        }
    }
}

translate([0, FLIPT, 0]) mount();
