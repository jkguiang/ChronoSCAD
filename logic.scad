// Sensor Placement Logic
module drawSensors(face, yParallel=true) {
	sensorHalfWidth = lgadWidth+circuitWidth;
	zDisp = (face == 1) ? 0 : -(sensorThick+endcapThick);
	loopStart = (!strips && face == front && (wedges || yParallel)) ? 1 : 0;
	channelDisp = (wedges || yParallel) ? 1 : channel;
	translate([0,0,zDisp])
	for(inc=[loopStart:1:endcapOuterRadius]) {
		nudge = (inc == 0 && !wedges) ? 0.25 : 0;
		x = inc*(sensorHalfWidth+lgadXSep)+nudge+wedgeChannel;
		if (x <= endcapOuterRadius) {
			correction = (inc != 0 && circuitModules) ? (34+3.925)-circuitWidth : 0;
			frontCorrection = (inc != 0 && face == front && blocks) ? sensorHalfWidth+lgadXSep+correction : correction; // Correction nearer to/farther from origin
			backCorrection = (inc != 0 && face == back && blocks) ? sensorHalfWidth+lgadXSep+correction : correction;   // ...
			if (inc%2 == 0) {
				xNear = (circuitModules && !blocks && face == front) ? x : x-frontCorrection;
				xFar = (circuitModules && !blocks && face == back) ? x+sensorHalfWidth : x+backCorrection+sensorHalfWidth;
				yMin = (xNear <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(xNear, 2), 0.5) : channelDisp;
				yMax = pow(pow(endcapOuterRadius, 2)-pow(xFar, 2), 0.5);
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
				xNear = (circuitModules && !blocks && face == back) ? x : x-backCorrection;
				xFar = (circuitModules && !blocks && face == front) ? x+sensorHalfWidth : x+frontCorrection+sensorHalfWidth;
				yMin = (xNear <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(xNear, 2), 0.5) : channelDisp;
				yMax = pow(pow(endcapOuterRadius, 2)-pow(xFar, 2), 0.5);
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
	yRoundStart = round(yMin/sensorLength)*(sensorLength+lgadYSep)+lgadYSep;
	yAlignStart = (yRoundStart < yMin) ? yRoundStart+sensorLength+lgadYSep : yRoundStart;
	yStart = (align) ? yAlignStart : yMin;
	for (y=[yStart:(sensorLength+lgadYSep)*nSensors:yMax]) {
		if (y+(sensorLength+lgadYSep)*nSensors <= yMax) {
			for (yInc=[0:1:nSensors-1]) {
				thisY = y+(sensorLength+lgadYSep)*yInc;
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
	yRoundStart = round(yMin/sensorLength)*(sensorLength+lgadYSep)+lgadYSep;
	yAlignStart = (yRoundStart < yMin) ? yRoundStart+sensorLength+lgadYSep : yRoundStart;
	yStart = (align) ? yAlignStart : yMin;
	for (y=[yStart:(sensorLength+lgadYSep)*nSensors:yMax]) {
		if (y+(sensorLength+lgadYSep)*nSensors <= yMax) {
			for (yInc=[0:1:nSensors-1]) {
				thisY = y+(sensorLength+lgadYSep)*yInc;
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