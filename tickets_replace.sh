#!/bin/bash

# Replace ticket numbers in a file with commit messages of subversion repository

if test -z "$1" || test -z "$2"; then
  echo "usage: tickets_replace.sh <old mailbox> <new mailbox>"
  exit 1
fi

touch $2

while read -r artifact ticket; do
    sed_opts+="s/$artifact/$ticket/g;"
done < tickets_map.txt

sed -e "$sed_opts" < $1 > $2
