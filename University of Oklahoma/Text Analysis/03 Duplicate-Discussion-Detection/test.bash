#!/bin/bash

# Source: http://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell
allComments=$(<discussions.thorn)

declare -a comment=('')
declare -a result=('')

let i=0
while IFS=$'þ' read -d$'þ' -r comm; 
do 
    comment[$i]=$comm;
    let i=i+1;
done  <<< "$allComments"

#comment=("${comment[@]/$'\276'/}")
comment=("${comment[@]/'.'/}")
comment=("${comment[@]/','/}")
comment=("${comment[@]/';'/}")
comment=("${comment[@]/'?'/}")



echo -n "Calculation is in process "
let n=${#comment[@]}
let k=0
let m=n*n/20
for i in $(seq 0  $n)
do
    let ii=i+1
    for j in $(seq $ii $n)
    do
	inter=$((sort <(echo ${comment[$i]} | tr " " $"\n" ) <(echo ${comment[$j]} | tr " " $"\n" )) | uniq -d | wc -l)
	union=$((sort <(echo ${comment[$i]} | tr " " $"\n" ) <(echo ${comment[$j]} | tr " " $"\n" )) | uniq | wc -l)
	similarity=$(bc -l <<< "scale=4; $inter/$union")
	result[$k]=$(echo "$i $j $similarity;")
	let k=k+1
	if [ `expr $k % $m` == 0 ]; then echo -n "."; fi
    done 
done
echo "/"
sort -nrk3 <(echo ${result[@]} | tr ";" $"\n") | head -n10
