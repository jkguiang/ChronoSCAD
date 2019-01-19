// Arbitrary, binary face definitions
front = 1;
back = -1;

// Utility Modules
module xAxis() {
	color("Red", 0.75)
	cube([1000, 0.5, endcapThick*1.1], center=true);
}
module yAxis() {
	color("Yellow", 0.75)
	cube([0.5, 1000, endcapThick*1.1], center=true);
}
module zAxis() {
	color("Blue")
	cylinder(h=1000, d=1, center=true);
}
module axes() {
	union() {
		xAxis();
		yAxis();
		zAxis();		
	}
}

// Sensor Modules
module LGAD(x,y) {
	if (flat) {
		translate([x,y,(endcapThick/2+sensorThick)])
		square([lgadWidth, sensorLength]);	
	}
	else {
		translate([x,y,(endcapThick/2)])
		cube([lgadWidth, sensorLength, sensorThick]);
	}

}
module Circuitry(x,y) {
	if (showCircuits) {
		color("Khaki")
		translate([x,y,(endcapThick/2)])
		cube([circuitWidth, sensorLength, sensorThick]);			
	}
}
// Sensor
module Sensor(x,y) {
	union() {
		Circuitry(x,y);
		LGAD(x+circuitWidth,y);
		LGAD(x+circuitWidth+lgadWidth,y);
		Circuitry(x+circuitWidth+lgadWidth*2,y);
	}
}
module SensorHalfRight(x,y,side) {
	union() {
		Circuitry(x,y);
		color((side == 1) ? "MediumBlue" : "ForestGreen")
		LGAD(x+circuitWidth,y);
	}	
}
module SensorHalfLeft(x,y,side) {
	union() {
		color((side == 1) ? "RoyalBlue" : "DarkSeaGreen")
		LGAD(x,y);
		Circuitry(x+lgadWidth,y);
	}	
}

// Endcap Modules
module EndcapFace(face) {
	translate([0, 0, (endcapThick/4)*face])
	difference() {
		cylinder(h=endcapThick/2,         // Endcap
		         d=(endcapOuterRadius*2), 
		         center=true,
				 $fn=100);
		cylinder(h=(endcapThick/2+1),     // Beampipe
		         d=(endcapInnerRadius*2), 
		         center=true,
				 $fn=100);
	}
}
// Endcap
module Endcap() {
	union() {
		color("LightCyan")    
		EndcapFace(front);   // Front
		color("PaleTurquoise")
		EndcapFace(back);	 // Back
	}
}
