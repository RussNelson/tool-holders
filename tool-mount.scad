xsize = 57;
ysize = 18;
radius = 5;

module base(thickness) {
        hull() {
            translate([radius, radius, 0]) cylinder(r=radius, h=thickness);
            translate([xsize-radius, radius, 0]) cylinder(r=radius, h=thickness);
            translate([radius, ysize-radius, 0]) cylinder(r=radius, h=thickness);
            translate([xsize-radius, ysize-radius, 0]) cylinder(r=radius, h=thickness);
        }
}

module 5mm_screwdriver() {
    thickness = 7;
    diameter = 5;

    difference() {
        base(thickness);
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter, h=xsize + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+.5, h=3 + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+1, h=2 + 0.02, $fn=20); 
        translate([-0.01,ysize/2,thickness/2 ]) rotate([0,90,0]) cylinder(d=diameter+1.5, h=1 + 0.02, $fn=20); 
    }
}


module 12mm_screwdriver() {
    thickness = 16;
    diameter = 12;

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


module 8mm_screwdriver() {
    thickness = 12;
    diameter = 8;

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

module small_pliers() {
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


module wrench_straight(post_d, post_h, ttt, thickness = 5, angle=0, tsize=8) {
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
    echo(cos(angle));
    translate([xsize / 2 - 2, ysize / 2, 0]) scale([1 / cos(angle), 1, 1]) union() {
        translate([0, 0,, thickness]) cylinder(d1 = post_d, d2=post_d - slop_width, h=slop_height);
        translate([0, 0,, thickness]) cylinder(d1 = post_d + slop_width, d2=post_d-slop_width/2, h=slop_height/2);
        translate([0, 0,, thickness + slop_height * 3/4]) cylinder(d1 = post_d - slop_width*3/4, d2=post_d-slop_width, h=slop_height/2);
    }
}

module wrench_straight_5_8() {
    post_d = 15.8; // for a combination 5/8" wrench with a flat (rachet) end.
    post_h = 10.7;
    wrench_straight(post_d, post_h, "5/8");
}

module wrench_straight_3_4() {
    thickness = 5;
    post_d = 19.2; // for a combination 3/4" wrench with a flat (rachet) end.
    post_h = 11.4;
    // we need to trim the base off a little bit.
    difference() {
        wrench_straight(post_d, post_h, "3/4", thickness);
        translate([0,ysize + 0.01,0]) base(thickness * 1.5);
        translate([0,-ysize - 0.01,0]) base(thickness * 1.5);
    }
}

module wrench_15_1_2() {
    post_d = 13.1; // for a combination 1/2" wrench with a 15 degree tilt.
    post_h = 8.2;
    wrench_straight(post_d, post_h, "1/2", angle=15);
}

module wrench_15_11_32() {
    post_d = 8.5; // for a combination 11/32" wrench with a 15 degree tilt.
    post_h = 6.2;
    wrench_straight(post_d, post_h, "11/32", angle=15, tsize=5);
}


module wrench_15_3_8() {
    post_d = 9.8; // for a combination 3/8" wrench with a 15 degree tilt.
    post_h = 7.24;
    wrench_straight(post_d, post_h, "3/8", angle=15);
}


// needs two bases.
module small_clippers() {
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
module needlenose_pliers() {
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


*5mm_screwdriver();
*12mm_screwdriver();
*8mm_screwdriver();
*small_pliers();
*small_clippers();
*needlenose_pliers();
*wrench_straight_5_8();
*wrench_straight_3_4();
*wrench_15_1_2();
*wrench_15_11_32();
wrench_15_3_8();

