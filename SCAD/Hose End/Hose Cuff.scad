quality = 25;			// Quality of curves
coil_diameter = 7;		// Diameter of coils in the helix
outer_diameter = 46;		// Diameter of central thread (add d1 for max diameter )
coil_spacing = 5;		// Height between coils (0 means coils have no separation)
thread_height = 25;		// Height of total coil (should be non-zero)
wall_thickness = 2;		// Thickness of outer cuff wall
internal_diameter = 38;	// Diameter of end stop hole
stop_height = 2;			// Height of stop
direction = "ccw";		// Direction of helix cw/ccw

module half_torus( d1, w ) {
	rotate_extrude( convexity = 10, $fn = quality )
		translate( [ w / 2, 0, 0 ] )
			circle( r = d1 / 2, $fn = quality );
}

module basic_helix( d1, w, h1, an ) {
	rotate( a = an, v = [ 0, 1, 0 ] ) {	
		union() {
		translate( [ w / 2, 0, 0])
			difference() {
				half_torus( d1, w );
				translate( [ 0, -( w + d1 ) / 4 - 0.1, 0 ] )
					cube( size = [ w + d1, ( w + d1 ) / 2, d1 ], center = true );
			}
		}
	}
}

module basic_unit( d1, w, h1 ) {
	union() {
		if ( direction == "cw" ) {
			basic_helix( d1, w, h1, -asin( ( d1 + h1 ) / ( 2 * w ) ) );
		} else {
			basic_helix( d1, w, h1, asin( ( d1 + h1 ) / ( 2 * w ) ) );
		}
		translate( [ 0, 0, h1 + d1 ] )
			mirror( [ 0, 1, 0 ] )
				mirror( [ 0, 0, 1 ] )
					if ( direction == "cw" ) {
						basic_helix( d1, w, h1, -asin( ( d1 + h1 ) / ( 2 * w ) ) );
					} else {
						basic_helix( d1, w, h1, asin( ( d1 + h1 ) / ( 2 * w ) ) );
					}
	}
}

module main_helix( d1, w, h1, h2 ) {
	union() {
		for ( i = [ 0 : ( h1 + d1 ) : h2 ] ) {
		translate( [ 0, 0, i ] )
			basic_unit( d1, w, h1 );
		}
	}
}

module spring( d1, d2, h1, h2 ) {
	w = sqrt( pow( d2, 2 ) + pow( ( h1 + d1 ) / 2, 2 ) );
	difference() {
		translate( [ -d2 / 2, 0, -d1 / 2 ] )
			main_helix( d1, d2, h1, h2 );
		translate( [ 0, 0, -d1 / 2 ] )
			cube( size = [ d2 + 2 * d1, d2 + 2 * d1, d1 ], center = true);
		}
}

module screw_cuff( d1, d2, h1, h2  ) {
	union() {
		difference() {
			cylinder( r = ( d2 / 2 ) + wall_thickness, h = stop_height, $fn = quality );
			translate( [ 0, 0, -1 ] )
				cylinder( r = internal_diameter / 2, h = stop_height + 2, $fn = quality );
		}

		translate( [ 0, 0, stop_height ] )
		difference() {
			union() {
				intersection() {
					spring( d1, d2, h1, h2 );
					translate( [ 0, 0, h2 / 2 ] )
						cylinder( h = h2, r = ( d2 / 2 ), center = true, $fn = quality );
				}
			
				difference() {
					translate( [ 0, 0, h2 / 2] )
						cylinder( h = h2, r = ( d2 / 2 ) + wall_thickness, center = true, $fn = quality );	
	
					translate( [ 0, 0, h2 / 2] )
						cylinder( h = h2 + wall_thickness, r = ( d2 / 2 ), center = true, $fn = quality );	
				}
			}
			translate( [ 0, 0, h2 + ( h2 + h1 ) / 2])
				cube( size = [ d2 + 2 * d1, d2 + 2 * d1, h2 + h1], center = true );
		}
	}
}

screw_cuff( coil_diameter, outer_diameter, coil_spacing, thread_height );