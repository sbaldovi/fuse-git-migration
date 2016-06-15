#!/bin/bash

# Replace ticket numbers in a file with commit messages of subversion repository

if test -z "$1" || test -z "$2"; then
  echo "usage: tickets_replace.sh <old mailbox> <new mailbox>"
  exit 1
fi

touch $2

rm tickets_map.sed
touch tickets_map.sed

while read -r artifact ticket; do
    echo "s/$artifact/$ticket/g" >> tickets_map.sed
done < tickets_map.txt

sed -f tickets_map.sed < $1 > $2
