// Sensor Placement Logic
module drawSensors(face) {
	angle = (face == 1) ? 0 : 180;
	push = (face == 1) ? 0 : -sensorThick-endcapThick;
	echo(angle);
	translate([0,0,push])
	rotate([0,angle,0])
	for(inc=[0:1:endcapOuterRadius]) {
		sensorHalfWidth = lgadWidth+circuitWidth;
		x = inc*(sensorHalfWidth);
		yMax = pow(pow(endcapOuterRadius, 2)-pow(x+(sensorHalfWidth),2), 0.5);
		yMin = (x <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x,2), 0.5) : 0;
		if (x <= endcapOuterRadius) {
			if (inc%2 == 0) {
				// X-axis Placement
				for (y=[yMin:sensorLength:yMax]) {
					if (y+sensorLength <= yMax) {
						SensorHalfLeft(x,y,face);
						SensorHalfLeft(-x-sensorHalfWidth,-y-sensorLength,face);
					}
				}
				// Y-axis Placement
				for (y=[yMin:sensorHalfWidth:yMax]) {
					if (y+sensorLength <= yMax) {
						rotate([0,0,90])
						SensorHalfLeft(x,y,face);
						rotate([0,0,90])
						SensorHalfLeft(-x-sensorHalfWidth,-y-sensorLength,face);
					}
				}
			}
			else {
				// X Axis Placement
				for (y=[yMin:sensorLength:yMax]) {
					if (y+sensorLength <= yMax) {
						SensorHalfRight(x,y,face);
						SensorHalfRight(-x-sensorHalfWidth,-y-sensorLength,face);
					}
				}
				// Y-axis Placement
				for (y=[yMin:sensorHalfWidth:yMax]) {
					if (y+sensorLength <= yMax) {
						rotate([0,0,90])
						SensorHalfRight(x,y,face);
						rotate([0,0,90])
						SensorHalfRight(-x-sensorHalfWidth,-y-sensorLength,face);
					}
				}
			}	
		}
	}
}