#!/bin/sh

cd 
cd txt/mtex

git status
git pull
git add bausteine/\*\*.md
git commit -m 'Updating Bausteine'
git add json/\*\*.json
git commit -m 'Updating JSON-Files'
git add release_notes/\*/body.md
git add release_notes/\*/issue_*.md
git add release_notes/\*/\*.json
git commit -m 'Updating Documentation'