quality = 50;				// Quality of curves
outer_diameter = 40.5;	// Diameter of central thread (add d1 for max diameter )
wall_thickness = 1.75;	// Thickness of outer cuff wall
slot_depth = 5.5;			// Depth of tab slot	
slot_width = 2;			// Width of tab slot
tab_height = 2.5;			// Height of tab
tab_length = 2;			// Length (depth) of tab
tab_width = 7;				// Width of tab
body_height = 8.5;		// Height of main body
end_overhang = 2.5;		// Radius of end overhang
end_height = 6;			// Height of end ring

union() {
	difference() {
		union() {
			difference() {
				cylinder( end_height, outer_diameter + wall_thickness, outer_diameter + wall_thickness + end_overhang, $fn = quality );
				translate( [ 0, 0, -1 ] )
				cylinder( end_height + 2, outer_diameter, outer_diameter, $fn = quality );
			}
			translate( [ 0, 0, end_height ] )
			difference() {
				cylinder( body_height, outer_diameter + wall_thickness, outer_diameter + wall_thickness, $fn = quality );
				translate( [ 0, 0, -1 ] )
				cylinder( body_height + 2, outer_diameter, outer_diameter, $fn = quality );
			}
		}
		translate( [ ( tab_width / 2 ), - ( outer_diameter + wall_thickness ), ( body_height + end_height ) - slot_depth ] )
		cube( [ slot_width , ( outer_diameter + wall_thickness + 1 ) * 2, slot_depth + 1 ] );
		translate( [ - ( ( tab_width / 2 ) + slot_width ), -( outer_diameter + wall_thickness ), ( body_height + end_height ) - slot_depth ] )
		cube( [ slot_width , ( outer_diameter + wall_thickness + 1 ) * 2, slot_depth + 1 ] );
	}
	difference() {
		translate( [ - ( tab_width / 2 ), - ( outer_diameter + wall_thickness + tab_length ), ( body_height + end_height ) - tab_height ] )
		cube( [ tab_width, ( outer_diameter + wall_thickness + tab_length ) * 2, tab_height ] );
		cylinder( 20, outer_diameter, outer_diameter, $fn = quality );
	}
}