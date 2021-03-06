# ChronoSCAD
[![CodeFactor](https://www.codefactor.io/repository/github/jkguiang/chronoscad/badge/master)](https://www.codefactor.io/repository/github/jkguiang/chronoscad/overview/master)
![alt text](https://github.com/jkguiang/ChronoSCAD/blob/master/docs/cover.png)
## Legend
```cpp
-> All measurements are in mm <-
Length <--> x
Width <--> y
Thick <--> z
front = 1
back = -1
zOffset = 3000; // Endcap is at z=3m in CMS coords
flat = false;   // Toggle 2D/3D LGADs 
```
## Modules
```cpp
// Draw sensors on the front (facing away from origin) or back (facing towards origin) face of the endcap
drawSensors(face)
    int face = front (1), back (-1)
```
```cpp
// Draw trajectories
drawTrajectories(nTracks)
    int nTracks = 0 -> 50 (max)
```
```cpp
// Draw endcap
Endcap()
```
```cpp
// Draw collision point
Collision()
```
```cpp
// Draw axes
axes()
```
