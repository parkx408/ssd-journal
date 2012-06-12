#!/bin/bash

for run in `ls run`
do
	echo "postmark run/$run > out/$run.out";
	postmark run/$run > out/$run.out
	echo "DONE!!";
	wait;
done
