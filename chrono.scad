include <./modules.scad>;
include <./logic.scad>;

/* --------- ChronoSCAD ---------
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
lgadWidth = 2;
circuitWidth = 2;
sensorLength = 4;
sensorThick = 0.1;

// Endcap Parameters
endcapOuterRadius = 120;
endcapInnerRadius = 20;
endcapThick = 5;

// Drawing
axes();
drawSensors(front);
drawSensors(back);
Endcap();