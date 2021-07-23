//bin/sh -c 'grep if.\(workon tool-mount.scad | cut -d\" -f2 | xargs -I X openscad -D workon=\"X\" -o X.stl tool-mount.scad'; exit

workon = "din_rail_adapter";
xsize = 57;
ysize = 18;
radius = 5;

include <../roundedcube.scad>


module base(thickness) {
        hull() {
            translate([radius, radius, 0]) cylinder(r=radius, h=thickness);
            translate([xsize-radius, radius, 0]) cylinder(r=radius, h=thickness);
            translate([radius, ysize-radius, 0]) cylinder(r=radius, h=thickness);
            translate([xsize-radius, ysize-radius, 0]) cylinder(r=radius, h=thickness);
        }
}

// generic screwdriver.
module screwdriver(thickness, diameter) {
    difference() {
        base(thickness);
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter, h=xsize + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+.5, h=5 + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+1, h=4 + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+1.5, h=3 + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+2, h=2 + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+2.5, h=1 + 0.02, $fn=20); 
    }
}

if (workon == "5mm_screwdriver") {
    screwdriver( thickness = 9, diameter = 5);
}

if (workon == "6mm_screwdriver") {
    screwdriver( thickness = 10, diameter = 6);
}

if (workon == "7mm_screwdriver") {
    screwdriver( thickness = 11, diameter = 7);
}

if (workon == "8mm_screwdriver") {
    screwdriver( thickness = 12, diameter = 8 );
}

if (workon == "9mm_screwdriver") {
    screwdriver( thickness = 13, diameter = 9 );
}

if (workon == "10mm_screwdriver") {
    screwdriver( thickness = 14, diameter = 10 );
}

if (workon == "11mm_screwdriver") {
    screwdriver( thickness = 15, diameter = 11 );
}

if (workon == "12mm_screwdriver") {
    screwdriver( thickness = 16, diameter = 12 );
}

if (workon == "small_pliers") {
    xsize2 = 41.5;
    ysize2 = 12.5;
    depth = 9.6;
    thickness = 14;
    diameter = 8;
    tip_diameter = 5.5;

    difference() {
        base(thickness);
        translate([-0.01, (ysize - ysize2)/2, (thickness - depth)/2]) cube([xsize2 + 0.02, ysize2, depth]); 
        translate([xsize2, ysize/2, thickness/2]) rotate([0,90,0]) cylinder(d=tip_diameter, h=xsize - xsize2 + 0.02);
    }
}


module wrench(post_d, post_h, ttt, thickness = 5, angle=0, tsize=8) {
    slop_width = 2;
    slop_height = 2;
    base(thickness);
    difference() {
        union() {
            post_h =  post_h / cos(angle);
            translate([15,ysize/2,thickness]) rotate([0,0,90]) linear_extrude(height=1) text(ttt, tsize, "Arial", halign="center");
            translate([xsize / 2 + post_d/3, ysize / 2, 0]) rotate([0,-angle,0]) union() {
                translate([0, 0, thickness]) cylinder(d=post_d - slop_width, h=post_h);
                // make the post tend to hold the tool
                translate([0, 0, thickness + post_h]) cylinder(d1=post_d -slop_width/2, d2=post_d, h=post_h/2);
                translate([0, 0, thickness + post_h * 1.5]) cylinder(d2=post_d -slop_width*2, d1=post_d, h=post_h/2);
            }
            // make a filet around the base of the post
            translate([xsize / 2 - 2 + post_d/3, ysize / 2, 0]) scale([1 / cos(angle), 1, 1]) union() {
                translate([0, 0,, thickness]) cylinder(d1 = post_d, d2=post_d - slop_width, h=slop_height);
                translate([0, 0,, thickness]) cylinder(d1 = post_d + slop_width, d2=post_d-slop_width/2, h=slop_height/2);
                translate([0, 0,, thickness + slop_height * 3/4]) cylinder(d1 = post_d - slop_width*3/4, d2=post_d-slop_width, h=slop_height/2);
            }
        }
        translate([0,ysize + 0.01,0]) base(thickness);
        translate([0,-ysize - 0.01,0]) base(thickness);
        translate([0,ysize + 0.01,thickness-0.01]) rotate([-9,0,0]) base(post_h);
        translate([0,-ysize - 0.01,thickness-0.01-3]) rotate([9,0,0]) base(post_h);
    }
}

