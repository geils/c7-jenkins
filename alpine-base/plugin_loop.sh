#!/bin/bash

while read line
do
    /usr/local/bin/install-plugins.sh $line
done < $1
