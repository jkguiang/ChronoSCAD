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
                          "dir":    [ ray[9], ray[10], ray[11] ]}) 

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

    return (z0*z1*z2 < 0)


def Parse(stlPath, rayPath):
    """ Parse polygons and rays, look for hits """
    # Load STL and ray trajectory files
    polys = LoadMesh(stlPath)
    rays = LoadRays(rayPath)
    hits = []
    # Loop over rays
    for ray in tqdm(rays[0:100]):
        isHit = False
        rayHits = []
        # Calculate velocity of particle
        vel = [ ray["dir"][0]/ray["mass"], 
                ray["dir"][1]/ray["mass"], 
                ray["dir"][2]/ray["mass"] ] 
        # Loop over polygons
        for poly in polys:
            # Calculate ray's proximity to first polygon vertex
            t = abs(poly[0][2] - ray["pos"][2])/vel[2]
            hitPos = [ ray["pos"][0]+t*vel[0], 
                       ray["pos"][1]+t*vel[1],
                       ray["pos"][2]+t*vel[2] ]
            xDisp = abs(hitPos[0] - poly[0][0])
            yDisp = abs(hitPos[1] - poly[0][1])
            # Check for proximity and trajectory intersection
            if xDisp < 0.05 and yDisp < 0.05 and CheckHit(poly, hitPos):
                isHit = True
                rayHits.append(poly)

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
    #LoadMesh(stlPath='stl/21mmElectronics.stl', sf=(0.001), verbose=True)
    #Debug('stl/lgads.stl', 'txt/output_1927.txt')
    #debugPoly = [ [0,0,0],
    #              [0,10,0],
    #              [10,0,0]]
    #debugHit = [5,-0.00001,0]
    #print(CheckHit(debugPoly, debugHit))
    Parse('stl/lgads.stl', 'txt/output_1927.txt')
