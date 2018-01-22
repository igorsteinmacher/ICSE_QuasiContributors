#!/bin/bash

for dir in */
do
  cd $dir
  for subdir in */
  do
    cd $subdir
    touch ${subdir%/}_sha.txt
    cd ..
  done
  cd ..
done
