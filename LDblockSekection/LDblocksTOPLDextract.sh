#!/bin/bash

#Script para extraer bloques de desequilibrio de ligamiento con la API de TopLD
#Si la API no esta descargada usar: git clone https://github.com/linnabrown/topld_api.git
#El primer argumento es una lista con un META analisis. Requisitos: columna que se llama SNP con los rsID y columna con la P de cada SNP.
#El segundo argumento es el thershold de significancia de la P en -log10.

mkdir ${1}_results

cd ${1}_results

cp ../${1} .
cp ../topld_api/*.txt .
cp ../topld_api/topld_api .

Rscript ../select99SNPs.R ${1} ${2}

ls META_SSc_noHLA_CHRBPA2_1e5_99block_* > list_blocks.list
for fi in $(cat list_blocks.list); do
	echo inicio
	./topld_api -thres 0.8 -pop EUR -maf 0.01 -inFile ${fi} -outputLD output_${fi} -outputInfo outputInfo_${fi}
	echo fin ${fi}
done

echo juntamos todos los archivos

cat output_* > output_${1}_allLDblocks.txt
cat outputInfo_* > META_SSc_noHLA_CHRBPA2_1e5_allLDblocks_info.txt

echo eliminamos archivos intermedios

rm output_META_SSc_noHLA_CHRBPA2_1e5_99block_*
rm outputInfo_META_SSc_noHLA_CHRBPA2_1e5_99block_*
rm META_SSc_noHLA_CHRBPA2_1e5_99block_*
rm list_blocks.list

echo fin
