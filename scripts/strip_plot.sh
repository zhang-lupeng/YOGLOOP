#!/usr/bin/bash
#Description: Count the contacts with slide window.
#Usage:sh strip_plot.sh A01 100000 101000
#Author: zhanglp
#Date: 20240624

chr=$1
anchor_start=$2
anchor_end=$3
anchor=$4
input=${5}/${chr}.bedpe

let mid=($anchor_start+$anchor_end)/2
let start=$mid-10000
let end=$mid+10000
bin_size=100
awk -v start=$start -v end=$end '{if($2>start&&$5<end)print $1,$2,$3,$4,$5,$6,$7}' $input > tmp/${anchor}_raw.txt
awk -v bin=$bin_size -v start=$start -v end=$end -v chr=$chr 'BEGIN{OFS="\t";for(i=start;i<end;i+=bin)print chr,i,i+bin,int((i-start)/bin)+1}' > tmp/${anchor}_abs.bed
awk -v bin=$bin_size -v start=$start 'BEGIN{OFS="\t"}{print int(($2-start)/bin)+1,int(($5-start)/bin)+1}' tmp/${anchor}_raw.txt | awk '{dic[$1][$2]++}END{for(i in dic)for(j in dic[i])print i,j,dic[i][j]}' | awk 'BEGIN{OFS="\t"}$1<=$2{print $1,$2,$3}' > tmp/${anchor}_long.txt
awk 'BEGIN{for(i=1;i<=200;i++){for(j=1;j<=200;j++)dic[i][j]=0}}{dic[$1][$2]=$3}END{for(i in dic){for(j in dic[i])print i,j,dic[i][j]}}' tmp/${anchor}_long.txt | sort -k 1,1n -k 2,2n | awk 'BEGIN{OFS="\t"}{print $1,$2,$3}' > tmp/${anchor}_full.txt
#hicConvertFormat -m ${anchor}_full.txt --bedFileHicpro ${anchor}_abs.bed --inputFormat hicpro --outputFormat h5 -o ${anchor}_matrix.h5
#hicPlotMatrix -m ${anchor}_matrix.h5 -o ${anchor}_matrix.png
rm tmp/${anchor}_raw.txt tmp/${anchor}_abs.bed tmp/${anchor}_long.txt


