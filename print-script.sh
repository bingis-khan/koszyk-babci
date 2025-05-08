#!/bin/sh

for MODEL in $(cat koszyk.scad | grep BOB_SCAD_PRINT | cut -d' ' -f3-); do
  openscad -D "print=true;${MODEL}()" -o "stl/${MODEL}.stl" koszyk.scad
done
