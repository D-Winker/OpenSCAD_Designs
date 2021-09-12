/* Furniture Riser
 *
 * Platforms to raise up furniture (the legs of the furniture sit on top of these).
 *
 * Optional circular cutouts, if the furniture has sliders.
 * (cutouts are centered, and have a radius and height)
 * Adjustable riser height, length and width of furniture leg, and 
 * height and thickness of wraparound.
 * Optional rounded edge on wraparound. 
 * (Note: if using rounded edge, the minimum wrapHeight is equal to half the wrapWidth.)
 * 
 * regarding print settings and part strength
 * https://www.youtube.com/watch?v=upELI0HmzHc
 *
 * Daniel Winker, September 11, 2021
 */
 
// __________Settings__________
// I'm assuming millimeters for all dimensions
circularCutout = true;
cutoutHeight = 2.5;
cutoutRadius = 12.5;

riserHeight = 50.0;

legWidth = 44.5;
legLength = 36.0;

wrapHeight = 5.0;
wrapWidth = 2.0;
wrapRoundedEdge = true;  // Should the top of the wraparound be rounded?

cr = 30;  // 'Cylinder Resolution' (the number of segments used for a cylinder)
sr = 50;  // 'Sphere Resolution' (the number of segments used for a sphere)
// End of Settings

// Settings check
if (wrapRoundedEdge) {
    if (wrapWidth > wrapHeight * 2) {
        echo("Your wrap width is greater than double the wrap height, and you're using rounded edges! This script can't handle that!");
    }
}

// __________Wraparound__________
difference() {
    
    union() {
        // The outside edges
        fullWidth = legWidth + 2 * wrapWidth;
        fullLength = legLength + 2 * wrapWidth;
        fullHeight = riserHeight + wrapHeight;
        verticalOffset = wrapHeight / 2;    
        lengthOffset = fullLength / 2 - wrapWidth / 2;
        widthOffset = fullWidth / 2 - wrapWidth / 2;
        
        if (wrapRoundedEdge) {
            fullHeight = riserHeight + wrapHeight - wrapWidth / 2;
            verticalOffset = (wrapHeight - wrapWidth / 2) / 2;
        }
        
        union() {
            difference() {
                // This rectangular prism is the 'body' of the wrapped edge
                translate([0, 0, verticalOffset]) {
                    cube([fullWidth, fullLength, fullHeight], center=true);
                }
                
                if (wrapRoundedEdge) {
                    // Subtract out the corners
                    union() {    
                        cornerLengthOffset = fullLength / 2 - wrapWidth / 4;
                        cornerWidthOffset = fullWidth / 2 - wrapWidth / 4;
                        translate([-cornerWidthOffset, -cornerLengthOffset, verticalOffset]) {
                            cube([wrapWidth/2, wrapWidth/2, fullHeight], center=true);
                        }
                        translate([-cornerWidthOffset, cornerLengthOffset, verticalOffset]) {
                            cube([wrapWidth/2, wrapWidth/2, fullHeight], center=true);
                        }
                        translate([cornerWidthOffset, -cornerLengthOffset, verticalOffset]) {
                            cube([wrapWidth/2, wrapWidth/2, fullHeight], center=true);
                        }
                        translate([cornerWidthOffset, cornerLengthOffset, verticalOffset]) {
                            cube([wrapWidth/2, wrapWidth/2, fullHeight], center=true);
                        }
                    }
                }
            }
            
            if (wrapRoundedEdge) {
                // Rounded corners (by placing cylinders)
                translate([-widthOffset, -lengthOffset, verticalOffset]) {
                    cylinder(h=fullHeight, d=wrapWidth, center=true, $fn=cr);
                }
                translate([-widthOffset, lengthOffset, verticalOffset]) {
                    cylinder(h=fullHeight, d=wrapWidth, center=true, $fn=cr);
                }
                translate([widthOffset, -lengthOffset, verticalOffset]) {
                    cylinder(h=fullHeight, d=wrapWidth, center=true, $fn=cr);
                }
                translate([widthOffset, lengthOffset, verticalOffset]) {
                    cylinder(h=fullHeight, d=wrapWidth, center=true, $fn=cr);
                }
            }
        }
        
        // Rounded top edge
        if (wrapRoundedEdge) {            
            // Place half-cylinders on top of the edges
            translate([0, lengthOffset, fullHeight / 2 + verticalOffset]) {
                rotate([90, 0, 90]) {
                    cylinder(h=fullWidth - wrapWidth, d=wrapWidth, center=true, $fn=cr);
                }
            }
            translate([0, -lengthOffset, fullHeight / 2 + verticalOffset]) {
                rotate([90, 0, 90]) {
                    cylinder(h=fullWidth - wrapWidth, d=wrapWidth, center=true, $fn=cr);
                }
            }
            translate([widthOffset, 0, fullHeight / 2 + verticalOffset]) {
                rotate([90, 0, 0]) {
                    cylinder(h=fullLength - wrapWidth, d=wrapWidth, center=true, $fn=cr);
                }
            }
            translate([-widthOffset, 0, fullHeight / 2 + verticalOffset]) {
                rotate([90, 0, 0]) {
                    cylinder(h=fullLength - wrapWidth, d=wrapWidth, center=true, $fn=cr);
                }
            }
            
            // Place spheres at the corners
            translate([-widthOffset, -lengthOffset, fullHeight / 2 + verticalOffset]) {
                sphere(d=wrapWidth, $fn=sr); 
            }
            translate([-widthOffset, lengthOffset, fullHeight / 2 + verticalOffset]) {
                sphere(d=wrapWidth, $fn=sr); 
            }
            translate([widthOffset, -lengthOffset, fullHeight / 2 + verticalOffset]) {
                sphere(d=wrapWidth, $fn=sr); 
            }
            translate([widthOffset, lengthOffset, fullHeight / 2 + verticalOffset]) {
                sphere(d=wrapWidth, $fn=sr); 
            }
        }
        
    }
    
    union() {
        // The hollow part where the leg rests
        translate([0, 0, riserHeight / 2 + wrapHeight / 2]) {
            cube([legWidth, legLength, wrapHeight], center=true);
        }
        // The hollow part where the slider goes        
        if (circularCutout) {
            translate([0, 0, riserHeight / 2 - cutoutHeight / 2]) {
                // __________Circular Cutout__________
                cylinder(h=cutoutHeight, r=cutoutRadius, center=true, $fn=cr);
            }
        }
    }
}
