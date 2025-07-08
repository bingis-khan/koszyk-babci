
module rcube(size) {
    //roundedcube(size, false, .3);
    cube(size);
}

// NOTES FOR THE FUTURE: I can just redefine translate to use thickness. I ended up using thickness everywhere anyway. same with other common functions? but this might be annoying and less obvious.


width = 43;
basket_height = 15;
basket_depth = 15;
holder_height = 14;
hook_depth = 4;
thickness = 1;
hook_hook = 5;
hook_connector_height = 3;
cut_height = (basket_height - 5*thickness) / 3;
hook_thickness = 3;

front_small_num_holes = 4;
front_right_length = width/2 - thickness;
front_left_length = width/2 - thickness;
echo(front_right_length);
echo(front_left_length);


$fn = 64;
print = false;

outer_hook_fillet = .45;
inner_hook_fillet = .15;


module old_basket() {
    difference() {
        rcube([width, basket_depth, basket_height]);
        
        // inside cut
        translate ([thickness, thickness, thickness]) {
            rcube([width - 2*thickness, basket_depth - 2*thickness, 999]);
        }
        
        // horizontal cuts2*(cut_height + thickness) + .5 * thickness
        translate([-20, thickness, 2*thickness]) {
            cut_height = (basket_height - 5*thickness) / 3;
            for (i=[0:cut_height+thickness:basket_height]) {
                translate([0, 0, i]) {
                    rcube([100, basket_depth - 2*thickness, cut_height]);
                }
            }
        }
        
        // deep cut
        translate([thickness, -20, 2*thickness]) {
            cut_width = (width - 2*thickness - 5*thickness) / 6;
            for (i=[0:cut_width+thickness:width]) {
                translate([i, 0, 0]) {
                    rcube([cut_width, 100, basket_height - 3*thickness]);
                }
            }
        }
    }
}

//old_basket();
smoothing = .4;

module base() {
    offset(-smoothing)offset(2*smoothing)offset(-smoothing) {
        square([basket_depth, basket_height]);
    }
    
    translate([0, basket_height - thickness, 0]) square(1);
}

// lr wall
module wall() {
    difference () {
        translate([0, 0, 0]) {
            difference() {
                linear_extrude(thickness) {
                    offset(-smoothing)offset(2*smoothing)offset(-smoothing) difference() {
                        square([basket_depth, basket_height]);
                        
                        translate([thickness, 2*thickness, 0]) {
                            for (i=[0:cut_height+thickness:basket_height]) {
                                translate([.5*thickness, i - .5*thickness, 0]) square([basket_depth - 3*thickness, cut_height]);
                            }
                            
                            // NOTE: accidental good looking thing. now, there's a "ridge on the left-right walls. It was not in the design, but it accidentally got created after a change. I'll leave it and ask my gramma if she likes it.
                        }
                    }
                    
                    translate([0, basket_height - thickness, 0]) square(thickness);
                }

            }
            
                
            translate([0, 0, thickness]) linear_extrude(thickness*.5) {
                difference() {
                    base();
                                
                    translate([thickness * .5, thickness * .5, 0]) {
                        square([basket_depth - 1.5*thickness, basket_height + 2]);
                    }
                    
                    translate([basket_depth - .5*thickness, -.5*thickness, 0]) {
                        square([thickness*.5, basket_height + 5]);
                    }
                    
                    translate([0, basket_height - 1, 0]) {
                        square([basket_depth, thickness*2]);
                    }
                }      
            }
        }
                        
        // bad dingus hole.
        translate([thickness + (thickness/10) - (thickness/50), basket_height + hook_connector_height - 3*thickness + thickness * .27, -(thickness/20)]) 
            rotate([-90, 90, 0]) scale([1.1, 1.1, 1.1]) scale([-1, 1, 1]) hook();
    }
}

cut_off = .5;
module wall_general() {
    difference() {
        linear_extrude(front_right_length) {
            offset(smoothing)offset(-smoothing) square([thickness, basket_depth]);
            
            translate([.5*thickness, basket_depth - thickness, 0]) square([.5, 1]);
            
            translate([.5, 0, 0]) square([1, .5]);
        }
       
        
        // 2nd vertical cut for that z-fighting thing
        translate([1, 0, 0]) cube([.5, 3, .5]);
        
        // holes
        translate([2, 2, .5 * thickness]) rotate([0, -90, 0]) linear_extrude(4) {
            offset(-smoothing)offset(2*smoothing)offset(-smoothing) {
                for (i=[0:1:front_small_num_holes - 1]) {
                    translate([2 * thickness + i * (cut_height + thickness), -.5*thickness, 0]) square([cut_height, basket_height - 3*thickness]);
                }
            }
        }
    }

}

module front_general() {
    scale([-1, 1, 1]) difference() {
        wall_general();

        
        translate([cut_off, -cut_off, -cut_off]) cube([.5 + cut_off, basket_depth - .5*thickness, .5 + cut_off]);
        
        // horizontal cut
        translate([thickness - cut_off/2, -cut_off, -cut_off]) cube([69, .5 + cut_off, .5 + cut_off]);
    }        
}


