$width = 30;
$basket_height = 15;
$basket_depth = 15;
$holder_height = 12;
$hook_depth = 4;
$thickness = 1;
$hook_hook = 3;


difference() {
    cube([$width, $basket_depth, $basket_height]);
    
    // inside cut
    translate ([$thickness, $thickness, $thickness]) {
        cube([$width - 2*$thickness, $basket_depth - 2*$thickness, 999]);
    }
    
    // horizontal cuts
    translate([-20, $thickness, 2*$thickness]) {
        cut_height = ($basket_height - 5*$thickness) / 3;
        for (i=[0:cut_height+$thickness:$basket_height]) {
            translate([0, 0, i]) {
                cube([100, $basket_depth - 2*$thickness, cut_height]);
            }
        }
    }
    
    // deep cut
    translate([$thickness, -20, 2*$thickness]) {
        cut_width = ($width - 2*$thickness - 5*$thickness) / 6;
        for (i=[0:cut_width+$thickness:$width]) {
            translate([i, 0, 0]) {
                cube([cut_width, 100, $basket_height - 3*$thickness]);
            }
        }
    }
}


// hooks
module hook() {
    cube([$thickness, $thickness, $holder_height]);
    translate([0, 0, $holder_height - $thickness]) {
        cube([$thickness, $hook_depth, $thickness]);
        
        translate([0, $hook_depth, -($hook_hook - $thickness)]) {
            cube([$thickness, $thickness, $hook_hook]);
        }
    }
}
translate([0, $basket_depth - $thickness, $basket_height]) {
    hook();
    
    translate([$width - $thickness, 0, 0]) {
        hook();
    }
}