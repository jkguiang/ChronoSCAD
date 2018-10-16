import time
import numpy as np
from stl import mesh
from mpl_toolkits import mplot3d
from matplotlib import pyplot as plt

from tqdm import tqdm

def LoadMesh(stlPath):
    """ Load polygon mesh, only return polygons with normal in z-direction """
    lgadMesh = mesh.Mesh.from_file(stlPath)
    allVectors = lgadMesh.vectors
    zVectors = []
    for i, n in enumerate(lgadMesh.normals):
        if (n[2] != 0):
            zVectors.append([ allVectors[i][0], allVectors[i][1], allVectors[i][2] ])

    return zVectors

def LoadRays(rayPath):
    """ Load ray trajectory data from txt file, map to dict """
    rays = []
    with open(rayPath, "r") as rayFile:
        for line in rayFile.readlines():
            ray = [ float(val) for val in line.split() ]
            rays.append({ "id":     ray[0],
                          "mass":   ray[1],
                          "charge": ray[2],
                          "pt":     ray[3],
                          "eta":    ray[4],
                          "phi":    ray[5],
                          "pos":    [ ray[6], ray[7], ray[8] ],
                          "dir":    [ ray[9], ray[10], ray[11] ]})

    return rays

def CheckHit(hitCand, ray):
    """ Check that nearby ray's trajectory intersects polygon """

    return True

def ParseMesh(stlPath, rayPath):
    """ Parse polygons and rays, look for hits """
    # Grab STL file
    polys = LoadMesh(stlPath)
    rays = LoadRays(rayPath)
    hits = []
    # Loop over rays
    for ray in tqdm(rays):
        isHit = False
        rayHits = []
        # Loop over polygons
        for poly in polys:
            # Calculate ray's origin proximity to first polygon vertex
            yDisp = abs(ray["pos"][1] - poly[0][1])
            xDisp = abs(ray["pos"][0] - poly[0][0])
            # Check for proximity and trajectory intersection
            if xDisp < 10 and yDisp < 10 and CheckHit(poly, ray):
                isHit = True
                rayHits.append(poly)
                print(ray["pos"], ray["dir"])
                print(poly)

        if isHit:
            hits.append({ "ray":ray, "hits":np.array(rayHits) })

    return hits

def Render(hits):
    """ Draw all hit polygons """

    # Set up plot
    figure = plt.figure()
    axes = mplot3d.Axes3D(figure)

    # Auto scale to mesh size
    # scale = lgadMesh.points.flatten(-1)
    # axes.auto_scale_xyz(scale, scale, scale)

    # Plot hits
    axes.add_collection3d(mplot3d.art3d.Poly3DCollection(hits["hits"]))
    plt.show()

    return

if __name__ == "__main__":
    ParseMesh('stl/lgads.stl', 'txt/output_1927.txt')