module back_general() {
    difference() {
        translate([0, 0, 0]) {
            difference() {
                wall_general();

                // horizontal ridge.
                translate([-cut_off, -cut_off, -cut_off]) cube([.5 + cut_off, basket_depth + 2*cut_off, .5 + cut_off]);
                
                // horizontal cut
                translate([.5 - cut_off/2, -cut_off, -cut_off]) cube([69, .5 + cut_off, .5 + cut_off]);
            }

            translate([0, basket_height - thickness, 0]) cube([1, 1, front_right_length]);
        }
        
        // bad dingus hole. (copy)
        translate([thickness + (thickness/10) - (thickness/50), basket_height + hook_connector_height - 3*thickness + thickness * .27, -1.2*thickness -(thickness/20)]) 
            rotate([-90, 90, 0]) scale([1.1, 1.1, 1.1]) scale([-1, 1, 1]) hook();
    }
}

module front_right() {
    difference() {
        front_general();
    
        // last ridge
        scale([-1, 1, 1]) translate([.5 * thickness, .5 * thickness, front_right_length - .5 * thickness]) linear_extrude(1) {
            square([1*thickness, basket_height - 1.5*thickness]);
        }    
    }
}

module back_right() {
    difference() {
        back_general();
        
        // last ridge
        translate([.5 * thickness, .5 * thickness, front_right_length - .5 * thickness]) linear_extrude(1) {
            square([1*thickness, basket_height - 1.5*thickness]);
        } 
    }
}


module front_left() {
    scale([1, 1, -1]) {
        front_general();
        
        // last ridge
        translate([-1 * thickness, .5 * thickness, front_right_length - .5 * thickness]) linear_extrude(thickness) {
            square([.5*thickness, basket_height - 1.5*thickness]);
        }
    }
}

module back_left() {
    scale([1, 1, -1]) {
        back_general();
    
         // last ridge
        translate([.5 * thickness, .5 * thickness, front_right_length - .5 * thickness]) linear_extrude(thickness) {
            square([.5*thickness, basket_height - 1.5*thickness]);
        }
    }
}


module floor() {
    linear_extrude(.5*thickness) {
        square([(basket_depth - 2*thickness), (width - 2*thickness) / 2]);
    }
    
    linear_extrude(thickness) {
        translate([.5 * thickness, .5 * thickness, 0]) square([(basket_depth - 3*thickness), (width - 3*thickness) / 2]);
    }
}


module dingus() {
    dingus_height = 3;
    rotate([180, 0, 0]) translate([0, -thickness*1, 0]) {
        difference() {
            translate([0, 0, 0]) {
                linear_extrude(dingus_height*thickness) {
                    square([hook_thickness, .5*thickness]);
                }
                rotate([180, 0, 180]) translate([-hook_thickness, 0, -dingus_height]) linear_extrude(1*thickness) {
                    square([hook_thickness, .8*thickness]);
                    translate([hook_thickness, 0]) rotate([0, 180, 0]) square([.8*thickness, 1*thickness]);
                }
            }
            
            translate([-.3, -.1, 0]) linear_extrude(dingus_height*thickness + 2) {
                square([.5, (1 + .5)*thickness]);
            }
        }
    }
}

// hooks
module hook() {
    translate([0, 0, holder_height])
    rotate([0, 90, 0])
    linear_extrude(hook_thickness) {
        offset(outer_hook_fillet)offset(-outer_hook_fillet)
        offset(-inner_hook_fillet)offset(inner_hook_fillet)
        {  
            square([holder_height, thickness]);
            square([thickness, hook_depth]);
            translate([0, hook_depth - 1, 0]) {
                square([hook_hook, thickness]);
            }
        }
               
        translate([holder_height - 1, 0, 0]) square(thickness);
    }
    
    dingus();   
}

module right_wall() {
    wall();
}

module left_wall() {
    scale([1, 1, -1]) wall();
}

// BOB_SCAD_PRINT left_wall right_wall back_right back_left front_right front_left floor hook
module new_basket() {
    rotate([90, 0, 0]) {
        right_wall();
        
        translate([0, 0, thickness]) back_right();
        translate([0, 0, width - thickness]) back_left();
        
        translate([0, 0, width]) left_wall();
        
        translate([basket_depth, 0, thickness]) front_right();
        translate([basket_depth, 0, width - thickness]) front_left();
        
        translate([1, 1, 1]) rotate([90, 0, 0]) {
            floor();
            scale([1, -1, 1]) translate([0, -(width - 2*thickness), 0]) floor();
        }
    }
    
    translate([thickness, -width, basket_height]) rotate([0, 0, 90]) {
        hook();
        
        translate([width, 0, 0]) scale([-1, 1, 1]) {
            hook();
        }
    }
}

// uncomment to see model.
if (!print) {
    new_basket();
}


