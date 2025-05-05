
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

$fn = 64;


outer_hook_fillet = .45;
inner_hook_fillet = .15;


difference() {
    rcube([$width, $basket_depth, $basket_height]);
    
    // inside cut
    translate ([$thickness, $thickness, $thickness]) {
        rcube([$width - 2*$thickness, $basket_depth - 2*$thickness, 999]);
    }
    
    // horizontal cuts
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
}
translate([0, $basket_depth - $thickness, $basket_height]) {
    hook();
    
    translate([$width - $thickness, 0, 0]) {
        hook();
    }
}