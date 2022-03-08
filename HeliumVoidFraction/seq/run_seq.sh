#!/bin/bash

# UnitCellsi
xuc=1; yuc=1; zuc=1

folder_name=( COF-1
 Cd3BTB2 
 Co-DOBDC CoBDP-Dubbeldam CoBDP Cu-BTC
 IRMOF-1 IRMOF-10 IRMOF-16 MAF-X8
 MIL-100-primitive MIL-47 
 MOF-177 MOF-210
 Mg-DOBDC MgMOF-74 
 NU-100SP-primitive Ni-DOBDC
 PCN-60 UIO-66 UMCM-1
 ZIF-8 ZIF-90
 ZnBDC ZnBDCdabco ZnMOF-74
 Zr-TPDC

chmod +x run)

if [ ! -e HeliumVoidFraction.txt ]; then
	echo "# Name, Value, Error(+/-): UnitCellsi ${xuc} ${yuc} ${zuc}" > HeliumVoidFraction.txt
fi

for folder in "${folder_name[@]}"; do
	echo "folder name: "${folder}
	date
	if [ ! -e ${folder} ]; then	
		mkdir ${folder}
	fi
	cd ${folder}
	cp ./../run ./run
	cp ./../simulation.input_tmp ./simulation.input
	sed -i s/XXXXX/${folder}/g simulation.input
	sed -i s/XUC/${xuc}/g simulation.input
	sed -i s/YUC/${yuc}/g simulation.input
	sed -i s/ZUC/${zuc}/g simulation.input
	./run
	cd ..
	awk -v file=${folder} '{if($3=="Widom" && $4=="Rosenbluth-weight:"){printf "%s, %f, %f\n",file,$5,$7}}' ./${folder}/Output/System_0/output_${folder}_${xuc}.${yuc}.${zuc}_*_0.data >> HeliumVoidFraction.txt
	date
done
