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

// Endcap Parameters
endcapOuterRadius = 1270;
endcapInnerRadius = 315;
endcapThick = (0.25*25.4);

// Barrel Sensor Parameters
barrelSensorWidth = 150;
barrelSensorThick = 1;
barrelSensorLength = 6000;
barrelSensorSpacing = 0.1; // in degrees

// Barrel Parameters
barrelRadius = 1290;

// Drawing
module Detector() {
	Endcap();
	drawSensors(front);
	drawSensors(back);
}

module drawDetector() {
	translate([0,0,zOffset])
	Detector();
	translate([0,0,zOffset+diskSpacing])
	Detector();	
}

drawDetector();
drawTrajectories(50, toggleColors=true);
rotate([0,0,-30])
drawBarrelTrajectories(50, toggleColors=true);
Collision();
drawBarrelHalf(back);
