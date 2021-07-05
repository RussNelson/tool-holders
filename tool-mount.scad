//bin/sh -c 'grep if.\(workon tool-mount.scad | cut -d\" -f2 | xargs -I X openscad -D workon=\"X\" -o X.stl tool-mount.scad'; exit

workon = "20mm_chisel";
xsize = 57;
ysize = 18;
radius = 5;

// make a base which matches Din_Rail_Adapter.
module base(thickness) {
        hull() {
            translate([radius, radius, 0]) cylinder(r=radius, h=thickness);
            translate([xsize-radius, radius, 0]) cylinder(r=radius, h=thickness);
            translate([radius, ysize-radius, 0]) cylinder(r=radius, h=thickness);
            translate([xsize-radius, ysize-radius, 0]) cylinder(r=radius, h=thickness);
        }
}

// generic screwdriver. Add more easement for larger diameters.
module screwdriver(thickness, diameter, easement=6) {
    difference() {
        base(thickness);
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter, h=xsize + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+.5, h=5 + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+1, h=4 + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+1.5, h=3 + 0.02, $fn=20); 
        if (easement >= 6) {
            translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+2, h=2 + 0.02, $fn=20); 
            translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+2.5, h=1 + 0.02, $fn=20); 
        }
    }
}


if (workon == "5mm_screwdriver") {
    screwdriver( thickness = 7, diameter = 5, easement=4);
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
    post_h =  post_h / cos(angle);
    translate([15,ysize/2,thickness]) rotate([0,0,90]) linear_extrude(height=1) text(ttt, tsize, "Arial", halign="center");
    translate([xsize / 2, ysize / 2, 0]) rotate([0,-angle,0]) union() {
        translate([0, 0, thickness]) cylinder(d=post_d - slop_width, h=post_h);
        // make the post tend to hold the tool
        translate([0, 0, thickness + post_h]) cylinder(d1=post_d -slop_width/2, d2=post_d, h=post_h/2);
        translate([0, 0, thickness + post_h * 1.5]) cylinder(d2=post_d -slop_width*2, d1=post_d, h=post_h/2);
    }
    // make a filet around the base of the post
    translate([xsize / 2 - 2, ysize / 2, 0]) scale([1 / cos(angle), 1, 1]) union() {
        translate([0, 0,, thickness]) cylinder(d1 = post_d, d2=post_d - slop_width, h=slop_height);
        translate([0, 0,, thickness]) cylinder(d1 = post_d + slop_width, d2=post_d-slop_width/2, h=slop_height/2);
        translate([0, 0,, thickness + slop_height * 3/4]) cylinder(d1 = post_d - slop_width*3/4, d2=post_d-slop_width, h=slop_height/2);
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


if (workon == "wrench_15_3_8") {
    post_d = 9.8; // for a combination 3/8" wrench with a 15 degree tilt.
    post_h = 7.24;
    wrench(post_d, post_h, "3/8", angle=15);
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
if (workon == "20mm_chisel") {
    thickness = 10;
    zsize = 6;
    ywidth = 20;
    difference() {
        hull() {
            base(thickness);
            translate([0, ysize, 0]) base(thickness);
        }
        translate([0 - 0.01,(ysize*2 -ywidth)/2,(thickness - zsize) /2]) cube([xsize - 5, ywidth, zsize]);
        translate([0 - 0.01,(ysize*2 -ywidth)/2,(thickness - zsize) /2])  {
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
}
 
