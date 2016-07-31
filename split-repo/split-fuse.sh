#!/bin/sh

# This script split a repository with fuse, master branch, active
# branches and no tags
#
# Requires modified git-subtree.sh

SOURCE_REPO=../fuse-emulator-git/
TMP_REPO=tmp-fuse
FUSE_REPO=fuse

split_branch() {
  echo
  echo " * Branch $1"

  git checkout -B subtree_$1 origin/$1
  ../../bin/git-subtree.sh split --prefix=fuse -b subtree_fuse_$1
  git push ../$FUSE_REPO subtree_fuse_$1:$1
}

if test ! -x "../bin/git-subtree.sh"; then
  echo "error: missing ../bin/git-subtree.sh"
  exit 1
fi

# Create final repository
rm -rf $FUSE_REPO
git init --bare $FUSE_REPO

# Clone to temporary repository
rm -rf $TMP_REPO
git clone $SOURCE_REPO --no-hardlinks -- $TMP_REPO

# Split and push active branches
cd $TMP_REPO
split_branch master
split_branch 2014-09-07-ulaplus
split_branch 2014-12-28-sdl2
split_branch 2016-04-25-didaktik
split_branch patches-356-threadsafe-libspectrum
#split_branch feature-53-zip-support
cd ..
rm -rf $TMP_REPO

# Prune reflogs
cd $FUSE_REPO
git tag -a conversion-to-git $(git rev-list -n 1 HEAD) \
    -m 'Marks the spot at which this repository was converted from Subversion to Git.'
git reflog expire --expire=now --all && git gc --prune=now --aggressive
cd ..
