// Traxxas Slash A Arm
//
// Replacement front A arm for the Traxxas Slash RC car.
// Parameters can be modified to use this A arm for the rear, or
// for other cars.
// (...it might need additional work to be used for the rear)
//
// V1 -> V2
// After driving with V1 for a while, printed in ABS,
// the A arm broke where it connects to the wheel. The back 
// connection snapped off (the whole little arm), and the front
// one split between layers, and the shaft got out. I made the following
// changes to these little arms
//      - For the front arm, the top is strengthened
//      - For the back arm, the inside was filleted
//      - For both, the bottom side was strengthened
//      - For both, the part holding the shaft was extended toward the wheel
//          (on the wheel side of the shaft - i.e. it's thicker)
//      - The dimension rodOneStraightTwo was created to move the vertex near
//          the back rod-one arm
//      - The dimension rodThreeVertex was created to move the vertex near 
//          the front rod three arm
//
// Daniel Winker, February 28, 2023

// Holes were coming out too small, so I added this multiplier
holeMult = 1.3;

// The long dimension
length = 83.5;

// The smallest dimension
thickness = 9.5;

// The largest width dimension; the "base of the A"
widest = 38;

// The narrowest width dimension; the "top of the A"
narrowest = 22.5;

// The "base of the A" is offset forward from the "top of the A" by this much
offset = 7.0;

// Forward distance between the "top of the A" and the shock-rod screwhead
shockRodOffset = 37.0;

// There are three rods going through the part
// They are referred to as one, two, and three
// One is by the wheel, two is for the shock, three is on the chassis
// Holes for the rods will be centered on the thickness axis, positioned
//    by 'Pos' on the length axis (0 is closest to rod 1), and go all 
//    the way through the other axis...except rod 2, which won't go all the way
// 'MountWidth' is the gap left by the pieces holding the rod.
// CutoutLength is the size of the gap left by the pieces holding the rod, along the length axis. Perpendicular to 'MountWidth'
// 'Inset' is unique to rod two, because it is not symmetrically placed like
//    the other two.
// 'HeadDia' is also unique to it (diameter of the screw head)
rodOneDia = 2.45 * holeMult;  // Actually the diameter of the hole, not the rod
rodOnePos = 3.75;
rodOneMountWidth = 13.0;
rodOneCutoutLength = 13.5;
rodOneBracketWidth = (narrowest-rodOneMountWidth)/2;

rodTwoDia = 2.5 * holeMult;
rodTwoPos = 44.0;
rodTwoMountWidth = 7.4;  // This should be 6.5, but it was printing almost 1mm small for me
rodTwoCutoutLength = 17.0;
rodTwoInset = 5.3;  // This should be larger...but it was printing ~1mm large for me
rodTwoHeadDia = 5.5;
rodTwoLen = 17;  // Length of the screw

rodThreeDia = 3.2 * holeMult;
rodThreePos = 77.8;
rodThreeMountWidth = 26;
rodThreeCutoutLength = 11.0;
rodThreeVertex = 18.0;  // Added in V2; position of the vertex from the end.
rodThreeBracketWidth = (widest - rodThreeMountWidth) / 2;

// I didn't have good ways to name these or describe them
// The arms holding the wheel-rod are straight for a bit before the A arm
// angles off - how long are those straight segments?
rodOneStraight = 12;
rodOneStraightTwo = 22;  // Added in V2
// On the front side of the arm, after the straight section, there's an
// angled section. What is the offset of the top of it?
angleOffset = 30;
// And what is the 'length' position of the top of it?
angleLen = 30;
// On the back section of the arm, there's a vertex near the car side (rod 3);
// what is the position of this in the length direction?
finalVertex = 53;

// V2 Values
// These specify the additions made in version 2
topReinforcementHeight = thickness * 0.25;
topReinforcementLength = rodOneStraight;
bottomReinforcementHeight = thickness * 0.25;
bottomReinforcementLength = rodOneStraight;
filletRadius = 5;
shaftReinforcementLength = 2;

