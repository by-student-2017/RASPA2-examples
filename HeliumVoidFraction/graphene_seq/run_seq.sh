#!/bin/bash

# UnitCellsi
xuc=5; yuc=6; zuc=6

chmod +x run

if [ ! -e HeliumVoidFraction.txt ]; then
	echo "# Name, Value, Error(+/-): UnitCellsi ${xuc} ${yuc} ${zuc}" > HeliumVoidFraction.txt
fi

#for ((i=4; i<=20; i++)); do
for ((w=40; w<1000; w+=5)); do
	echo "-----------------------------------------"
	date
	#
        i=`echo $w | awk '{printf "%4.2f",($1/10)}'`
	#zuc=$((24/${i}))
	zuc=`echo $i | awk '{printf "%d",(24/$1+0.9999)}'`
	echo "zuc="${zuc}
	#
	echo "folder name: "graphene_${i}A
	if [ ! -e graphene_${i}A ]; then	
		mkdir graphene_${i}A
	fi
	cd graphene_${i}A
	cp ./../graphene_tmp.cif graphene_${i}A.cif
	sed -i "s/C.CCCCC/${i}/" graphene_${i}A.cif
	sed -i "s/tmpX/${i}/" graphene_${i}A.cif
	cp ./../run ./run
	cp ./../simulation.input_tmp ./simulation.input
	sed -i s/XXXXX/graphene_${i}A/g simulation.input
	sed -i s/XUC/${xuc}/g simulation.input
	sed -i s/YUC/${yuc}/g simulation.input
	sed -i s/ZUC/${zuc}/g simulation.input
	./run
	#
	cd ..
	awk -v file=graphene_${i}A -v xuc=${xuc} -v yuc=${yuc} -v zuc=${zuc} '{if($3=="Widom" && $4=="Rosenbluth-weight:"){printf "%s, %f, %f, %d %d %d\n",file,$5,$7,xuc,yuc,zuc}}' ./graphene_${i}A/Output/System_0/output_graphene_${i}A_${xuc}.${yuc}.${zuc}_*_0.data >> HeliumVoidFraction.txt
	date
done
