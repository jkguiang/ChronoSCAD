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
        print("From file: {}".format(stlPath))
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
                          "p":    [ ray[9], ray[10], ray[11] ]}) 

    return rays

def CrossProduct(a, b):
    return (a[0]*b[1] - a[1]*b[0])

def CheckHit(poly, hitPos):
    """ Check that nearby ray's trajectory intersects polygon """
    hitPosToVertex = [[ (poly[0][0]-hitPos[0]), (poly[0][1]-hitPos[1]) ],
                      [ (poly[1][0]-hitPos[0]), (poly[1][1]-hitPos[1]) ], 
                      [ (poly[2][0]-hitPos[0]), (poly[2][1]-hitPos[1]) ]]

    z0 = CrossProduct(hitPosToVertex[0], hitPosToVertex[1])
    z1 = CrossProduct(hitPosToVertex[1], hitPosToVertex[2])
    z2 = CrossProduct(hitPosToVertex[2], hitPosToVertex[0])

    return (z0 > 0 and z1 > 0 and z2 > 0)


def Parse(stlPath, rayPath):
    """ Parse polygons and rays, look for hits """

    # Load STL and ray trajectory files
    polys = LoadMesh(stlPath, sf=(0.001))
    rays = LoadRays(rayPath)
    hits = []
    noHits = []

    # Loop over rays
    for ray in tqdm(rays[0:100]):
        isHit = False
        # Loop over polygons
        for poly in polys:
            # Calculate ray's proximity to first polygon vertex
            t = abs(poly[0][2] - ray["pos"][2])/ray["p"][2]
            hitPos = [ ray["pos"][0]+t*ray["p"][0], 
                       ray["pos"][1]+t*ray["p"][1],
                       ray["pos"][2]+t*ray["p"][2] ]
            xDisp = abs(hitPos[0] - poly[0][0])
            yDisp = abs(hitPos[1] - poly[0][1])
            # Check for proximity then trajectory intersection
            if xDisp < 0.1 and yDisp < 0.1 and CheckHit(poly, hitPos):
                isHit = True
                hits.append(poly)

    Render(np.array(hits), np.array(polys))

    return hits

def Render(hits, polys):
    """ Draw all hit polygons """

    collection = mplot3d.art3d.Poly3DCollection(polys, linewidths=1, alpha=0.1)
    face_color = [0.5, 0.5, 1] # alternative: matplotlib.colors.rgb2hex([0.5, 0.5, 1])
    collection.set_facecolor(face_color)

    # Set up plot
    figure = plt.gcf()
    axes = figure.add_subplot(111, projection='3d')
    axes._axis3don = False 

    # Plot hits
    axes.add_collection3d(mplot3d.art3d.Poly3DCollection(hits, facecolors="g"))
    axes.add_collection3d(collection)

    # Plot barrel
    sr, sl = 3.6, 15.0
    t = np.linspace(0, 2*np.pi, 100)
    axes.plot(xs=sr*np.cos(t), ys=sr*np.sin(t), zs=sl/2, color='k')
    axes.plot(xs=sr*np.cos(t), ys=sr*np.sin(t), zs=-sl/2, color='k')
    for i in range(8):
        th = i * 2*np.pi/8
        x = sr*np.cos(th)
        y = sr*np.sin(th)
        axes.plot(xs=[x,x], ys=[y,y], zs=[-sl/2, sl/2], color='k')

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
    for i in range(len(rays)):
        axes.plot3D(xs=rays[i][:,0], ys=rays[i][:,1], zs=rays[i][:,2], color=colors[i%nc])

    sr, sl = 3.6, 15.0
    t = np.linspace(0, 2*np.pi, 100)
    axes.plot(xs=sr*np.cos(t), ys=sr*np.sin(t), zs=sl/2, color='k')
    axes.plot(xs=sr*np.cos(t), ys=sr*np.sin(t), zs=-sl/2, color='k')
    for i in range(8):
        th = i * 2*np.pi/8
        x = sr*np.cos(th)
        y = sr*np.sin(th)
        axes.plot(xs=[x,x], ys=[y,y], zs=[-sl/2, sl/2], color='k')
    plt.show()

    return

if __name__ == "__main__":
    #LoadMesh(stlPath='stl/1250mmOuterRad.stl', sf=(0.001), verbose=True)
    #Debug('stl/lgads.stl', 'txt/output_1927.txt')
    Parse('stl/lgads.stl', 'txt/output_1927.txt')
