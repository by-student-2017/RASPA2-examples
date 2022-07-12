#!/bin/bash

# UnitCellsi
xuc=5; yuc=6; zuc=1

chmod +x run

if [ ! -e HeliumVoidFraction.txt ]; then
	echo "# Name, Value, Error(+/-): UnitCellsi" > HeliumVoidFraction.txt
fi

#for ((i=4; i<=20; i++)); do
for ((w=40; w<1000; w+=5)); do
	echo "-----------------------------------------"
	date
	#
        i=`echo $w | awk '{printf "%4.2f",($1/10)}'`
	#zuc=$((24/${i}))
	#zuc=`echo $i | awk '{printf "%d",(24/$1+0.9999)}'`
	#echo "zuc="${zuc}
	#
	echo "folder name: "graphite_${i}A
	if [ ! -e graphite_${i}A ]; then	
		mkdir graphite_${i}A
	fi
	cd graphite_${i}A
	cp ./../graphite_tmp1.cif graphite_${i}A.cif
	awk -v sl=${sl} -v i=${i} '{if(NR<=32){printf "%s %s %8.5f %8.5f %8.5f %8.5f \n",$1,$2,$3,$4,(27.43600*$5)/(27.43600+(i-4)),$6}else if(NR>=33){printf "%s %s %8.5f %8.5f %8.5f %8.5f \n",$1,$2,$3,$4,(27.43600*$5+(i-4))/(27.43600+(i-4)),$6}}' ./../graphite_tmp2.cif > graphite_${i}A_coord.cif
	cat graphite_${i}A_coord.cif  >> graphite_${i}A.cif
	rm -f graphite_${i}A_coord.cif
	clen=`echo ${i} | awk '{printf "%f",(27.43600+$1-4.0)}'`
	sed -i "s/C.CCCCC/${clen}/" graphite_${i}A.cif
	sed -i "s/tmpX/${i}/" graphite_${i}A.cif
	cp ./../run ./run
	cp ./../simulation.input_tmp ./simulation.input
	sed -i s/XXXXX/graphite_${i}A/g simulation.input
	sed -i s/XUC/${xuc}/g simulation.input
	sed -i s/YUC/${yuc}/g simulation.input
	sed -i s/ZUC/${zuc}/g simulation.input
	./run
	#
	cd ..
	awk -v file=graphite_${i}A -v xuc=${xuc} -v yuc=${yuc} -v zuc=${zuc} '{if($3=="Widom" && $4=="Rosenbluth-weight:"){printf "%s, %f, %f, %d %d %d\n",file,$5,$7,xuc,yuc,zuc}}' ./graphite_${i}A/Output/System_0/output_graphite_${i}A_${xuc}.${yuc}.${zuc}_*_0.data >> HeliumVoidFraction.txt
	date
done
