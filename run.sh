modType=${1}
modSize=${2}
gapSize=${3}

for nLayer in 0 1 2 3
do
    outName=${modType}-${modSize}_${gapSize}mmGap${nLayer}
    openscad -o ${outName}.stl -D "printLayer=${nLayer}" chrono.scad &> ${outName}_log.txt & 
done

