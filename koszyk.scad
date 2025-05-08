
module rcube(size) {
    //roundedcube(size, false, .3);
    cube(size);
}


$width = 30;
$basket_height = 15;
$basket_depth = 15;
$holder_height = 12;
$hook_depth = 4;
$thickness = 1;
$hook_hook = 2.5;
$hook_connector_height = 3;
$cut_height = ($basket_height - 5*$thickness) / 3;

$front_small_num_holes = 3;
$front_right_length = $width/2 - $thickness;
$front_left_length = $width/2 - $thickness;
echo($front_right_length);
echo($front_left_length);


$fn = 64;


outer_hook_fillet = .45;
inner_hook_fillet = .15;


module old_basket() {
    difference() {
        rcube([$width, $basket_depth, $basket_height]);
        
        // inside cut
        translate ([$thickness, $thickness, $thickness]) {
            rcube([$width - 2*$thickness, $basket_depth - 2*$thickness, 999]);
        }
        
        // horizontal cuts2*($cut_height + $thickness) + .5 * $thickness
        translate([-20, $thickness, 2*$thickness]) {
            cut_height = ($basket_height - 5*$thickness) / 3;
            for (i=[0:cut_height+$thickness:$basket_height]) {
                translate([0, 0, i]) {
                    rcube([100, $basket_depth - 2*$thickness, cut_height]);
                }
            }
        }
        
        // deep cut
        translate([$thickness, -20, 2*$thickness]) {
            cut_width = ($width - 2*$thickness - 5*$thickness) / 6;
            for (i=[0:cut_width+$thickness:$width]) {
                translate([i, 0, 0]) {
                    rcube([cut_width, 100, $basket_height - 3*$thickness]);
                }
            }
        }
    }
}

//old_basket();
smoothing = .4;

module base() {
    offset(-smoothing)offset(2*smoothing)offset(-smoothing) {
        square([$basket_depth, $basket_height]);
    }
    
    translate([0, $basket_height - $thickness, 0]) square(1);
}

// lr wall
module wall() {
    difference() {
        linear_extrude($thickness) {
            offset(-smoothing)offset(2*smoothing)offset(-smoothing) difference() {
                square([$basket_depth, $basket_height]);
                
                translate([$thickness, 2*$thickness, 0]) {
                    for (i=[0:$cut_height+$thickness:$basket_height]) {
                        translate([.5*$thickness, i, 0]) square([$basket_depth - 3*$thickness, $cut_height]);
                    }
                }
            }
            
            translate([0, $basket_height - $thickness, 0]) square($thickness);
        }
        
        // bad dingus hole.
        translate([$thickness + ($thickness/12)*1.2, $basket_height + $hook_connector_height, $thickness + ($thickness/12)*1.2]) 
            rotate([-90, 90, 0]) scale([1.2, 1.2, 2]) dingus();
    }
    
        
    translate([0, 0, $thickness]) linear_extrude($thickness*.5) {
        difference() {
            base();
                        
            translate([$thickness * .5, $thickness * .5, 0]) {
                square([$basket_depth - 1.5*$thickness, $basket_height + 2]);
            }
            
            translate([$basket_depth - .5*$thickness, -.5*$thickness, 0]) {
                square([$thickness*.5, $basket_height + 5]);
            }
            
            translate([0, $basket_height - 1, 0]) {
                square([$basket_depth, $thickness*2]);
            }
        }      
    }
}

cut_off = .5;
module wall_general() {
    difference() {
        linear_extrude($front_right_length) {
            offset(smoothing)offset(-smoothing) square([$thickness, $basket_depth]);
            
            translate([.5*$thickness, $basket_depth - $thickness, 0]) square([.5, 1]);
            
            translate([.5, 0, 0]) square([1, .5]);
        }
       
        
        // 2nd vertical cut for that z-fighting thing
        translate([1, 0, 0]) cube([.5, 3, .5]);
        
        // holes
        translate([2, 2, .5 * $thickness]) rotate([0, -90, 0]) linear_extrude(4) {
            offset(-smoothing)offset(2*smoothing)offset(-smoothing) {
                for (i=[0:1:$front_small_num_holes - 1]) {
                    translate([.5 * $thickness + i * ($cut_height + $thickness), 0, 0]) square([$cut_height, $basket_height - 3*$thickness]);
                }
            }
        }
    }

}

