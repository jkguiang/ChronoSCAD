// Sensor Placement Logic
module drawSensors(face) {
	sensorHalfWidth = lgadWidth+circuitWidth;
	angle = (face == 1) ? 0 : 180;
	rotate([0,angle,0])
	for(inc=[0:1:endcapOuterRadius]) {
		x = inc*(sensorHalfWidth);
		yMax = pow(pow(endcapOuterRadius, 2)-pow(x+(sensorHalfWidth),2), 0.5);
		yMin = (x <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x,2), 0.5) : 0;
		if (x <= endcapOuterRadius) {
			if (inc%2 == 0) {
				// X-axis Placement
				drawEvenQuadrant(x, yMax, yMin, sensorHalfWidth);
				// Y-axis Placement
				rotate([0,0,90])
				drawEvenQuadrant(x, yMax, yMin, sensorHalfWidth);
			}
			else {
				// X Axis Placement
				drawOddQuadrant(x, yMax, yMin, sensorHalfWidth);
				// Y-axis Placement
				rotate([0,0,90])
				drawOddQuadrant(x, yMax, yMin, sensorHalfWidth);
			}	
		}
	}
}

module drawEvenQuadrant(x, yMax, yMin, sensorHalfWidth) {
	for (y=[yMin:sensorLength:yMax]) {
		if (y+sensorLength <= yMax) {
			SensorHalfLeft(x,y);
			SensorHalfRight(-x-sensorHalfWidth,-y-sensorLength);
		}
	}
}

module drawOddQuadrant(x, yMax, yMin, sensorHalfWidth) {
	for (y=[yMin:sensorLength:yMax]) {
		if (y+sensorLength <= yMax) {
			SensorHalfRight(x,y);
			SensorHalfLeft(-x-sensorHalfWidth,-y-sensorLength);
		}
	}
}