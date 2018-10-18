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
Modules:
  # Draw sensors on the front (Cyan) or back (Salmon) side of the endcap
  drawSensors(face)
	face = front, back
  # Draw endcap
  Endcap()
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
	//SensorHalfLeft();
	//translate([0,sensorLength,0])
	//SensorHalfLeft();
	//rotate(a=[0,0,90])
	//SensorHalfLeft();
	//
	//translate([lgadWidth+1,0,0])
	//SensorHalfLeft();
	//translate([lgadWidth+1,sensorLength,0])
	//SensorHalfLeft();
	//axes();	
}

translate([0,0,zOffset])
Detector();
Trajectories();
