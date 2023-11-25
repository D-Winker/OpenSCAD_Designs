// Duct Mount
//
// An adapter between two pieces of round ducting,
// that also serves as a mount for them.
// I plan to attach a small, flexible duct on one side,
// and a semi-rigid duct on the other.
// The semi-rigid duct will only be supported by this mount.
//
// Daniel Winker, March 14, 2022

smallID = 80;  // Inner diameter of the small duct
ls = 30;  // Length of the small duct adapter
largeID = 100;  // Inner diameter of the large duct
ll = 40;  // Length of the large duct adapter
mWidth = 135;  // Width of the mounting portion
t = 5;  // Thickness of the in-duct portions
// The thickness of the large-ID duct portion will be greater than this because of the way the inner cavity tapers from the large ID to the small ID

midID = (largeID + smallID) / 2;  // Average of large and small ID's

// For mounting screw holes (countersunk)
shd = 8.2;  // Screw head diameter
shh = 3.4;  // Screw head height - conical section
sho = 15;  // Screw head offset - above Z=0
sd = 3.2;  // Screw shaft diameter

backMountT = shh;  // Thickness of the back mounting piece
backMountH = 35;  // Height of the back mounting piece

mThickness = 37 + backMountT;  // thickness of the mounting portion
pT = mWidth/2-largeID/2;  // Prism thickness (the chamfered portion)

module prism(l, w, h){
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
   }

// Small duct_____________________________________
translate([mWidth/2, 0, largeID/2]) {
    rotate([90, 0, 0]) {
        difference() {
            cylinder(r=smallID/2, h=ls, $fn=100);
            cylinder(r=(smallID-t)/2, h=ls, $fn=100);
        }
    }
}

// Inter-duct / Mounting piece______________________
// main body
difference() {
    union() {
        translate([pT, 0, 0]) {
            cube([largeID, mThickness, largeID/2]);
        }
        translate([mWidth/2, ll, largeID/2]) {
            rotate([90, 0, 0]) {
                difference() {
                    cylinder(r1=largeID/2, r2=smallID/2, h=ll, $fn=100);
                }
            }
        }

        // chamfered side
        translate([0, mThickness, 0]) {
            rotate([0, 0, -90]) {
                difference() {
                    prism(mThickness, pT, largeID/2);
                    
                    // Screw hole
                    union() {
                        translate([mThickness/2, 0.75*pT, sho]) {
                            cylinder(r=shd/2, h=largeID);
                        }
                        translate([mThickness/2, 0.75*pT, sho-shh]) {
                            cylinder(r1=sd/2, r2=shd/2, h=shh);
                        }
                        translate([mThickness/2, 0.75*pT, 0]) {
                            cylinder(r=sd/2, h=largeID);
                        }
                    }
                }
            }
        }

        // other chamfered side
        translate([mWidth, 0, 0]) {
            rotate([0, 0, 90]) {
                difference() {  
                    prism(mThickness, pT, largeID/2);
                    
                    // Screw hole
                    union() {
                        translate([mThickness/2, 0.75*pT, sho]) {
                            cylinder(r=shd/2, h=largeID);
                        }
                        translate([mThickness/2, 0.75*pT, sho-shh]) {
                            cylinder(r1=sd/2, r2=shd/2, h=shh);
                        }
                        translate([mThickness/2, 0.75*pT, 0]) {
                            cylinder(r=sd/2, h=largeID);
                        }
                    }
                }
            }
        }
        
        // The downward hanging mounting piece
        difference() {
            translate([0, 0, -backMountH]) {
                cube([mWidth, backMountT, backMountH]);
            }
            
            // Screw holes
            union() {
                translate([0.5*mWidth, backMountT, -0.7*backMountH]) {
                    rotate([90, 0, 0]) {
                        cylinder(r1=sd/2, r2=shd/2, h=backMountT, $fn=100);
                    }
                }
            }
        }
    }
    
    // Hollow out the body
    translate([mWidth/2, mThickness, largeID/2]) {
        rotate([90, 0, 0]) {
            cylinder(r1=midID/2-t/2, r2=smallID/2-t/2, h=mThickness, $fn=100);
        }
    }
}

// Large duct________________________________________
translate([mWidth/2, mThickness+ll, largeID/2]) {
    rotate([90, 0, 0]) {
        difference() {
            cylinder(r=largeID/2, h=ll, $fn=100);
            cylinder(r1=(largeID-t)/2, r2=(midID-t)/2, h=ll, $fn=100);
        }
    }
}


