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
channel = 20; // Half of the channel width

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

// ETL top
module ETLTop() {
	drawDetector(front);
	//drawTrajectories(50, toggleColors=true);
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

ETLTop();
//ETLBottom();
//BTL();