if (workon == "wrench_straight_5_8") {
    post_d = 15.8; // for a combination 5/8" wrench with a flat (rachet) end.
    post_h = 10.7;
    wrench(post_d, post_h, "5/8");
}

if (workon == "wrench_straight_3_4") {
    thickness = 5;
    post_d = 19.2; // for a combination 3/4" wrench with a flat (rachet) end.
    post_h = 11.4;
    // we need to trim the base off a little bit.
    difference() {
        wrench(post_d, post_h, "3/4", thickness);
        translate([0,ysize + 0.01,0]) base(thickness * 1.5);
        translate([0,-ysize - 0.01,0]) base(thickness * 1.5);
    }
}

if (workon == "wrench_15_1_2") {
    post_d = 13.1; // for a combination 1/2" wrench with a 15 degree tilt.
    post_h = 8.2;
    wrench(post_d, post_h, "1/2", angle=15);
}

if (workon == "wrench_15_11_32") {
    post_d = 8.5; // for a combination 11/32" wrench with a 15 degree tilt.
    post_h = 6.2;
    wrench(post_d, post_h, "11/32", angle=15, tsize=5);
}

if (workon == "wrench_15_15_16") {
    post_d = 23.9; // for a combination 15/16" wrench with a 15 degree tilt.
    post_h = 14.0;
    wrench(post_d, post_h, "15/16", angle=15, tsize=5);
}

if (workon == "wrench_15_1") {
    post_d = 26.32; // for a combination 1" wrench with a 15 degree tilt.
    post_h = 14.0;
    wrench(post_d, post_h, "1", angle=15);
}

if (workon == "wrench_15_3_8") {
    post_d = 9.8; // for a combination 3/8" wrench with a 15 degree tilt.
    post_h = 7.24;
    wrench(post_d, post_h, "3/8", angle=15);
}

if (workon == "wrench_15_7_8") {
    thickness = 5;
    post_d = 23.2; // for a combination 7/8" wrench with a 15 degree tilt.
    post_h = 12.0;
    wrench(post_d, post_h, "7/8", thickness, angle=15);
}

if (workon == "wrench_15_3_4") {
    thickness = 5;
    post_d = 20.2; // for a combination 3/4" wrench with a 15 degree tilt.
    post_h = 11.3;
    wrench(post_d, post_h, "3/4", thickness, angle=15);
}


if (workon == "wrench_15_11_16") {
    thickness = 5;
    post_d = 17.5; // for a combination 11/16" wrench with a 15 degree tilt.
    post_h = 10.75;
    wrench(post_d, post_h, "11/16", thickness, angle=15, tsize=5);
}


if (workon == "wrench_15_13_16") {
    thickness = 5;
    post_d = 20.0; // for a combination 13/16" wrench with a 15 degree tilt.
    post_h = 12.3;
    wrench(post_d, post_h, "13/16", thickness, angle=15, tsize=5);
}

// needs two bases.
if (workon == "small_clippers") {
    thickness = 16;
    ytotal = 55;
    spacing = ytotal - ysize - ysize;
    xsize2 = 47;
    ysize2 = 45;
    depth = 12;
    difference() {
        union() {
            base(thickness);
            translate([0, spacing + ysize, 0]) base(thickness);
            translate([radius, ysize, 0]) cube([xsize - radius*2, spacing, thickness]);
        }
        translate([-0.01, (ytotal - ysize2)/2, (thickness - depth)/2]) cube([xsize2 + 0.02, ysize2, depth]); 
    }
}

