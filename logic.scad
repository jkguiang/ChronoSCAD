// Sensor Placement Logic
module drawSensors(face, yParallel=true) {
	sensorHalfWidth = lgadWidth+circuitWidth;
	zDisp = (face == 1) ? 0 : -(sensorThick+endcapThick);
	loopStart = (!strips && face == front && (wedges || yParallel)) ? 1 : 0;
	translate([0,0,zDisp])
	for(inc=[loopStart:1:endcapOuterRadius]) {
		nudge = (inc == 0 && !wedges) ? 0.25 : 0;
		x = inc*(sensorHalfWidth+0.5)+nudge;
		if (x <= endcapOuterRadius) {
			correction1 = (inc != 0 && face == front && inline) ? sensorHalfWidth+0.5 : 0;
			correction2 = (inc != 0 && face == back && inline) ? sensorHalfWidth+0.5 : 0;
			channelDisp = (wedges || yParallel) ? 0 : channel;
			if (inc%2 == 0) {
				yMin = (x-correction1 <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x-correction1,2), 0.5) : 0.5+channelDisp;
				yMax = pow(pow(endcapOuterRadius, 2)-pow(x+correction2+(sensorHalfWidth+circuitWidth),2), 0.5);
				// X-axis Placement
				echo("QUAD",nQuad=0);
				drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				echo("QUAD",nQuad=1);
				if (wedges) {
					rotate([0,0,90])
					drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				}
				else {
					translate([0,0,(sensorThick+endcapThick)])
					rotate([180,0,180])
					drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				}			
			}
			else {
				yMin = (x-correction2 <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x-correction2,2), 0.5) : 0.5+channelDisp;
				yMax = pow(pow(endcapOuterRadius, 2)-pow(x+correction1+(sensorHalfWidth+circuitWidth),2), 0.5);
				// X Axis Placement
				echo("QUAD", nQuad=2);
				drawOddQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				echo("QUAD", nQuad=3);
//				// Y-axis Placement
				if (wedges) {				
					rotate([0,0,90])
					drawOddQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				}
				else {
					translate([0,0,(sensorThick+endcapThick)])
					rotate([180,0,180])
					drawOddQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				}					
			}	
		}
	}
}

module drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face) {
	for (y=[yMin:(sensorLength+0.5)*nSensors:yMax]) {
		if (y+(sensorLength+0.5)*nSensors <= yMax) {
			for (yInc=[0:1:nSensors-1]) {
				thisY = y+(sensorLength+0.5)*yInc;
				echo("LGAD", x=x, y=thisY);
				if (face == front) {
					SensorHalfLeft(x,thisY);
					SensorHalfRight(-x-sensorHalfWidth,-thisY-sensorLength);				
				}
				else {
					SensorHalfRight(x,thisY);
					SensorHalfLeft(-x-sensorHalfWidth,-thisY-sensorLength);
				}
			}
		}
	}
}

module drawOddQuadrants(x, yMax, yMin, sensorHalfWidth, face) {
	for (y=[yMin:(sensorLength+0.5)*nSensors:yMax]) {
		if (y+(sensorLength+0.5)*nSensors <= yMax) {
			for (yInc=[0:1:nSensors-1]) {
				thisY = y+(sensorLength+0.5)*yInc;
				echo("LGAD", x=x, y=thisY);
				if (face == front) {
					SensorHalfRight(x,thisY);
					SensorHalfLeft(-x-sensorHalfWidth,-thisY-sensorLength);				
				}
				else {
					SensorHalfLeft(x,thisY);
					SensorHalfRight(-x-sensorHalfWidth,-thisY-sensorLength);	
				}
			}
		}
	}
}