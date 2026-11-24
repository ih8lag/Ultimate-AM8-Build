// =====================================================================
//  EBB42 CAN housing for the Bear extruder (AM8)  —  v4
//  Bolts through the extruder motor's 4 rear screws (31 x 31 pattern).
//  Hardware: M3 socket head cap screws + M3 heat-set inserts.
// ---------------------------------------------------------------------
//  TRAY  : bolts to the motor; holds the board, gathers the hotend
//          wiring in the "chin" below the board and sends it out of two
//          flared ports (left: hotend fan / heater / thermistor,
//          right: PINDA / print fan). Wires never touch the lid.
//  LID   : same outline as the tray, one straight seam. 2x M3 into inserts
//          in the tray. The side-entry CAN plug sits in a tunnel in the
//          boot; its cable leaves the end of the boot toward the umbilical.
//          Harness ports are split by the seam: lay the wires in, close the lid.
//  PCLIP : optional slim P-clip for a sleeved bundle; goes under an
//          existing M3 screw head (use a screw ~2 mm longer).
//
//  Motor screws: remove ONE AT A TIME, replace with ORIGINAL LENGTH + 10 mm.
//  Frame: X = printer X (right), Y = printer up, Z = forward from the motor,
//         Z = 0 at the motor's rear face.
//  part = "tray" | "lid" | "pclip" | "assembly"   (STLs in print orientation)
// =====================================================================

part = "assembly";

/* ---------- motor / board ---------- */
hole_sp      = 31;
rear_boss_d  = 24;
pcb_w        = 40;
pcb_t        = 1.6;
stack_add    = 10;      // board underside = stack_add - pcb_t above the motor
top_comp_h   = 16;      // top-entry plugs + room for the wires to bend over

/* ---------- outline ---------- */
W            = 51;      // main body (3.5 mm wire gap around the board)
corner_r     = 5;
chin_w       = 34;      // width at the bottom of the chin
chin_y       = -40;     // bottom of the chin
boot_w       = 21;      // CAN boot at the top (centred on the connector)
boot_out     = 12;     // long enough to shroud the plug
ear_x        = 29.5;
ear_r        = 6;
fillet       = 3;

/* ---------- shells ---------- */
wall         = 2;
floor_t      = 2.5;
seam_z       = 8;       // just under the board, so side plugs clear the wall
top_chamfer  = 1;       // bed-side edge of the lid; small so it prints clean face-down
reveal       = 0.6;     // small chamfer each side of the seam
lid_top      = 2;
lip_h        = 2;
lip_t        = 1.2;
fit_clr      = 0.25;

/* ---------- hardware ---------- */
m3_clear     = 3.4;
m3_head_d    = 6.0;
insert_d     = 4.1;
insert_depth = 6;
lid_screw_len= 12;      // both lid screws M3x12
standoff_d   = 7;

/* ---------- harness ports ---------- */
port_d       = 8.5;     // bundle in ~6-8 mm braided sleeve
plug_x       = 0;       // motor plug position along X
motor_slot_w = 16;      // motor-lead slot: passes a JST-XH 4-pin (12.4 x 5.8)
motor_slot_l = 7.5;

/* ---------- CAN plug tunnel (side-entry Micro-Fit at the board's top edge) ---------- */
can_cx       = 6.5;     // connector centre from board centre (measured from the test print)
tun_w        = 13;      // tunnel width  (Micro-Fit 2x2 plug ~10.6 wide)
tun_h        = 12.5;    // tunnel height above the board top (plug ~10.5 tall)
can_d        = 5.0;     // CAN cable outside diameter
tie_w        = 4.2;     // zip tie up to ~3.6 mm wide
tie_t        = 2.0;

/* ---------- P-clip ---------- */
clip_sleeve_d = 7;
clip_t        = 1.6;
clip_w        = 6;

$fn = 56;
eps = 0.01;

/* ---------- derived ---------- */
standoff_top = stack_add - pcb_t;
pcb_z        = standoff_top;
top_z        = max(pcb_z + pcb_t + top_comp_h + lid_top, seam_z + 8);
pcb_top      = pcb_z + pcb_t;
cb_floor     = seam_z + lid_screw_len - (insert_depth - 1);
boot_y1      = W/2 + boot_out;

echo(str("Replacement motor screws: ORIGINAL + ", stack_add, " mm"));
echo(str("Housing face is ", top_z, " mm in front of the motor; lid screws M3x", lid_screw_len));

