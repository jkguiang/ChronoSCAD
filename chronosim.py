import numpy as np
from stl import mesh
from mpl_toolkits import mplot3d
from matplotlib import pyplot as plt

def LoadMesh(stlPath, sf=1, verbose=False):
    """ Load polygon mesh, only return polygons with normal in z-direction """
    lgadMesh = mesh.Mesh.from_file(stlPath)
    allVectors = lgadMesh.vectors
    zVectors = []
    for i, n in enumerate(lgadMesh.normals):
        if (n[2] > 0):
            zVectors.append([ allVectors[i][0]*sf, allVectors[i][1]*sf, allVectors[i][2]*sf ])

    if verbose:
        print("Loaded {0} polygons from file: {1}".format(len(zVectors), stlPath))
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

def LoadRays(rayPath, verbose=False):
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
    if verbose:
        print("Loaded {0} trajectories from file {1}".format(len(rays), rayPath))

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


def Parse(stlPath, rayPath, verbose=False):
    """ Parse polygons and rays, look for hits """

    # Load STL and ray trajectory files
    polys = LoadMesh(stlPath, sf=(0.001), verbose=verbose)
    rays = LoadRays(rayPath, verbose=verbose)
    hits = []
    rayHits = {}
    polyHits = {}
    output = { "polys":{ "hitCount":{}, "hitPolys":[] },
                "rays":{ "hitCount":{} } }

    # Loop over rays
    for i, ray in enumerate(rays[0:100]):
        output["rays"]["hitCount"][i] = 0
        # Loop over polygons
        for j, poly in enumerate(polys):
            if j not in polyHits:
                output["polys"]["hitCount"][j] = 0
            # Calculate ray's proximity to first polygon vertex
            t = abs(poly[0][2] - ray["pos"][2])/ray["p"][2]
            hitPos = [ ray["pos"][0]+t*ray["p"][0], 
                       ray["pos"][1]+t*ray["p"][1],
                       ray["pos"][2]+t*ray["p"][2] ]
            xDisp = abs(hitPos[0] - poly[0][0])
            yDisp = abs(hitPos[1] - poly[0][1])
            # Check for proximity then trajectory intersection
            if xDisp < 0.1 and yDisp < 0.1 and CheckHit(poly, hitPos):
                output["polys"]["hitPolys"].append(poly)
                output["polys"]["hitCount"][j] += 1
                output["rays"]["hitCount"][i] += 1

    if verbose:
        rayCount = float(len(rays[0:100]))
        hitCount = 0
        doubleHitCount = 0
        for k in output["rays"]["hitCount"]:
            nHits = output["rays"]["hitCount"][k]
            if nHits > 0:
                hitCount += 1
                if nHits == 2:
                    doubleHitCount += 1
        singleHitCount = hitCount - doubleHitCount
        print("--> Results from {} Simulated Trajectories <--".format(int(rayCount)))
        print("Total Hits: {0} ({1}%)".format(hitCount, (hitCount/rayCount)*100))
        print("Single Hits: {0} ({1}%)".format(singleHitCount, (singleHitCount/rayCount)*100))
        print("Double Hits: {0} ({1}%)".format(doubleHitCount, (doubleHitCount/rayCount)*100))

    Render(output["polys"]["hitPolys"], polys)

    return output

def Render(hitPolys, allPolys):
    """ Draw hit polygons over all polygons """

    # Set up plot
    figure = plt.gcf()
    axes = figure.add_subplot(111, projection='3d')
    axes._axis3don = False 

    # Plot hit polygons
    axes.add_collection3d(mplot3d.art3d.Poly3DCollection(hitPolys, facecolors="g"))

    # Plot all polygons
    collection = mplot3d.art3d.Poly3DCollection(allPolys, linewidths=1, alpha=0.1)
    face_color = [0.5, 0.5, 1]
    collection.set_facecolor(face_color)
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

if __name__ == "__main__":
    #LoadMesh(stlPath='stl/1250mmOuterRad.stl', sf=(0.001), verbose=True)
    response = Parse('stl/lgads.stl', 'txt/output_1927.txt', verbose=True)
