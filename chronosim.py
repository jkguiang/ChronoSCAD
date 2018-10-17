import time
import numpy as np
from stl import mesh
from mpl_toolkits import mplot3d
from matplotlib import pyplot as plt

from tqdm import tqdm

def LoadMesh(stlPath, sf=1, verbose=False):
    """ Load polygon mesh, only return polygons with normal in z-direction """
    lgadMesh = mesh.Mesh.from_file(stlPath)
    allVectors = lgadMesh.vectors
    zVectors = []
    for i, n in enumerate(lgadMesh.normals):
        if (n[2] > 0):
            zVectors.append([ allVectors[i][0]*sf, allVectors[i][1]*sf, allVectors[i][2]*sf ])

    if (verbose):
        nLGAD = len(zVectors)/2
        nASIC = nLGAD*2
        print("---------------- Cost ----------------")
        print("+ {0} LGADs (${1})".format(nLGAD, 140*nLGAD))
        print("+ {0} ASICs (${1})".format(nASIC, 51*nASIC))
        print("+ {0} Al-N Support Structures (${1})".format(nASIC, 2*nASIC))
        print("+ {0} Power Converters (${1})".format(nASIC, 3*nASIC))
        print("+ {0} Transceivers (${1})".format(nASIC, 4*nASIC))
        print("______________________________________")
        print("= ${} total".format(140*nLGAD+60*nASIC))

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

def Parse(stlPath, rayPath):
    """ Parse polygons and rays, look for hits """
    # Load STL and ray trajectory files
    polys = LoadMesh(stlPath)
    rays = LoadRays(rayPath)
    hits = []
    # Loop over rays
    for ray in tqdm(rays):
        isHit = False
        rayHits = []
        # Loop over polygons
        for poly in polys:
            # Calculate ray's origin's proximity to first polygon vertex
            xDisp = abs(ray["pos"][0] - poly[0][0])
            yDisp = abs(ray["pos"][1] - poly[0][1])
            # Check for proximity and trajectory intersection
            if xDisp < 10 and yDisp < 10 and CheckHit(poly, ray):
                isHit = True
                rayHits.append(poly)
                # print(ray["pos"], ray["dir"])
                # print(poly)

        if isHit:
            hits.append({ "ray":ray, "hits":np.array(rayHits) })
    print(len(rays), len(hits), len(hits)/len(rays))
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

def Debug(stlPath, txtPath):
    from mpl_toolkits.mplot3d import Axes3D
    """ Load polygon mesh, only return polygons with normal in z-direction """

    vectors = LoadMesh(stlPath, sf=(0.001), verbose=True)
    rays = []
    with open(txtPath, "r") as rayFile:
        for line in rayFile.readlines():
            rays.append(np.array(eval(line)))

    figure = plt.gcf()
    axes = figure.add_subplot(111, projection='3d')
    colors = ['r','g','b','c','m','y']
    nc = len(colors)

    # Plot hits
    axes.add_collection3d(mplot3d.art3d.Poly3DCollection(vectors))
#    for i in range(len(rays)):
#        axes.plot3D(xs=rays[i][:,0], ys=rays[i][:,1], zs=rays[i][:,2], color=colors[i%nc])
#
#    sr, sl = 3.6, 15.0
#    t = np.linspace(0, 2*np.pi, 100)
#    axes.plot(xs=sr*np.cos(t), ys=sr*np.sin(t), zs=sl/2, color='k')
#    axes.plot(xs=sr*np.cos(t), ys=sr*np.sin(t), zs=-sl/2, color='k')
#    for i in range(8):
#        th = i * 2*np.pi/8
#        x = sr*np.cos(th)
#        y = sr*np.sin(th)
#        axes.plot(xs=[x,x], ys=[y,y], zs=[-sl/2, sl/2], color='k')
    plt.show()

    return

if __name__ == "__main__":
    LoadMesh(stlPath='stl/lgads.stl', sf=(0.001), verbose=True)
