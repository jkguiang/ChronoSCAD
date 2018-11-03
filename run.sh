if [[ ${1} != "" ]] ; then
    outName=${1}
    for nLayer in 0 1 2 3
    do
        openscad -o ${outName}${nLayer}.stl -D "printLayer=${nLayer}" chrono.scad &> ${outName}_log${nLayer}.txt & 
    done
else
    echo "Usage: ./run.sh <outName>"
fi

