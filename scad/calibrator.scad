/* [General] */

// The length of the object (mm) ex: 150mm for a 200mm printbed
length = 150;

// The width of the object (mm) ex: 150mm for a 200mm printbed
width = 150;

// The height of the object (mm)
height = 5;

// # of rings on the length (mm, >=3)
num_rings_length = 5; 

// # of rings on the width (mm, >=3)
num_rings_width = 5;

/* [Ring] */

// The outer radius of the ring (mm)
outer_radius = 10;

// The outer radius of the ring (mm)
inner_radius = 6;

// Resolution of the ring (mm)
resolution = 50; // [10:150]

/* [Connector] */

// The width of connectors (mm), 0 for empty space
connector_width = 3;

/* [Hidden] */

module ring(r1, r2, h, quality) {
	//cylinder(r = r1, h = h, $fn=quality, center = true);
    difference() {
        cylinder(r = r1, h = h, $fn=quality, center = true);
        translate([ 0, 0, -1 ]) cylinder(r = r2, h = h+2, $fn=quality, center = true);
    }
}

// ring(outer_radius, inner_radius, height, resolution);

module connector(size,properties) {
	difference() {
		cube(size=size,center=true);
		cylinder(r=properties[0],h=properties[1],$fn=properties[2],center=true);
	}

}

module corner_connector(size,shift,properties){
	difference() {
		translate(shift)
			cube(size=size,center=true);
		cylinder(r=properties[0],h=properties[1],$fn=properties[2],center=true);
	}	
}

module print_part() {
	corner_length = length / 2;
	corner_width = width /2;
	ring_gap_length = length / (num_rings_length-1);
	ring_gap_width = width / (num_rings_width-1);

	for(i = [0:num_rings_length-1]){
			translate([corner_length-i*ring_gap_length,corner_width,0]){
				ring(outer_radius, inner_radius, height, resolution);
				if(i!=0 && i!=num_rings_length-1){
					// Add connector
					connector(size=[ring_gap_length,connector_width,height],
							properties=[outer_radius,height,resolution]);
				}else if(i==0){
					corner_connector(size=[ring_gap_length / 2,connector_width,height],
							shift=[-(ring_gap_length / 2 / 2),0,0],
							properties=[outer_radius,height,resolution]);
				}else if(i==num_rings_length-1){
					corner_connector(size=[ring_gap_length / 2,connector_width,height],
							shift=[(ring_gap_length / 2 / 2),0,0],
							properties=[outer_radius,height,resolution]);
				}
			}
			translate([corner_length-i*ring_gap_length,-corner_width,0]){
				ring(outer_radius, inner_radius, height, resolution);
				if(i!=0 && i!=num_rings_length-1){
					// Add connector
					connector(size=[ring_gap_length,connector_width,height],
							properties=[outer_radius,height,resolution]);
				}else if(i==0){
					corner_connector(size=[ring_gap_length / 2,connector_width,height],
							shift=[-(ring_gap_length / 2 / 2),0,0],
							properties=[outer_radius,height,resolution]);
				}else if(i==num_rings_length-1){
					corner_connector(size=[ring_gap_length / 2,connector_width,height],
							shift=[(ring_gap_length / 2 / 2),0,0],
							properties=[outer_radius,height,resolution]);
				}
			}
	}

	

	for(i=[0:num_rings_width-1]){
			translate([corner_length, corner_width - i * ring_gap_width,0]){
				ring(outer_radius, inner_radius, height, resolution);
				if(i!=0 && i!=num_rings_width-1){
					// Add connector
					connector(size=[connector_width,ring_gap_width,height],
							properties=[outer_radius,height,resolution]);
				}else if(i==0){
					corner_connector(size=[connector_width,ring_gap_width / 2,height],
							shift=[0,-(ring_gap_width / 2 / 2),0],
							properties=[outer_radius,height,resolution]);
				}else if(i==num_rings_width-1){
					corner_connector(size=[connector_width,ring_gap_width / 2,height],
							shift=[0,(ring_gap_width / 2 / 2),0],
							properties=[outer_radius,height,resolution]);
				}
			}
			translate([-corner_length, corner_width - i * ring_gap_width,0]){
				ring(outer_radius, inner_radius, height, resolution);
				if(i!=0 && i!=num_rings_width-1){
					// Add connector
					connector(size=[connector_width,ring_gap_width,height],
							properties=[outer_radius,height,resolution]);
				}else if(i==0){
					corner_connector(size=[connector_width,ring_gap_width / 2,height],
							shift=[0,-(ring_gap_width / 2 / 2),0],
							properties=[outer_radius,height,resolution]);
				}else if(i==num_rings_width-1){
					corner_connector(size=[connector_width,ring_gap_width / 2,height],
							shift=[0,(ring_gap_width / 2 / 2),0],
							properties=[outer_radius,height,resolution]);
				}
			}
	}
}

print_part();