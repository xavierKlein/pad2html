#!/bin/bash

YPOS1=180

for PART1 in part1*
do

YPOS1=`expr $YPOS1 + 20`
sed  -i "s/^object-top:.*$/object-top:${YPOS1}px/g" $PART1

done

YPOS2=`expr $YPOS1 + 15`

for PART2 in part2*
do

YPOS2=`expr $YPOS2 + 20`
sed  -i "s/^object-top:.*$/object-top:${YPOS2}px/g" $PART2

done

YPOS3=`expr $YPOS2 + 15`


for PART3 in part3*
do

YPOS3=`expr $YPOS3 + 20`
sed  -i "s/^object-top:.*$/object-top:${YPOS3}px/g" $PART3

done

YPOS4=`expr $YPOS3 + 15`


for PART4 in part4*
do

YPOS4=`expr $YPOS4 + 20`
sed  -i "s/^object-top:.*$/object-top:${YPOS4}px/g" $PART4

done
