/* --------- Legend ---------
Dimensions:
  Length <--> x
  Width <--> y
  Thick <--> z
*/
// Sensor Parameters
lgadWidth = 2;
circuitWidth = 2;
sensorLength = 4;
sensorThick = 0.1;
front = 1;
back = -1;
// Endcap Parameters
endcapOuterRadius = 100;
endcapInnerRadius = 20;
endcapThick = 5;


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
axes();

// Sensor Modules
module LGAD(x,y,face) {
	translate([x,y,(endcapThick/2+sensorThick/2)*face])
	cube([lgadWidth, sensorLength, sensorThick]);
}
module Circuitry(x,y,face) {
// Sensor
	color("LightSkyBlue", 0.75)
	translate([x,y,(endcapThick/2+sensorThick/2)*face])
	cube([circuitWidth, sensorLength, sensorThick]);	
}
module Sensor(x,y,face) {
	union() {
		Circuitry(x,y,face);
		LGAD(x+circuitWidth,y,face);
		LGAD(x+circuitWidth+lgadWidth,y,face);
		Circuitry(x+circuitWidth+lgadWidth*2,y,face);
	}
}
module SensorHalfRight(x,y,face) {
	union() {
		Circuitry(x,y,face);
		color("ForestGreen")
		LGAD(x+circuitWidth,y,face);
	}	
}
module SensorHalfLeft(x,y,face) {
	union() {
		color("DarkGreen")
		LGAD(x,y,face);
		Circuitry(x+lgadWidth,y,face);
	}	
}
// Endcap Modules
module EndcapFace(face) {
// Endcap
	translate([0, 0, (endcapThick/4)*face])
	difference() {
		cylinder(h=endcapThick/2,         // Endcap
		         d=(endcapOuterRadius*2), 
		         center=true);
		cylinder(h=(endcapThick/2+1),     // Beampipe
		         d=(endcapInnerRadius*2), 
		         center=true);
	}
}
module Endcap() {
	
// Placement Logic: get iteration range
for(inc=[0:1:endcapOuterRadius]) {
	x = inc*(lgadWidth+circuitWidth);
	yMax = pow(pow(endcapOuterRadius, 2)-pow(x+(lgadWidth+circuitWidth),2), 0.5);
	yMin = (x <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x,2), 0.5) : 0;	
	if (x <= endcapOuterRadius) {
		if (x == 0) {
			for (y=[yMin:sensorLength:yMax]) {
				if (y+sensorLength <= endcapOuterRadius) {
					SensorHalfLeft(x,y,front);
				}
			}
		}
		else {
			if (inc%2 == 0) {
				for (y=[yMin:sensorLength:yMax]) {
					if (y+sensorLength <= yMax) {
						SensorHalfLeft(x,y,front);
					}
				}
			}
			else {
				for (y=[yMin:sensorLength:yMax]) {
					if (y+sensorLength <= yMax) {
						SensorHalfRight(x,y,front);
					}
				}
			}
		}		
	}

}
	union() {
		color("LightCyan")    // Front
		EndcapFace(front);
		color("LightSalmon")
		EndcapFace(back);	  // Back
	}
}

// Placement Logic: x-axis
for ([])
	
// Placement Logic: y-axis
Sensor(0,0,front);
Endcap();