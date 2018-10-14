# ChronoSCAD
## Legend
```cpp
// Variable name mapping to x,y,z dimensions
<{var}Length> --> x-dimension
<{var}Width> --> y-dimension
<{var}Thick> --> z-dimension
// Shortcut variables for declaring position rel. to endcap faces
front = 1    // +z-direction
back = -1    // -z-direction
```
## Modules
```cpp
// Draw sensors on the front (Cyan) or back (Salmon) side of the endcap
drawSensors(face)
    int face = front (1), back (-1)
```
[[docs/endcap-axes-sensors.png]]
```cpp
// Draw endcap
Endcap()
```
[[docs/endcap.png]]
```cpp
// Draw axes
axes()
```
[[docs/endcap-axes.png]]
