#!/bin/bash
for j in ../Training/* ; do
    for i in $j/*.txt ; do
        echo "**** Result for $i ***"
        ./validate.py -a $j/REFERENCE.csv -p $i
    done
done
