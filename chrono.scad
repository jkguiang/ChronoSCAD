include <./modules.scad>;
include <./logic.scad>;
include <./trajectories.scad>;

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
  # Draw endcap
  Endcap()
  # Draw collision point
  Collision()
  # Draw axes
  axes()
*/

// Sensor Parameters
lgadWidth = 21.8;
circuitWidth = 10;
sensorLength = 42.6;
sensorThick = 1;
showCircuits = false;
zOffset = 3000;
flat = false;

// Endcap Parameters
endcapOuterRadius = 1270;
endcapInnerRadius = 315;
endcapThick = (0.25*25.4);

// Drawing
module Detector() {
	Endcap();
	drawSensors(front);
	drawSensors(back);
}

translate([0,0,zOffset])
Detector();
drawTrajectories(50);
Collision();