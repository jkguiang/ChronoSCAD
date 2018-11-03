include <./modules.scad>;
include <./logic.scad>;
include <./trajectories.scad>;
include <./barrel.scad>;

/* ---------- ChronoSCAD ----------
   -> All measurements are in mm <-
Legend:
  Length <--> x
  Width <--> y
  Thick <--> z
  front = 1
  back = -1
  zOffset (Endcap is at z=3m in CMS)
  flat = true, false (toggle 2D/3D LGADs)
Modules:
  # Draw sensors on the front or back side of the endcap
  drawSensors(face)
	face = front, back
  # Draw trajectories
  drawTrajectories(nTracks)
    nTracks = 0 -> 50
  # Draw endcap
  Endcap()
  # Draw collision point
  Collision()
  # Draw axes
  axes()
*/

// Endcap Sensor Parameters
lgadWidth = 21.8;
circuitWidth = 20.5;
sensorLength = 42.6;
sensorThick = 1;
showCircuits = false;
zOffset = 3000;
diskSpacing = 20;
flat = false;
inline = true;
nSensors = 3; // Number of sensors per module (in one row)
strips = false;
wedges = false;
channel = 21.8; // Half of the channel width

// Endcap Parameters
endcapOuterRadius = 1270;
endcapInnerRadius = 315;
endcapThick = (0.25*25.4);

// Barrel Sensor Parameters
barrelSensorWidth = 192.14; 
barrelSensorThick = 10;
barrelSensorLength = 4860;
barrelSensorSpacing = 0; // in degrees

// Barrel Parameters
barrelRadius = 1160;

// Drawing
module Detector() {
	Endcap();
	drawSensors(front);
	drawSensors(back);
}

module drawDetector(side) {
	translate([0,0,side*zOffset])
	Detector();
	if (wedges) {
		rotate([0,0,45])
		translate([0,0,side*(zOffset+diskSpacing)])
		Detector();				
	}
	else {
		rotate([0,0,90])
		translate([0,0,side*(zOffset+diskSpacing)])
		Detector();		
	}
}

module drawLayer(nLayer) {
	if (nLayer == 0) {
		translate([0,0,zOffset])
		drawSensors(back);
	}
	else if (nLayer == 1) {
		translate([0,0,zOffset])
		drawSensors(front);
	}
	else if (nLayer == 2) {
		if (wedges) {
			rotate([0,0,45])
			translate([0,0,(zOffset+diskSpacing)])
			drawSensors(back);				
		}
		else {
			rotate([0,0,90])
			translate([0,0,(zOffset+diskSpacing)])
			drawSensors(back, yParallel=false);		
		}
	}
	else if (nLayer == 3) {
		if (wedges) {
			rotate([0,0,45])
			translate([0,0,(zOffset+diskSpacing)])
			drawSensors(front);				
		}
		else {
			rotate([0,0,90])
			translate([0,0,(zOffset+diskSpacing)])
			drawSensors(front, yParallel=false);	
		}
	}
}

// ETL top
module ETLTop() {
	drawDetector(front);
	drawTrajectories(50, toggleColors=true);
}

// ETL bottom
module ETLBottom() {
	drawDetector(back);
	rotate([180,0,0])
	drawTrajectories(90, toggleColors=true);	
}

// BTL
module BTL() {
	drawBarrelTrajectories(180, toggleColors=true);
	Collision();
	drawBarrelHalf(back);
	//drawBarrel();
}

//ETLTop();
//ETLBottom();
//BTL();
printLayer = 0;
drawLayer(printLayer);
//drawLayer(1);
//drawLayer(2);
//drawLayer(3);