// needs two bases.
if (workon == "needlenose_pliers") {
    thickness = 16;
    ytotal = 55;
    spacing = ytotal - ysize - ysize;
    xsize2 = 40;
    ysize2 = 45;
    depth = 12;
    tip_diameter = 6.2;
    difference() {
        union() {
            base(thickness);
            translate([0, spacing + ysize, 0]) base(thickness);
            translate([radius, ysize, 0]) cube([xsize - radius*2, spacing, thickness]);
        }
        translate([-0.01, (ytotal - ysize2)/2, (thickness - depth)/2]) cube([xsize2 + 0.02, ysize2, depth]); 
        translate([xsize2-0.01, ysize + spacing/2, thickness/2]) rotate([0,90,0]) scale([1,8.3/6.2,1]) cylinder(d1=tip_diameter*1.8, d2=tip_diameter, h=xsize - xsize2 - radius + 0.02);
    }
}



// needs two bases.
if (workon == "large_needlenose_pliers") {
    thickness = 16;
    ytotal = 55;
    spacing = ytotal - ysize - ysize;
    xsize2 = 55;
    ysize2 = 45;
    depth = 12;
    tip_diameter = 6.2;
    difference() {
        union() {
            base(thickness);
            translate([0, spacing + ysize, 0]) base(thickness);
            translate([radius, ysize, 0]) cube([xsize - radius*2, spacing, thickness]);
        }
        // cut the hole
        translate([-0.02, (ytotal - ysize2)/2, (thickness - depth)/2]) {
            polyhedron([
                [0, 0, 0], [0, ysize2, 0], // 0=lower right front, 1=lower left front
                [0, 0, depth], [0, ysize2, depth], // 2=upper right front, 3=upper left front
                [xsize2 + 0.02, ysize2/2 + spacing/2, depth], [xsize2 + 0.02, ysize2/2 - spacing/2, depth], // 4=upper left back 5=upper right back
                [xsize2 + 0.02, ysize2/2 + spacing/2, 0], [xsize2 + 0.02, ysize2/2 - spacing/2, 0], // 6=lower left back, 7=lower right back
            ],[
                [0,7,6,1], // bottom
                [0,2,5,7], // right
                [1,6,4,3], // left
                [0,1,3,2], // front
                [4,6,7,5], // back
                [2,3,4,5], // top
            ], 2);
        }
    }
}

// needs two bases.
// add 2mm to the measured width of the chisel for ywidth
// you don't need to add any extra to the thickness of the chisel for zsize.
module chisel(thickness, ywidth, zsize, name) {
    sidewall = 5;
    ytotal = ywidth + sidewall*2;
    spacing = ytotal - ysize - ysize;
    if (spacing < 0) {spacing = 0;}
    difference() {
        hull() {
            base(thickness);
            translate([0, spacing + ysize, 0]) base(thickness);
            translate([radius, 0, 0]) cube([xsize - radius*2, ytotal, thickness]);
        }
        translate([0 - 0.01,sidewall,(thickness - zsize) /2]) cube([xsize - 5, ywidth, zsize]);
        translate([0 - 0.01,sidewall,(thickness - zsize) /2])  {
            xsize = 5;
            polyhedron([
                [0, -ywidth*.10, -zsize*.2], [0, ywidth*1.1, -zsize*.2],
                [0, -ywidth*.10, zsize*1.2], [0, ywidth*1.1, zsize*1.2],
                [xsize, 0, zsize], [xsize, ywidth, zsize],
                [xsize, 0, 0], [xsize, ywidth, 0],
            ],[
                [0,1,7,6],
                [0,6,4,2],
                [1,3,5,7],
                [0,2,3,1],
                [4,6,7,5],
                [2,4,5,3],
            ], 2);
        }
    }
    translate([15,ytotal/2,thickness]) rotate([0,0,90]) linear_extrude(height=1) text(name, 8, "Arial", halign="center");
}