module front_general() {
    scale([-1, 1, 1]) difference() {
        wall_general();

        
        translate([cut_off, -cut_off, -cut_off]) cube([.5 + cut_off, $basket_depth - .5*$thickness, .5 + cut_off]);
        
        // horizontal cut
        translate([$thickness - cut_off/2, -cut_off, -cut_off]) cube([69, .5 + cut_off, .5 + cut_off]);
    }        
}


module back_general() {
    difference() {
        wall_general();

        // horizontal ridge.
        translate([-cut_off, -cut_off, -cut_off]) cube([.5 + cut_off, $basket_depth + 2*cut_off, .5 + cut_off]);
        
        // horizontal cut
        translate([.5 - cut_off/2, -cut_off, -cut_off]) cube([69, .5 + cut_off, .5 + cut_off]);
    }
    translate([0, $basket_height - $thickness, 0]) cube([1, 1, $front_right_length]);
}

module front_right() {
    difference() {
        front_general();
    
        // last ridge
        scale([-1, 1, 1]) translate([.5 * $thickness, .5 * $thickness, $front_right_length - .5 * $thickness]) linear_extrude(1) {
            square([1*$thickness, $basket_height - 1.5*$thickness]);
        }    
    }
}

module back_right() {
    difference() {
        back_general();
        
        // last ridge
        translate([.5 * $thickness, .5 * $thickness, $front_right_length - .5 * $thickness]) linear_extrude(1) {
            square([1*$thickness, $basket_height - 1.5*$thickness]);
        } 
    }
}


module front_left() {
    scale([1, 1, -1]) {
        front_general();
        
        // last ridge
        translate([-1 * $thickness, .5 * $thickness, $front_right_length - .5 * $thickness]) linear_extrude($thickness) {
            square([.5*$thickness, $basket_height - 1.5*$thickness]);
        }
    }
}

module back_left() {
    scale([1, 1, -1]) {
        back_general();
    
         // last ridge
        translate([.5 * $thickness, .5 * $thickness, $front_right_length - .5 * $thickness]) linear_extrude($thickness) {
            square([.5*$thickness, $basket_height - 1.5*$thickness]);
        }
    }
}


module new_basket() {
    rotate([90, 0, 0]) {
        wall();
        
        translate([0, 0, $thickness]) back_right();
        translate([0, 0, $width - $thickness]) back_left();
        
        translate([0, 0, $width]) scale([1, 1, -1]) wall();
        
        translate([$basket_depth, 0, $thickness]) front_right();
        translate([$basket_depth, 0, $width - $thickness]) front_left();
    }
}

 new_basket();
        

module dingus() {
    translate([$thickness/2, $thickness/2, 0]) rotate([180, 0, 0]) {
        difference() {
            cylinder($hook_connector_height, $thickness/3, $thickness/3);
            translate([-$thickness/2, -(1.2 * $thickness), 0]) cube([$thickness, $thickness, $hook_connector_height + 1]);
        }
    }
}

// hooks
module hook() {
    translate([0, 0, $holder_height])
    rotate([0, 90, 0])
    linear_extrude($thickness) {
        offset(outer_hook_fillet)offset(-outer_hook_fillet)
        offset(-inner_hook_fillet)offset(inner_hook_fillet)
        {  
            square([$holder_height, $thickness]);
            square([$thickness, $hook_depth]);
            translate([0, $hook_depth - 1, 0]) {
                square([$hook_hook, $thickness]);
            }
        }
        translate([$holder_height - 1, 0, 0]) square($thickness);
    }
    
    dingus();
}
//translate([0, $basket_depth - $thickness, $basket_height]) {
//    hook();
//    
//    translate([$width - $thickness, 0, 0]) {
//        hook();
//    }
//}