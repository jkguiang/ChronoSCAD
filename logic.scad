// Sensor Placement Logic
module drawSensors(face, yParallel=true) {
	sensorHalfWidth = lgadWidth+circuitWidth;
	zDisp = (face == 1) ? 0 : -(sensorThick+endcapThick);
	loopStart = (!strips && face == front && (wedges || yParallel)) ? 1 : 0;
	channelDisp = (wedges || yParallel) ? 0 : channel;
	translate([0,0,zDisp])
	for(inc=[loopStart:1:endcapOuterRadius]) {
		nudge = (inc == 0 && !wedges) ? 0.25 : 0;
		x = inc*(sensorHalfWidth+0.5)+nudge;
		if (x <= endcapOuterRadius) {
			correction = (inc != 0 && circuitModules) ? circuitWidth : 0;
			correction1 = (inc != 0 && face == front && inline) ? sensorHalfWidth+0.5 : correction;  // Check one LGAD+circuit closer to origin
			correction2 = (inc != 0 && face == back && inline) ? sensorHalfWidth+0.5 : correction;   // ...
			if (inc%2 == 0) {
				yMin = (x-correction1 <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x-correction1, 2), 0.5) : channelDisp;
				yMax = pow(pow(endcapOuterRadius, 2)-pow(x+correction2+(sensorHalfWidth), 2), 0.5);
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
				yMin = (x-correction2 <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x-correction2, 2), 0.5) : channelDisp;
				yMax = pow(pow(endcapOuterRadius, 2)-pow(x+correction1+(sensorHalfWidth), 2), 0.5);
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
	yRoundStart = round(yMin/sensorLength)*(sensorLength+0.5)+0.5;
	yAlignStart = (yRoundStart < yMin) ? yRoundStart+sensorLength+0.5 : yRoundStart;
	yStart = (align) ? yAlignStart : yMin;
	for (y=[yStart:(sensorLength+0.5)*nSensors:yMax]) {
		if (y+(sensorLength+0.5)*nSensors <= yMax) {
			for (yInc=[0:1:nSensors-1]) {
				thisY = y+(sensorLength+0.5)*yInc;
				echo("LGAD", x=x, y=thisY);
				if (face == front) {
					SensorHalfLeft(x,thisY,face);
					SensorHalfRight(-x-sensorHalfWidth,-thisY-sensorLength,face);
				}
				else {
					SensorHalfRight(x,thisY,face);
					SensorHalfLeft(-x-sensorHalfWidth,-thisY-sensorLength,face);
				}
			}
		}
	}
}

module drawOddQuadrants(x, yMax, yMin, sensorHalfWidth, face) {
	yRoundStart = round(yMin/sensorLength)*(sensorLength+0.5)+0.5;
	yAlignStart = (yRoundStart < yMin) ? yRoundStart+sensorLength+0.5 : yRoundStart;
	yStart = (align) ? yAlignStart : yMin;
	for (y=[yStart:(sensorLength+0.5)*nSensors:yMax]) {
		if (y+(sensorLength+0.5)*nSensors <= yMax) {
			for (yInc=[0:1:nSensors-1]) {
				thisY = y+(sensorLength+0.5)*yInc;
				echo("LGAD", x=x, y=thisY);
				if (face == front) {
					SensorHalfRight(x,thisY,face);
					SensorHalfLeft(-x-sensorHalfWidth,-thisY-sensorLength,face);
				}
				else {
					SensorHalfLeft(x,thisY,face);
					SensorHalfRight(-x-sensorHalfWidth,-thisY-sensorLength,face);
				}
			}
		}
	}
}