if (workon == "20mm_chisel") {
    chisel(10, 20, 6, "20mm");
}
 
if (workon == "27mm_chisel") {
    chisel(10, 27, 6, "27mm");
}
 
if (workon == "40mm_chisel") {
    chisel(14, 40, 7.5, "40mm");
}
 
// needs two bases.
// the bottom could be a wedge to reflect the wedge shape of the level
if (workon == "mini_level") {
    thickness = 22;
    ytotal = 48;
    spacing = ytotal - ysize - ysize;
    xsize2 = 5; // thickness of the wall
    ysize2 = 41; // as measured, 40.5
    depth = 17; // as measured, 16.11
    difference() {
        union() {
            base(thickness);
            translate([0, spacing + ysize, 0]) base(thickness);
            translate([radius, ysize, 0]) cube([xsize - radius*2, spacing, thickness]);
        }
        translate([-0.01, (ytotal - ysize2)/2, (thickness - depth)/2]) cube([xsize - xsize2 + 0.02, ysize2, depth]);
    }
}

// needs two bases.
if (workon == "socket_wrench_3_8") {
    head_diam = 37; // was 35.5
    front_depth = 3;
    front_diam = 27.7; // was 27.0
    back_diam = 27.7;
    back_depth = 3.8; // was 3.5
    handle_diam = 15;
    depth = 16.0;
    thickness = depth + 6 + 3; // 14.8 as measured

    ytotal = 45;
    spacing = ytotal - ysize - ysize;
    difference() {
        union() {
                base(thickness);
                translate([0, spacing + ysize, 0]) base(thickness);
                translate([radius, ysize, 0]) cube([xsize - radius*2, spacing, thickness]);
        }
        // cut a hole for the main head.
        translate([xsize, ytotal/2, thickness - depth - front_depth]) cylinder(d = head_diam + 0.02, h=depth + 0.01);
        // cut several holes for the handle filet.
        translate([xsize-head_diam*1/4, ytotal/2, thickness - depth - front_depth]) cylinder(d = head_diam*3/4 + 0.02, h=depth + 0.01);
        translate([xsize-head_diam*2/5, ytotal/2, thickness - depth - front_depth]) cylinder(d = head_diam/2 + 0.02, h=depth + 0.01);
        translate([xsize-head_diam*3/6, ytotal/2, thickness - depth - front_depth]) cylinder(d = head_diam*2/5 + 0.02, h=depth + 0.01);
        translate([xsize-head_diam*4/7, ytotal/2, thickness - depth - front_depth]) cylinder(d = head_diam*2/6 + 0.02, h=depth + 0.01);
        translate([xsize-head_diam*5/8, ytotal/2, thickness - depth - front_depth]) cylinder(d = head_diam*2/7 + 0.02, h=depth + 0.01);
        translate([xsize-head_diam*7/10, ytotal/2, thickness - depth - front_depth]) cylinder(d = head_diam*2/8 + 0.02, h=depth + 0.01);
        // cut a hole for the front
        translate([xsize, ytotal/2, thickness - front_depth]) cylinder(d = front_diam + 0.02, h=front_depth + 0.01);
        // cut a hole behind the head for the direction changer.
        translate([xsize, ytotal/2, thickness - depth - back_depth - front_depth + 0.01]) cylinder(d = back_diam + 0.02, h=back_depth + 0.01);
        // cut a channel for the handle.
        translate([0, ytotal/2, thickness - handle_diam/2 - front_depth]) rotate([0,90,0]) cylinder(d = handle_diam + 0.02, h=xsize);
        translate([0, ytotal/2 - handle_diam/2, thickness - handle_diam/2 - front_depth]) cube([xsize, handle_diam, handle_diam/2 + front_depth + 0.01]);
    }
}

