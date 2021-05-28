#! /bin/bash
cd ~/Desktop/dataset
read -d "#THEEND!" vecs
read -d "#THEEND!" population
read -d "#THEEND!" extra
individuals=`echo -e "$vecs" | awk '{print(substr($0,9))}'`
new_pop=`echo -e "$individuals\n$population\n$extra" | awk 'NF>2{a[$1];next}$1 in a{print $0}'`
first=`echo -e "$new_pop" | awk '{print(substr($0,9,3))}'`
second=`echo -e "$individuals" | awk '{print(substr($0,9))}'`
third=`echo -e "$new_pop" | awk '{print(substr($0,0,7))}'`
read -d "$EOF" -ra array_first <<< $first
IFS=$'\n' read -d "$EOF" -ra array_sec <<< $second
read -d "$EOF" -ra array_third <<< $third
n=${#array_third[@]}
for ((i=0;i<$n;i++))
	{
		printf "${array_first[i]} ${array_sec[i]} ${array_third[i]}\n" >> pca.txt
	}

R CMD BATCH pca_visualization.r
