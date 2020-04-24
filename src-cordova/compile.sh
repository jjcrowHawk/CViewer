#!/bin/bash

cd ..
quasar build -m $1
cd src-cordova
if [[ $1 = 'ios' ]];
then
 cordova prepare $1
fi
if [[ $2 = 'build' ]];
then
 cordova build $1
else
 cordova run $1
fi
