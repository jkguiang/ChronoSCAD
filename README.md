# ChronoSCAD
![alt text](https://github.com/jkguiang/ChronoSCAD/blob/master/docs/cover.png)
## Legend
```cpp
/* ------------ Legend ------------
   -> All measurements are in mm <-
  Length <--> x
  Width <--> y
  Thick <--> z
  front = 1
  back = -1
  zOffset = 3000; // Endcap is at z=3m in CMS
  flat = false;   // Toggle 
*/
```
## Modules
```cpp
// Draw sensors on the front (facing away from origin) or back (facing towards origin) face of the endcap
drawSensors(face)
    int face = front (1), back (-1)
```
```cpp
// Draw Trajectories
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
