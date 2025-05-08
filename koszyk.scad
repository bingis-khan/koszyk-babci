
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

$front_small_num_holes = 2;
$front_small_length = $front_small_num_holes*($cut_height + $thickness) + .5 * $thickness;
$middle_front_length = $width - 2*($front_small_length + $thickness);  // add thickness, because for some reason it's offset by thickness.
echo($front_small_length);
echo($middle_front_length);


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
                square([$basket_depth - 1*$thickness, $basket_height + 2]);
            }
        }
    }
        
}

wall();

module front_small() {
    difference() {
        linear_extrude($front_small_length) {
            offset(smoothing)offset(-smoothing) square([$thickness, $basket_depth]);
            
            translate([.5, 0, 0]) square([1, .5]);
        }


        // vertical cut
        cut_off = .5;
        translate([-cut_off, -cut_off, -cut_off]) cube([.5 + cut_off, $basket_depth + 2*cut_off, .5 + cut_off]);
        
        // horizontal cut
        translate([.5 - cut_off/2, -cut_off, -cut_off]) cube([69, .5 + cut_off, .5 + cut_off]);
        
        // 2nd vertical cut for that z-fighting thing
        translate([1, 0, 0]) cube([.5, 3, .5]);
        
        // holes
        translate([2, 2, .5 * $thickness]) rotate([0, -90, 0]) linear_extrude(4) {
            offset(-smoothing)offset(2*smoothing)offset(-smoothing) {
                for (i=[0:1:$front_small_num_holes - 1]) {
                    translate([i * ($cut_height + $thickness), 0, 0]) square([$cut_height, $basket_height - 3*$thickness]);
                }
            }
        }
        
        // last ridge
        translate([.5 * $thickness, .5 * $thickness, $front_small_length - .5 * $thickness]) linear_extrude(1) {
            square([1*$thickness, $basket_height - 1.5*$thickness]);
        }
    }

}

module back_small() {
    front_small();
    translate([0, $basket_height - $thickness, 0]) cube([1, 1, $front_small_length]);
}

translate([0, 0, 1]) back_small();

        

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
translate([0, $basket_depth - $thickness, $basket_height]) {
    hook();
    
    translate([$width - $thickness, 0, 0]) {
        hook();
    }
}