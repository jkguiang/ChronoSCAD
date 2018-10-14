include <./modules.scad>;

// Placement Logic: x
for(inc=[0:1:endcapOuterRadius]) {
	x = inc*(lgadWidth+circuitWidth);
	yMax = pow(pow(endcapOuterRadius, 2)-pow(x+(lgadWidth+circuitWidth),2), 0.5);
	yMin = (x <= endcapInnerRadius) ? pow(pow(endcapInnerRadius, 2)-pow(x,2), 0.5) : 0;	
	if (x <= endcapOuterRadius) {
		if (x == 0) {
			for (y=[yMin:sensorLength:yMax]) {
				if (y+sensorLength <= endcapOuterRadius) {
					SensorHalfLeft(x,y,front);
				}
			}
		}
		else {
			if (inc%2 == 0) {
				for (y=[yMin:sensorLength:yMax]) {
					if (y+sensorLength <= yMax) {
						SensorHalfLeft(x,y,front);
					}
				}
			}
			else {
				for (y=[yMin:sensorLength:yMax]) {
					if (y+sensorLength <= yMax) {
						SensorHalfRight(x,y,front);
					}
				}
			}
		}		
	}
}