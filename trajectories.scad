include <./tracks.scad>;

module Collision() {
	color("DarkGrey")
	sphere(r=30);
}

module Trajectory(points, pointsLength, intersect, pColor) {
	for ( i = [0:1:pointsLength-2] ) {
		color(pColor, alpha=0.7)
		polyhedron(
			points = [
				[(points[i][0]+.01)*1000, points[i][1]*1000, points[i][2]*1000],
				[points[i][0]*1000, (points[i][1]+.01)*1000, points[i][2]*1000],
				[(points[i][0]-.01)*1000, points[i][1]*1000, points[i][2]*1000],
				[points[i][0]*1000, (points[i][1]-.01)*1000, points[i][2]*1000],
				[(points[i+1][0]+.01)*1000, points[i+1][1]*1000, points[i+1][2]*1000],
				[points[i+1][0]*1000, (points[i+1][1]+.01)*1000, points[i+1][2]*1000],
				[(points[i+1][0]-.01)*1000, points[i+1][1]*1000, points[i+1][2]*1000],
				[points[i+1][0]*1000, (points[i+1][1]-.01)*1000, points[i+1][2]*1000]
			],
			faces = [[0,1,2,3], [4,5,6,7], [0,3,7,4], [3,2,6,7], [2,1,5,6], [1,0,4,5]]
		);
	}
	if (!(intersect[0] == 0 && intersect[1] == 0 && intersect[2] == 0)) {
		color("GreenYellow")
		translate([intersect[0]*1000, intersect[1]*1000, intersect[2]*1000])
		sphere(r=25);	
	}

}

module drawTrajectories(nTracks, toggleColors=true) {
	if (nTracks > len(tracks)) {
		echo(str("nTracks supplied (", nTracks,
				 ") exceeds the number of tracks stored (", len(tracks), ")"));
	}
	else {
		for ( i = [0:1:nTracks] ) {
			pColor = toggleColors ? tracks[i][4] : "AliceBlue";
			Trajectory(tracks[i][1], tracks[i][0], tracks[i][2], pColor);
		}	
	}
}