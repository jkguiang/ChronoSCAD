// Sensor Placement Logic
module drawSensors(face) {
	sensorHalfWidth = lgadWidth+circuitWidth;
	zDisp = (face == 1) ? 0 : -(sensorThick+endcapThick);
	translate([0,0,zDisp])
	for(inc=[0:1:endcapOuterRadius]) {
		x = inc*(sensorHalfWidth);
		yMax = pow(pow(endcapOuterRadius, 2)-pow(x+(sensorHalfWidth),2), 0.5);
		yMin = (x <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x,2), 0.5) : 0;
		if (x <= endcapOuterRadius) {
			if (inc%2 == 0) {
				// X-axis Placement
				drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				// Y-axis Placement
				rotate([0,0,90])
				drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face);
			}
			else {
				// X Axis Placement
				drawOddQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				// Y-axis Placement
				rotate([0,0,90])
				drawOddQuadrants(x, yMax, yMin, sensorHalfWidth, face);
			}	
		}
	}
}

module drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face) {
	for (y=[yMin:sensorLength:yMax]) {
		if (y+sensorLength <= yMax) {
			if (face == front) {
				SensorHalfLeft(x,y);
				SensorHalfRight(-x-sensorHalfWidth,-y-sensorLength);				
			}
			else {
				SensorHalfRight(x,y);
				SensorHalfLeft(-x-sensorHalfWidth,-y-sensorLength);					
			}
		}
	}
}

module drawOddQuadrants(x, yMax, yMin, sensorHalfWidth, face) {
	for (y=[yMin:sensorLength:yMax]) {
		if (y+sensorLength <= yMax) {
			if (face == front) {
				SensorHalfRight(x,y);
				SensorHalfLeft(-x-sensorHalfWidth,-y-sensorLength);				
			}
			else {
				SensorHalfLeft(x,y);
				SensorHalfRight(-x-sensorHalfWidth,-y-sensorLength);	
			}
		}
	}
}