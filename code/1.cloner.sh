#!/bin/bash
while IFS= read -r line
do
   IFS=', ' read -r -a array <<< "$line"
   git clone http://github.com/${array[0]}/${array[1]}
done <repos.txt
