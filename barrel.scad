module BarrelSensor(ang=0) {
	color("Turquoise")
	rotate([90,90,-ang+90])
	translate([-barrelSensorLength/2,0])
	cube([barrelSensorLength, barrelSensorWidth, barrelSensorThick], center=true);
}

module drawBarrel() {
	angInc = (barrelSensorWidth/barrelRadius)*(180/PI)+barrelSensorSpacing;
	for (ang=[0:angInc:360]) {
		x=cos(ang)*barrelRadius;
		y=cos(ang+90)*barrelRadius;
		if (!(-barrelSensorWidth/2 < y && y < barrelSensorWidth/2)) {
			translate([x,y,-barrelSensorLength/2])
			BarrelSensor(ang);			
		}
	}	
}

module drawBarrelHalf(side) {
	difference() {
		drawBarrel();
		translate([0,barrelRadius*1.25*side,0])
		cube([barrelRadius*2.5,barrelRadius*2.5,barrelSensorLength+5], center=true);
	}
}