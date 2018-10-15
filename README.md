# ChronoSCAD
![alt text](https://github.com/jkguiang/ChronoSCAD/blob/master/docs/sensors-endcap.png)
## Legend
```cpp
// Variable name mapping to x,y,z dimensions
<{var}Length> --> x-dimension
<{var}Width> --> y-dimension
<{var}Thick> --> z-dimension
// Shortcut variables for declaring position rel. to endcap faces
front = 1    // +z-direction
back = -1    // -z-direction
// Toggle circuit space highlighting
showCircuits = (true, false)
```
## Modules
```cpp
// Draw sensors on the front (Cyan) or back (Salmon) side of the endcap
drawSensors(face)
    int face = front (1), back (-1)
```
```cpp
// Draw endcap
Endcap()
```
```cpp
// Draw axes
axes()
```
