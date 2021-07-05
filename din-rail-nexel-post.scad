// one inch ID tube

id = 25.2;
thick = 3;
rimz = 0.9;
rimx = 0.5;
cutx = 0.2;
din_hole = 25.4;
din_bar = 11;
dinz = 27.6;
height = dinz;
m5nutd = 9.1 + .2;
m5nuth = 3.76 + .2;

difference() {
    union() {
        cylinder(d=id + 3, h=height);
        translate([-(din_hole*1.8 )/2, cutx, 0]) cube([din_hole*1.8, (id + thick)/2 + thick, dinz]);
    }
    // cut away the inside of the tube, and leave a little rim to go in the slot.
    translate([0,0,rimz -0.01]) cylinder(d=id + rimx, h=height + 0.02);
    translate([0,0,-0.01]) cylinder(d=id + 0, h=height + 0.02);
    // cut away half of the circle
    translate([-(id + thick)/2, -height, -0.01]) cube([id + thick, cutx + 30, height+ 0.02]);
    // screw holes.
    for (i = [ +1, -1 ]) {
        translate([i * (din_hole*1.8/2 - m5nutd/2 - 1), (id + thick)/2 + thick + cutx + 0.01 ,dinz/2]) rotate([90,30,0]) cylinder(d=m5nutd, h=m5nuth, $fn = 6);
        translate([i * (din_hole*1.8/2 - m5nutd/2 - 1), (id + thick)/2 + thick + cutx + 0.01 ,dinz/2]) rotate([90,0,0]) cylinder(d2=5, d1=m5nutd-2, h=(id + thick)/2 + thick + cutx, $fn = 20);
    }
}