// needs three bases.
if (workon == "fluke_115") {
    depth = 44.5;
    front_depth = 3;
    bottom_z = 6;
    thickness = depth + bottom_z + 3;
    lid_z = thickness - depth - bottom_z + 0.02;

    ywidth = 72;
    yextra = 10;
    yopening = 68;
    ytotal = ywidth + yextra*2;
    spacing = ytotal - ysize - ysize;
    difference() {
        union() {
                base(thickness); // left
                translate([0, spacing + ysize, 0]) base(thickness); // right
                translate([0, (ytotal/2 - ysize/2), 0]) base(thickness); // middle
                translate([radius, ysize, 0]) cube([xsize - radius*2, spacing, thickness]);
        }
        translate([-0.01, (ytotal - ywidth)/2, 6]) roundedcube([xsize + 0.02, ywidth, depth], radius=(ywidth - yopening)/2, apply_to="x");
        translate([-0.01, (ywidth-yopening)/2 + yextra, depth + bottom_z - 0.01]) {
            cube([xsize + 0.02, yopening, lid_z]);
            *polyhedron([
                [0, 0, 0], [0, ywidth, 0],
                [0, (ywidth-yopening)/2, lid_z], [0, yopening, lid_z],
                [xsize + 0.02, (ywidth-yopening)/2, lid_z], [xsize + 0.02, yopening, lid_z],
                [xsize + 0.02, 0, 0], [xsize + 0.02, ywidth, 0],
            ],[
                [0,1,7,6],
                [0,6,4,2],
                [1,3,5,7],
                [0,2,3,1],
                [4,6,7,5],
                [2,4,5,3],
            ], 2);
        }
    }
}

din_zthick = 1.5; // was 1.25, was 1.05. steel is 1.02, aluminum is 1.05

