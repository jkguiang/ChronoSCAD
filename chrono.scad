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
  diskSpacing (Disks to be 20mm apart)
Configuration (true, false)
  showCircuits (draw circuits)
  flat (toggle 2D/3D LGADs)
  blocks (force LGADs to be inline blocks)
  strips (allow for single-LGAD strips along diameter)
  wedges (toggle between D and Wedge configurations)
  align (align all LGADs 'horizontally')
  circuitModules (reproduce TDR circuit modules)
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
circuitWidth = 20.4;
sensorLength = 42.6;
sensorThick = 1;
zOffset = 3000;
diskSpacing = 20;
nSensors = 3; // Number of sensors per module (in one row)
channel = 21.8; // Half of the channel width
wedgeChannel = 18.5;

// Configuration
showCircuits = true;
flat = false;
blocks = false;
strips = true;
wedges = true;
align = true;
circuitModules = true;

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
		//rotate([0,0,45])
		translate([0,0,side*(zOffset+diskSpacing)])
		Detector();				
	}
	else {
		//rotate([0,0,90])
		translate([0,0,side*(zOffset+diskSpacing)])
		Detector();		
	}
}

module drawLayer(nLayer) {
	if (nLayer == 0) {
		echo("START",layer=nLayer, z=zOffset-(sensorThick+endcapThick));
		translate([0,0,zOffset])
		drawSensors(back);
	}
	else if (nLayer == 1) {
		echo("START",layer=nLayer, z=zOffset);
		translate([0,0,zOffset])
		drawSensors(front);
	}
	else if (nLayer == 2) {
		echo("START",layer=nLayer, z=zOffset+diskSpacing-(sensorThick+endcapThick));
		if (wedges) {		
			//rotate([0,0,45])
			translate([0,0,(zOffset+diskSpacing)])
			drawSensors(back);
		}
		else {
			//rotate([0,0,90])
			translate([0,0,(zOffset+diskSpacing)])
			drawSensors(back);		
		}
	}
	else if (nLayer == 3) {
		echo("START",layer=nLayer, z=zOffset+diskSpacing);
		if (wedges) {
			//rotate([0,0,45])
			translate([0,0,(zOffset+diskSpacing)])
			drawSensors(front);				
		}
		else {
			//rotate([0,0,90])
			translate([0,0,(zOffset+diskSpacing)])
			drawSensors(front);	
		}
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
	drawTrajectories(50, toggleColors=true);	
}

// BTL
module BTL() {
	drawBarrelTrajectories(100, toggleColors=true);
	Collision();
	drawBarrelHalf(front);
	//drawBarrel();
}

ETLTop();
//ETLBottom();
//BTL();
//renderLayer = 0;
//drawLayer(renderLayer);
//drawLayer(1);
//drawLayer(2);
//drawLayer(3);
