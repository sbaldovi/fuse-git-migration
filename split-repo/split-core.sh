#!/bin/sh

# This script split a repository with fuse, fuse-utils and libspectrum, with
# branches or tags.
#
# Requires BFG Repo-Cleaner

SOURCE_REPO=../fuse-emulator-git/
TMP_REPO=tmp-bfg
FINAL_REPO=fuse-emulator-core

if test ! -f "../bin/bfg-1.12.12.jar"; then
  echo "error: missing ../bin/bfg-1.12.12.jar"
  exit 1
fi

# Clone to temporary repository
rm -rf $TMP_REPO
git clone $SOURCE_REPO --mirror --no-hardlinks -- $TMP_REPO

# Remove directories
java -jar ../bin/bfg-1.12.12.jar --delete-folders {debian,fuse-basic,fuse-mgt,fusetest,gdos-tools,libgdos,website} --no-blob-protection $TMP_REPO

cd $TMP_REPO

# Prune empty commits
git filter-branch --prune-empty --tag-name-filter cat -- --all

# Discard original branches from before running the filter
#git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin

cd ..

# Create final repository
rm -rf $FINAL_REPO
git init --bare $FINAL_REPO

# Push to final repository
cd $TMP_REPO/
git push ../$FINAL_REPO --force --all
git push ../$FINAL_REPO --force --tags
cd ..
rm -rf $TMP_REPO

# Prune reflogs
cd $FINAL_REPO/
git reflog expire --expire=now --all && git gc --prune=now --aggressive
cd ..