/* =================== 2D outline =================== */
module rrect(x0, y0, x1, y1, r) {
    translate([x0 + r, y0 + r]) offset(r=r) square([x1 - x0 - 2*r, y1 - y0 - 2*r]);
}
module fil(f) { offset(r=-f) offset(r=f) children(); }

module core2d() {          // body without ears / boot
    fil(fillet) union() {
        rrect(-W/2, -W/2, W/2, W/2, corner_r);
        hull() {
            rrect(-W/2, -W/2, W/2, -W/2 + 12, corner_r);
            rrect(-chin_w/2, chin_y, chin_w/2, chin_y + 12, corner_r);
        }
    }
}
module outline2d() {
    fil(fillet) union() {
        core2d();
        for (s=[-1,1]) hull() {
            translate([s*ear_x, 0]) circle(r=ear_r);
            translate([s*(W/2 - 6) - 3, -ear_r - 2]) square([6, 2*ear_r + 4]);
        }
        rrect(can_cx - boot_w/2, W/2 - 6, can_cx + boot_w/2, boot_y1, 4);
    }
}
module inner2d(extra=0) { offset(r=-wall - extra) core2d(); }

// extrude with chamfered bottom (cb) and top (ct) edges, in thin slices
module chamfer_extrude(h, cb=0, ct=0, n=0) {
    n = n > 0 ? n : max(2, ceil(max(cb, ct) / 0.2));   // one step per ~0.2 mm layer
    union() {
        translate([0,0,cb]) linear_extrude(h - cb - ct) children();
        if (cb > 0) for (i=[0:n-1]) translate([0,0,i*cb/n])
            linear_extrude(cb/n + eps) offset(r=-(cb - (i+1)*cb/n) - eps) children();
        if (ct > 0) for (i=[0:n-1]) translate([0,0,h - ct + i*ct/n - eps])
            linear_extrude(ct/n + eps) offset(r=-(i+1)*ct/n) children();
    }
}

/* =================== TRAY =================== */
// ---- harness ports: centred on each angled chin wall, square to it ----
// corner-circle centres of the chin hull (see core2d)
pc1 = [W/2 - corner_r, -W/2 + corner_r];
pc2 = [chin_w/2 - corner_r, chin_y + corner_r];
pdir = [pc2[0] - pc1[0], pc2[1] - pc1[1]];
pn   = [-pdir[1], pdir[0]] / norm(pdir);            // outward normal (right side)
pmid = (pc1 + pc2)/2 + corner_r * pn;               // point on the outer wall
pang = atan2(pn[1], pn[0]);
mouth  = 1.2;                                       // chamfer on the outside edge

// local frame: origin on the outer wall face, +X = outward, Z = tray Z
module at_port(s) {
    translate([s*pmid[0], pmid[1], 0]) rotate([0,0, s > 0 ? pang : 180 - pang]) children();
}
// round port split by the seam: lower half in the tray, upper half in the lid
module port_split(s) {
    at_port(s) {
        translate([-(wall + 2), 0, seam_z]) rotate([0,90,0]) cylinder(d=port_d, h=wall + 4);
        translate([-mouth, 0, seam_z]) rotate([0,90,0]) cylinder(d1=port_d, d2=port_d + 2*mouth + 0.4, h=mouth + 0.2);
    }
}
module port_relief(s) {     // clears the lid's locating lip above a port
    at_port(s) translate([-(wall + 6), -port_d/2 - 1, seam_z - lip_h - 1]) cube([6, port_d + 2, lip_h + 1 + 2*eps]);
}
module tray_walls() { linear_extrude(seam_z) difference() { outline2d(); inner2d(); } }

