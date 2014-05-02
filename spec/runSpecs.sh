#!/bin/bash

for dir in $(ls .) 
do
	if [ -d "$dir" ]
	then
		cd $dir;
		rspec -fd -c *_spec.rb ;
		cd ..;
	fi
done
