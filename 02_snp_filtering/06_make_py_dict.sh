#!/bin/bash
#while IFS='' read -r line || [[ -n "$line" ]]; do
#    echo "Text read from file: $line"
#done < "$1" "$2"

file1=$1
file2=$2

paste $file1 $file2 | while IFS="$(printf '\t')" read -r f1 f2
do
  echo "'$f1': $f2,"
done
