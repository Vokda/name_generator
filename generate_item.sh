#!/bin/sh
noun=$(shuf nouns.txt -n 1)
adjective=$(shuf adjectives.txt -n 1)
if [ -z ${1} ]
then
	length=7
else
	length=$1
fi

name=$(./generate_name.pl $length 0)
echo "$name's $adjective $noun"
