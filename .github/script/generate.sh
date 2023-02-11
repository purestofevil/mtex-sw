#!/bin/sh

for type in st la be ent muster schulung; do 
	for json in json/${type}/*.json; do 
		ruby .github/script/chain.rb ${json} > texte/$type/$(echo $json | sed -e 's/^.*\///' -e 's/.json//').md 
	done; 
done