// Draw a prism based on a right angled triangle
// l - length of prism
// w - width of triangle
// h - height of triangle
// https://github.com/dannystaple/OpenSCAD-Parts-Library/blob/master/prism.scad
module prism(l, w, h) {
       polyhedron(points=[
               [0,0,h],           // 0    front top corner
               [0,0,0],[w,0,0],   // 1, 2 front left & right bottom corners
               [0,l,h],           // 3    back top corner
               [0,l,0],[w,l,0]    // 4, 5 back left & right bottom corners
       ], faces=[ // points for all faces must be ordered clockwise when looking in
               [0,2,1],    // top face
               [3,4,5],    // base face
               [0,1,4,3],  // h face
               [1,2,5,4],  // w face
               [0,3,5,2],  // hypotenuse face
       ]);
}

// Create a 2D outline of the A arm then extrude it upwards
// This includes the cutout for the shock
// (Making it a module to organize the code)
module drawAARm() {
    linear_extrude(height=thickness, convexity=10, slices=20, scale=1.0, $fn=16) {
        polygon(points=[[0,0],
                        [rodOneBracketWidth,0],
                        [rodOneBracketWidth,rodOneCutoutLength],
                        [rodOneBracketWidth+rodOneMountWidth,rodOneCutoutLength],
                        [rodOneBracketWidth+rodOneMountWidth,0],
                        [narrowest,0],
                        [narrowest,rodOneStraight],
                        [angleOffset,angleLen],
                        [shockRodOffset,angleLen],
                        [shockRodOffset,rodTwoPos+0.6*rodTwoHeadDia],
                        [widest+offset,length-rodThreeVertex],
                        [widest+offset,length],
                        [widest+offset-rodThreeBracketWidth,length],
                        [widest+offset-rodThreeBracketWidth,length-rodThreeCutoutLength],
                        [offset+rodThreeBracketWidth,length-rodThreeCutoutLength],
                        [offset+rodThreeBracketWidth,length],
                        [offset,length],
                        [offset,finalVertex],
                        [0,rodOneStraightTwo],
                        // The points above are the outline
                        // The points below are the cutout for the shock
                        [shockRodOffset-rodTwoInset,rodTwoPos-rodTwoCutoutLength/2],
                        [shockRodOffset-rodTwoInset,rodTwoPos+rodTwoCutoutLength/2],
                        [shockRodOffset-rodTwoInset-rodTwoMountWidth,rodTwoPos+rodTwoCutoutLength/2],
                        [shockRodOffset-rodTwoInset-rodTwoMountWidth,rodTwoPos-rodTwoCutoutLength/2]],
                        // The below says the first set of points is for the outline
                        // and the second set is for the cutout
                        paths=[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18],
                               [19,20,21,22]]);
    }
}

