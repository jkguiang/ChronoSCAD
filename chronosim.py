import time
import numpy as np
from stl import mesh
from mpl_toolkits import mplot3d
from matplotlib import pyplot as plt

def LoadMesh(stlPath):
    lgadMesh = mesh.Mesh.from_file(stlPath)
    allVectors = lgadMesh.vectors
    zVectors = []
    for i, n in enumerate(lgadMesh.normals):
        if (n[2] != 0):
            zVectors.append([ allVectors[i][0], allVectors[i][1], allVectors[i][2] ])

    return np.array(zVectors)

def LoadRays(rayPath):
    rays = []
    with open(rayPath, "r") as rayFile:
        for line in rayFile.readlines():
            ray = [float(val) for val in line.split()]
            rays.append({ "id":     ray[0],
                          "mass":   ray[1],
                          "charge": ray[2],
                          "pt":     ray[3],
                          "eta":    ray[4],
                          "phi":    ray[5],
                          "pos":    [ ray[6], ray[7], ray[8] ],
                          "dir":    [ ray[9], ray[10], ray[11] ]})

    return rays

def ParseMesh(stlPath, rayPath):
    # Grab STL file
    polys = LoadMesh(stlPath)
    rays = LoadRays(rayPath)
    # Loop over rays
    for ray in rays:
        isHit = False
        # Loop over polygons
        for poly in polys:
            isNear = False
            # Check first vertex for proximity
            yDisp = abs(ray["pos"][1] - poly[0][1])
            xDisp = abs(ray["pos"][0] - poly[0][0])
            if yDisp < 10 and xDisp < 10:
                isNear = True
                isHit = True
                print(ray["pos"], ray["dir"])
                print(poly)
                break # DEBUG
        if not isHit: print("Fail")
    return

def render():
    """ DEBUGGING: Render STL file """
    # Grab STL file
    lgadMesh = mesh.Mesh.from_file('stl/quad_lgad.stl')

    # Define plot
    plt.ion()
    figure = plt.figure()
    axes = mplot3d.Axes3D(figure)
    vectors = LoadMesh('stl/quad_lgad.stl')
    print(vectors)
    print("Finished with {} vectors".format(len(vectors)))
    # Auto scale to mesh size
    scale = lgadMesh.points.flatten(-1)
    axes.auto_scale_xyz(scale, scale, scale)
    test = range(0,len(vectors))
    test.reverse()
    # Add vectors to plot
    for i in test:
        axes.add_collection3d(mplot3d.art3d.Poly3DCollection(vectors[i:len(vectors)]))
        plt.show()
        plt.pause(1)

    return

if __name__ == "__main__":
    print("simulation")
    ParseMesh('stl/lgads.stl', 'txt/output_1927.txt')
