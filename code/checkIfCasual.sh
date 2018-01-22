#!/bin/bash

for dir in */
do
  cd $dir
  for subdir in */
  do
    cd $subdir
    while read line
    do
      git shortlog -s HEAD --author=$(git show -s --format="%aE" $line) > file.txt
      num_lines=$(wc -l < file.txt)
      if [ $num_lines = "1" ] ;
      then
        git_output=$(cat file.txt)
        commits="${git_output##*( )}"
        commits=( $commits )
        if [ "${commits[0]}" = "1" ] ;
        then
          echo "$line" >> ../${subdir%/}_sha_filtered.txt
        fi
      fi
    done < ${subdir%/}_sha.txt
    cd ..
  done
  cd ..
done