module tray() {
    difference() {
        union() {
            chamfer_extrude(seam_z, cb=0.8, ct=reveal) outline2d();
        }
        // pocket
        translate([0,0,floor_t]) linear_extrude(seam_z) inner2d();
        // rear-cap clearance
        translate([0,0,-1]) cylinder(d=rear_boss_d, h=floor_t + 2);
        // motor screws (through standoffs added below)
        for (x=[-1,1], y=[-1,1]) translate([x*hole_sp/2, y*hole_sp/2, -1]) cylinder(d=m3_clear, h=floor_t + 2);
        // zip-tie slots in the boot floor (CAN strain relief, hidden under the lid)
        for (sx=[-1,1]) translate([can_cx + sx*(can_d/2 + 0.5 + tie_t/2) - tie_t/2, boot_y1 - 4 - tie_w/2, -1]) cube([tie_t, tie_w, seam_z + 2]);
        // lid screw inserts in the ears
        for (s=[-1,1]) translate([s*ear_x, 0, seam_z - insert_depth]) cylinder(d=insert_d, h=insert_depth + 1);
        // harness ports
        for (s=[-1,1]) port_split(s);
        // motor lead slot in the chin floor (plug hangs behind it)
        translate([plug_x - motor_slot_w/2, -W/2 - 1 - motor_slot_l, -1]) cube([motor_slot_w, motor_slot_l, floor_t + 2]);
    }
    // board standoffs
    difference() {
        for (x=[-1,1], y=[-1,1]) translate([x*hole_sp/2, y*hole_sp/2, 0]) cylinder(d=standoff_d, h=standoff_top);
        for (x=[-1,1], y=[-1,1]) translate([x*hole_sp/2, y*hole_sp/2, -1]) cylinder(d=m3_clear, h=standoff_top + 2);
        translate([0,0,-1]) cylinder(d=rear_boss_d, h=floor_t + 2);
    }
}

/* =================== LID =================== */
module lid() {
    h = top_z - seam_z;
    difference() {
        union() {
            translate([0,0,seam_z]) chamfer_extrude(h, cb=reveal, ct=top_chamfer) outline2d();
            // locating lip that drops into the tray
            translate([0,0,seam_z - lip_h]) linear_extrude(lip_h + eps) difference() {
                inner2d(fit_clr);
                inner2d(fit_clr + lip_t);
            }
        }
        // lip stops short of the ports so it never pinches the harness
        for (s=[-1,1]) port_relief(s);
        // hollow
        translate([0,0,seam_z - lip_h - 1]) linear_extrude(top_z - lid_top - seam_z + lip_h + 1) inner2d(fit_clr + lip_t);
        // screw holes + counterbores (ears)
        for (p=[[-ear_x,0],[ear_x,0]]) {
            translate([p[0], p[1], seam_z - 1]) cylinder(d=m3_clear, h=h + 2);
            translate([p[0], p[1], cb_floor]) cylinder(d=m3_head_d, h=h);
        }
        // harness ports (upper halves)
        for (s=[-1,1]) port_split(s);
        // CAN tunnel: the plug slides in over the tray wall and sits inside the boot
        translate([can_cx - tun_w/2, W/2 - wall - 4, seam_z - lip_h - 1])
            cube([tun_w, boot_y1 - (W/2 - wall - 4) + 1, pcb_top + tun_h - (seam_z - lip_h - 1)]);
        // vents: chamfered slots
        for (i=[-3:3]) translate([i*4.6, -1, top_z - lid_top - 0.5])
            hull() {
                translate([0, -10, 0]) cylinder(d=2, h=0.1, $fn=16);
                translate([0,  10, 0]) cylinder(d=2, h=0.1, $fn=16);
                translate([0, -10.6, lid_top + 0.49]) cylinder(d=3.2, h=0.1, $fn=16);
                translate([0,  10.6, lid_top + 0.49]) cylinder(d=3.2, h=0.1, $fn=16);
            }
    }
}

/* =================== P-CLIP =================== */
module pclip() {           // closed loop + screw tab, printed standing on its edge
    ri = clip_sleeve_d/2 + 0.2;
    ro = ri + clip_t;
    linear_extrude(clip_w) difference() {
        union() {
            circle(r=ro);
            hull() {
                translate([0, -ro]) square([0.01, clip_t]);
                translate([ri + 9, -ro + 3.5]) circle(r=3.5);
            }
        }
        circle(r=ri);
        translate([ri + 9, -ro + 3.5]) circle(d=m3_clear);
    }
}

/* =================== PREVIEW =================== */
module ghost_pcb() {
    color([0.1,0.5,0.2]) difference() {
        translate([-pcb_w/2, -pcb_w/2, pcb_z]) cube([pcb_w, pcb_w, pcb_t]);
        for (x=[-1,1], y=[-1,1]) translate([x*hole_sp/2, y*hole_sp/2, pcb_z - 1]) cylinder(d=3.2, h=5);
    }
}

if (part == "tray")       tray();
else if (part == "lid")   translate([0,0,top_z]) rotate([180,0,0]) lid();
else if (part == "pclip") pclip();
else if (part == "assembly") {
    color([0.93,0.55,0.15]) tray(); ghost_pcb();
    color([0.25,0.25,0.28,0.9]) lid();
}