// The A arm, from the module, has sharp 90-degree angles everywhere
// We want the end bits where the shafts go to be rounded
// So we cut off the rectangular bits, and draw in cylinders
// We also cut out holes for the shafts/rods
difference() {
    union() {
        // Cut out the 90-degree parts
        difference() {
            union() {
                drawAARm();
                
                // V2 Change: Add extra material on the wheel-side of
                // the A arm to strengthen the "rod one arm"
                rodOneArmWidth = (narrowest-rodOneMountWidth)/2;
                translate([0, -shaftReinforcementLength, 0]) {
                    cube([rodOneArmWidth,shaftReinforcementLength,thickness]);
                }
                translate([rodOneMountWidth+rodOneArmWidth, 
                            -shaftReinforcementLength, 0]) {
                    cube([(narrowest-rodOneMountWidth)/2,
                            shaftReinforcementLength,thickness]);
                }
                
                // V2 Change: Fillet the inside of the rod 1 holder
                // Only the back part of it; the front requires 
                // more clearance
                // (Draw a block, cut a cylinder out of the block)
                translate([rodOneArmWidth+filletRadius,rodOneCutoutLength-filletRadius,0]) {    
                    rotate([0, 0, 90]) {
                        difference() {
                            cube([filletRadius, filletRadius, thickness]);
                            cylinder(r=filletRadius, h=thickness, $fn=30);
                        }
                    }
                }
                
                // V2 Change: Add reinforcement on top of the front rod 1 holder arm
                translate([rodOneMountWidth+rodOneArmWidth, rodOneCutoutLength-topReinforcementLength/4, thickness]) {
                    translate([rodOneArmWidth, topReinforcementLength*0.5, 0]) {
                        rotate([0, 0, 90]) {
                            prism(rodOneArmWidth, topReinforcementLength*0.25, topReinforcementHeight);
                        }
                    }
                    rotate([0, 0, -90]) {
                        prism(rodOneArmWidth, topReinforcementLength*0.25, topReinforcementHeight);
                    }
                    cube([rodOneArmWidth, topReinforcementLength*0.5, topReinforcementHeight]);
                }
                
                // V2 Change: Add reinforcement under the front rod 1 holder arm
                translate([rodOneMountWidth+rodOneArmWidth, rodOneCutoutLength-topReinforcementLength/4, -bottomReinforcementHeight]) {
                    translate([0, topReinforcementLength*0.5, bottomReinforcementHeight]) {
                        rotate([180, 0, 90]) {
                            prism(rodOneArmWidth, topReinforcementLength*0.25, topReinforcementHeight);
                        }
                    }
                    translate([rodOneArmWidth, 0, bottomReinforcementHeight]) {
                        rotate([180, 0, -90]) {
                            prism(rodOneArmWidth, topReinforcementLength*0.25, topReinforcementHeight);
                        }
                    }
                    cube([rodOneArmWidth, topReinforcementLength*0.5, topReinforcementHeight]);
                }
                
                // V2 Change: Add reinforcement under the front rod 1 holder arm
                translate([0, rodOneCutoutLength-topReinforcementLength/4, -bottomReinforcementHeight]) {
                    translate([0, topReinforcementLength*0.5, bottomReinforcementHeight]) {
                        rotate([180, 0, 90]) {
                            prism(rodOneArmWidth, topReinforcementLength*0.25, topReinforcementHeight);
                        }
                    }
                    translate([rodOneArmWidth, 0, bottomReinforcementHeight]) {
                        rotate([180, 0, -90]) {
                            prism(rodOneArmWidth, topReinforcementLength*0.25, topReinforcementHeight);
                        }
                    }
                    cube([rodOneArmWidth, topReinforcementLength*0.5, topReinforcementHeight]);
                }
                
            }
            union() {
                translate([0, -shaftReinforcementLength, 0]) {
                    cube([widest, thickness/2, thickness]);  // The small end
                }
                translate([0, length-thickness/2, 0]) {
                    cube([widest+offset, thickness/2, thickness]);  // The large end
                }
            }
        }
        // Add in the cylinders
        // On the small end
        translate([0, thickness/2-shaftReinforcementLength, thickness/2]) {
            rotate([0, 90, 0]) {
                cylinder(r=thickness/2, h=rodOneBracketWidth, $fn=25);
            }
        }
        translate([rodOneMountWidth+rodOneBracketWidth, thickness/2-shaftReinforcementLength, thickness/2]) {
            rotate([0, 90, 0]) {
                cylinder(r=thickness/2, h=rodOneBracketWidth, $fn=25);
            }
        }
        // On the big end
        translate([offset, length-thickness/2, thickness/2]) {
            rotate([0, 90, 0]) {
                cylinder(r=thickness/2, h=rodThreeBracketWidth, $fn=25);
            }
        }
        translate([rodThreeMountWidth+rodThreeBracketWidth+offset, length-thickness/2, thickness/2]) {
            rotate([0, 90, 0]) {
                cylinder(r=thickness/2, h=rodThreeBracketWidth, $fn=25);
            }
        }
    }
    
    // Cut out the shaft holes
    union() {
        translate([(widest+offset)/2,rodOnePos,thickness/2]) {
            rotate([0, 90, 0]) {
                cylinder(r=rodOneDia/2, h=widest+offset, center=true, $fn=25);
            }
        }
        translate([(widest+offset)/2+shockRodOffset-rodTwoLen,rodTwoPos,thickness/2]) {
            rotate([0, 90, 0]) {
                cylinder(r=rodTwoDia/2, h=widest+offset, center=true, $fn=25);
            }
        }
        translate([(widest+offset)/2,rodThreePos,thickness/2]) {
            rotate([0, 90, 0]) {
                cylinder(r=rodThreeDia/2, h=widest+offset, center=true, $fn=25);
            }
        }
    }
}
