include <BOSL2/std.scad>
$fn = 64;

skip_middle = true; // This is in coordination with skadis_columns.
groove = true;
groove_count = 1;
groove_spacing = 0;

cable_diameter = 6;

skadis_columns = 2;


wall_thickness = 2;
wall_height_extension = 0;

hook_fit_offset = 0.25;


module hook(hook_width, hook_depth, hook_height) {
    hook_wall_gap =  5.25; // This is the board thickness
    diff()
    cuboid([hook_width, hook_depth, hook_height], rounding = hook_width / 2, edges="Y") {
        tag("remove") position(BACK) #cuboid([hook_width, hook_wall_gap, hook_height/2], anchor=TOP + BACK);
    }
    
}

module cut_out(wall_width, wall_depth, hook_distance, hook_width, hook_depth, hook_height) {
    wall_height = hook_height + wall_height_extension;
    
    diff()
    cuboid([wall_width, wall_depth, wall_height], rounding = hook_width/2, edges=[BACK+LEFT, BACK+RIGHT], anchor=LEFT + FRONT) {
        if (skip_middle) {
            if (groove) {
                // We want to center grooves along the entire width
                opening_width = wall_width - (hook_width*2);
                groove_total = cable_diameter * groove_count + (groove_count==1 ? 0 : cable_diameter) + (groove_count==1 ? 0 : groove_count * groove_spacing);
                slot_width = cable_diameter;
                left_offset = (opening_width - groove_total)/2;
                    #xcopies(l=(cable_diameter*groove_count) + (groove_count * groove_spacing), n=groove_count, sp=[0,0,0]) right(hook_width + left_offset) back(cable_diameter) position(LEFT+FRONT) tag("remove") cuboid([slot_width, cable_diameter, wall_height+1], rounding = cable_diameter/2, edges=[BACK+LEFT, BACK+RIGHT], anchor=LEFT + BACK);       
            } else {
                #tag("remove") position(LEFT+FRONT) right(hook_width) back(cable_diameter) cuboid([wall_width - (hook_width*2), cable_diameter, wall_height+1], rounding = cable_diameter/2, edges=[BACK+LEFT, BACK+RIGHT], anchor=LEFT + BACK);    
            }
        } else {
            if (groove) {
                // We want to center grooves inside each section
                opening_width = hook_distance - hook_width;
                groove_total = cable_diameter * groove_count + (groove_count==1 ? 0 : cable_diameter) + (groove_count==1 ? 0 : groove_count * groove_spacing);
                slot_width = cable_diameter;
                left_offset = (opening_width - groove_total)/2;
                #xcopies(hook_distance, n=skadis_columns-1, sp=[0,0,0]) 
                    xcopies(l=(cable_diameter*groove_count) + (groove_count * groove_spacing), n=groove_count, sp=[0,0,0]) right(hook_width + left_offset) back(cable_diameter) position(LEFT+FRONT) tag("remove") cuboid([slot_width, cable_diameter, wall_height+1], rounding = cable_diameter/2, edges=[BACK+LEFT, BACK+RIGHT], anchor=LEFT + BACK);   
            } else {
                slot_width = hook_distance - hook_width;
                left_offset = (hook_distance - hook_width - slot_width)/2;
                #xcopies(hook_distance, n=skadis_columns-1, sp=[0,0,0]) right(hook_width+left_offset) back(cable_diameter) position(LEFT+FRONT) tag("remove") cuboid([slot_width, cable_diameter, wall_height+1], rounding = cable_diameter/2, edges=[BACK+LEFT, BACK+RIGHT], anchor=LEFT + BACK);   
            }

        }
    
    }
}

module bracket() {
    hook_width = 5 - hook_fit_offset;
    hook_depth = 10;
    hook_height = 15 - hook_fit_offset;
    
    hook_distance = 40; // Distance between two hooks
    
    wall_depth = cable_diameter + wall_thickness;
    wall_width = (skadis_columns - 1) * hook_distance + hook_width;
    
    if (skip_middle) {
        xcopies(l=wall_width - hook_width, n=2, sp=[0,0,0]) hook(hook_width, hook_depth, hook_height);
    } else {
        xcopies(hook_distance, n=skadis_columns, sp=[0,0,0]) hook(hook_width, hook_depth, hook_height);
    }
    
    back(hook_depth/2) left(hook_width/2) cut_out(wall_width, wall_depth, hook_distance, hook_width, hook_depth, hook_height);
}

color("white") {
    bracket();
}