// no bases, goes on the end by itself
if (workon == "endstop") {
    // inspired by https://thingiverse.com/thing:4757574747474747474747474
    // but it has the problem that the screw puts the plastic in tension, where it should put it in compression.
    zsize = 10;
    xsize = 46;
    ysize = 36; // off the top of the hat
    corner = 10;
    din_xsize = 35 + .1; // apparently 35 is nominal. Steel is -.1, aluminum is -.4
    din_xwidth = 27.5; // was 27.1 which was definitely wrong. steel is 26.9 aluminum is 27.1
    din_zsize = 5.5; // gap between wall and bottom of lip: steel is 5.5, aluminum is 7.2
    screw_head = 6;
    screw = 3;
    nuty = 2.7;
    nutz = 7.00; // was 5.68
    nutx = screw/2 + (xsize - din_xsize)/2;
    nutbase = 10.67;
    outline = [
        [0, 0],
        [0, ysize-corner],
        [corner, ysize],
        [xsize-corner, ysize],
        [xsize, ysize-corner],
        [xsize, 0],
        [xsize - (xsize - din_xwidth)/2, 0],
        [xsize - (xsize - din_xwidth)/2, din_zsize],
        [xsize - (xsize - din_xsize)/2, din_zsize],
        [xsize - (xsize - din_xsize)/2, din_zsize + din_zthick],
        // now unwind the last 4
        [(xsize - din_xsize)/2, din_zsize + din_zthick],
        [(xsize - din_xsize)/2, din_zsize],
        [(xsize - din_xwidth)/2, din_zsize],
        [(xsize - din_xwidth)/2, 0],
        [0, 0],
    ];
    difference() {
        linear_extrude(height = zsize) polygon(outline);
        // cut a screw, head, and nut
        translate([nutx, din_zsize + din_zthick-0.01, zsize/2]) rotate([-90,0,0]) cylinder(h=ysize - corner - din_zsize + din_zthick, d=screw);
        translate([nutx, ysize - corner, zsize/2]) rotate([-90,0,0]) cylinder(h=corner, d=screw_head);
        // cut a nut
        translate([nutx, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        translate([nutx/2, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        translate([nutx/3, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        translate([nutx/4, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        translate([0, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        // do the other side
        translate([xsize - nutx, din_zsize + din_zthick-0.01, zsize/2]) rotate([-90,0,0]) cylinder(h=ysize - corner - din_zsize + din_zthick, d=screw);
        translate([xsize - nutx, ysize - corner, zsize/2]) rotate([-90,0,0]) cylinder(h=corner, d=screw_head);
        translate([xsize - nutx, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        translate([xsize - nutx/2, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        translate([xsize - nutx/3, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        translate([xsize - nutx/4, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
        translate([xsize - 0, nutbase, zsize/2]) rotate([-90,0,0]) cylinder(h=nuty, d=nutz, $fn=6);
    }
}

module peg(peg_d) {
    peg_h = 8;
    // from top to bottom.
    translate([0,0,peg_h + peg_h]) cylinder(d1=peg_d, d2 = peg_d-2, h=2);
    translate([0,0,peg_h]) cylinder(d2=peg_d, d1 = peg_d-2, h=peg_h);
    translate([0,0,0]) cylinder(d1=peg_d, d2=peg_d-2, h=peg_h);
    // create a filet
    translate([0,0,0]) cylinder(d1=peg_d+2, d2=peg_d - .6, h=2);
    translate([0,0,0]) cylinder(d1=peg_d+4, d2=peg_d+2 - 1.2, h=1);
}

// needs three bases.
module vice_grip(model, name) {
    thickness = 5;
    ywrench = model;
    peg_d = 10;
    ytotal = ywrench + peg_d*2 + ysize/2;
    spacing = ytotal - ysize - ysize;
    base(thickness);
    translate([0, spacing + ysize, 0]) base(thickness);
    translate([0, (ytotal/2 - ysize/2), 0]) base(thickness); // middle
    translate([radius, 0, 0]) cube([xsize - radius*2, ytotal, thickness]);
    translate([20,ytotal/2 - ywrench/2 - peg_d/2,thickness]) peg(peg_d);
    translate([20,ytotal/2 + ywrench/2 + peg_d/2,thickness]) peg(peg_d);
    translate([20 + peg_d*3/4,ysize/2,thickness]) linear_extrude(height=1) text(name, 8, "Arial", valign="center");
}

// This is for the genuine Irwin Vice-Grip(tm) 6LN (long nose)
if (workon == "vise_grip_6LN") {
    vice_grip(32.5, "6LN");
}

// This is for the genuine Irwin Vice-Grip(tm) 7R (small)
if (workon == "vise_grip_7R") {
    vice_grip(41, "7R");
}

// This is for the genuine Irwin Vice-Grip(tm) (standard)
if (workon == "vise_grip_10CR") {
    vice_grip(48, "10CR");
}

spring_outer_d = 3.87;
spring_x = 2.8;
spring_y = 8.25;
arm_y = spring_y - spring_outer_d;

module spring_turn(catch_z) {
    spring_inner_d = spring_outer_d - spring_x;
    difference() {
        cylinder(d=spring_outer_d, h=catch_z);
        translate([0,0,-0.01]) cylinder(d=spring_inner_d, h=catch_z+0.02);
        translate([-spring_outer_d/2,-spring_outer_d,-0.01]) cube([spring_outer_d, spring_outer_d, catch_z+0.02]);
    }
    translate([spring_inner_d/2,-arm_y,0]) cube([spring_x/2, arm_y, catch_z]);
}


// reinvented from DIN_Rail_Adapter
if (workon == "din_rail_adapter") {
    latching = true;
    thickness = 4.6;
    thickness_catch = 8.0;
    opening_y = 10;
    opening_x = 41.5;
    opening_x_off = 5.5;
    latch_z = 2;
    latch_x = 5;
    // the top catch.
    difference() {
        translate([0, 0, 0.01]) base(thickness_catch - 0.01);
        translate([-0.01, -0.01, 0]) cube([opening_x_off + opening_x + 0.01, ysize+0.01, thickness + din_zthick  + 0.01]);
        translate([-0.01, -0.01, 0]) cube([opening_x_off + opening_x - 1 + 0.01, ysize+0.01, thickness_catch + 0.01]);
    }

    retainer_hole_x = 15.4;
    retainer_x = 9.75;
    
    // cut an opening in the base for the catch and retainer
    difference() {
        base(thickness);
        translate([opening_x_off, (ysize - opening_y)/2, -0.01]) roundedcube([opening_x, opening_y, thickness + 0.02], radius=2, apply_to="z");
        if (latching) {
            translate([0-0.01, (ysize - opening_y)/2, -0.01]) cube([opening_x_off + 2, opening_y, latch_z+ 0.02]);
        }
    }

    catch_x = 20;
    catch_x_off = 3;
    catch_y = 8;
    catch_z = 4;
    springend_d = 4.75;
    din_catch_x = 5;

    // catch
    translate([catch_x_off + opening_x_off, (opening_y - catch_y)/2 + (ysize - opening_y)/2, 0]) {
        roundedcube([catch_x, catch_y, catch_z], radius=1, apply_to="z");
        difference() {
            roundedcube([din_catch_x, catch_y, thickness_catch], radius=1, apply_to="z");
            translate([din_catch_x - 1,-0.01, thickness]) cube([1 + 0.01, catch_y + 0.02, din_zthick]);
            translate([din_catch_x,-0.01, thickness + din_zthick + 0.3]) rotate([0,-45,0]) cube([2 + 0.01, catch_y + 0.02, 10]);
        }
    }
    if (latching) {
        difference() {
            translate([-latch_x, (opening_y - catch_y)/2 + (ysize - opening_y)/2, 0]) cube([catch_x_off + opening_x_off + latch_x + 1, catch_y, latch_z-0.5]);
            translate([-latch_x + 2, (ysize/2 - 2.5), -0.01]) cube([2, 5, 5]);
        }
        // add anti-removal bars
        translate([catch_x_off + opening_x_off, 0, thickness]) cube([din_catch_x -1.7, (ysize - opening_y)/2, thickness_catch - thickness]);
        translate([catch_x_off + opening_x_off, ysize - (ysize - opening_y)/2, thickness]) cube([din_catch_x -1.7, (ysize - opening_y)/2, thickness_catch - thickness]);
    }

    // bottom and top spring end
    translate([catch_x_off + opening_x_off + catch_x, ysize/2, 0]) cylinder(d=springend_d, h=catch_z);
    translate([opening_x_off + opening_x, ysize/2, 0]) cylinder(d=springend_d, h=catch_z);
    translate([.4, .5, 0]) {
        translate([catch_x_off + opening_x_off + catch_x + springend_d/2, ysize/2 + 3.2/2, 0]) spring_turn(catch_z);
        translate([catch_x_off + opening_x_off + catch_x + springend_d/2, ysize/2 + 3.2/2, 0]) mirror([1,0,0]) spring_turn(catch_z);
        translate([catch_x_off + opening_x_off + catch_x + springend_d/2 + (spring_outer_d - spring_x/2)*1, ysize/2 + 3.2/2 - arm_y, 0]) mirror([0,1,0]) spring_turn(catch_z);
        translate([catch_x_off + opening_x_off + catch_x + springend_d/2 + (spring_outer_d - spring_x/2)*2, ysize/2 + 3.2/2, 0]) spring_turn(catch_z);
        translate([catch_x_off + opening_x_off + catch_x + springend_d/2 + (spring_outer_d - spring_x/2)*3, ysize/2 + 3.2/2 - arm_y, 0]) mirror([0,1,0]) spring_turn(catch_z);
        translate([catch_x_off + opening_x_off + catch_x + springend_d/2 + (spring_outer_d - spring_x/2)*4, ysize/2 + 3.2/2, 0]) spring_turn(catch_z);
        translate([catch_x_off + opening_x_off + catch_x + springend_d/2 + (spring_outer_d - spring_x/2)*5, ysize/2 + 3.2/2 - arm_y, 0]) mirror([0,1,0]) spring_turn(catch_z);
    }
}

