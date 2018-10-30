// Sensor Placement Logic
module drawSensors(face) {
	sensorHalfWidth = lgadWidth+circuitWidth;
	zDisp = (face == 1) ? 0 : -(sensorThick+endcapThick);
	translate([0,0,zDisp])
	for(inc=[0:1:endcapOuterRadius]) {
		x = inc*(sensorHalfWidth+0.5);
		if (x <= endcapOuterRadius) {
			correction1 = (inc != 0 && face == front && inline) ? sensorHalfWidth+0.5 : 0;
			correction2 = (inc != 0 && face == back && inline) ? sensorHalfWidth+0.5 : 0;
			if (inc%2 == 0) {
				yMin = (x-correction1 <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x-correction1,2), 0.5) : 0.5;
				yMax = pow(pow(endcapOuterRadius, 2)-pow(x+correction2+(sensorHalfWidth+circuitWidth),2), 0.5);
				// X-axis Placement
				drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face);
				rotate([0,0,90])
				drawEvenQuadrants(x, yMax, yMin, sensorHalfWidth, face);
			}
			else {
				yMin = (x-correction2 <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x-correction2,2), 0.5) : 0.5;
				yMax = pow(pow(endcapOuterRadius, 2)-pow(x+correction1+(sensorHalfWidth+circuitWidth),2), 0.5);
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
	for (y=[yMin:sensorLength+0.5:yMax]) {
		if (y+sensorLength+0.5 <= yMax) {
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
	for (y=[yMin:sensorLength+0.5:yMax]) {
		if (y+sensorLength+0.5 <= yMax) {
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