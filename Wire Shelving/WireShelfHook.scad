// Wire Shelf Hooks
//
// Hooks to hold the wire shelf. Mounted to the wall with screws.
//
// Daniel Winker, January 30, 2022

w = 12;  // Width
h = 33;  // Height
d = 13;  // Depth
t = 3;  // Thickness of the hook between shelf and wall

sd = 4;  // Screw diameter
shd = 10.5;  // Screw head diameter
shr = 1;  // Screw head recess
wd = 7;  // Wire diameter (i.e. diameter of what this latches onto)
sh = 26;  // Screw height (from bottom)
wh = 13;  // Wire height (from bottom)

difference() {
    // Large block to 'carve' the hook out of
    cube([w, d, h]);
    
    union(){
        // Gap where the wire goes
        translate([-0.5, t+wd/2, wh]) {
            rotate([0,90,0]) {
                cylinder(d=wd, h=w+1, $fn=20);
            }
        }
            
        // Empty space above the wire
        translate([-0.5, t, wh + 0.15*wd]) {
            cube([w+1, d, h]);
        }
        
        // Screw hole
        translate([w/2, t+0.5, sh]) {
            rotate([90,0,0]) {
                cylinder(d=sd, h=t+1, $fn=20);
            }
        }
        
        // Screw head recess
        translate([w/2, t, sh]) {
            rotate([90,0,0]) {
                cylinder(d=shd, h=shr, $fn=20);
            }
        }
    }
}
