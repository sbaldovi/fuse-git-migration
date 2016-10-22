#!/bin/sh

# This script split a directory on master to a new repository, without
# branches or tags.
#
# Requires modified git-subtree.sh

set -e

# Force the use of custom git-subtree
PHYS_DIR=$(pwd -P)
PATH="$PHYS_DIR/../bin:$PATH"

SOURCE_REPO=../fuse-emulator-git/
TEMPFS_DIR=${PHYS_DIR}
# Recommended a tmpfs mount of 1 Gb to reduce disk IO
#TEMPFS_DIR="/mnt/ramdisk"
TMP_REPO=${TEMPFS_DIR}/tmp-subtree

split_init() {
  echo "* Create temporary repository"
  rm -rf $TMP_REPO
  git clone $SOURCE_REPO --no-hardlinks -- $TMP_REPO
}

# Push a directory to a new repository
# $1: subtree path and repository name
split_repo() {
  test -n "$1" || exit 1
  echo
  echo "* Repository $1"

  # create final repository
  rm -rf $1.git
  git init --bare ${PHYS_DIR}/$1.git

  # Split prefix and push to repository
  cd $TMP_REPO/
  git-subtree.sh split --prefix=$1 -b subtree_$1
  git push ${PHYS_DIR}/$1.git subtree_$1:master

  cd ..

  # Prune reflogs
  cd ${PHYS_DIR}/$1.git/
  git reflog expire --expire=now --all && git gc --prune=now --aggressive
  cd ..
}

split_end() {
  # clean files
  rm -rf $TMP_REPO
}

if test ! -d "$SOURCE_REPO"; then
  echo "error: missing $SOURCE_REPO"
  exit 1
fi

if test ! -x "../bin/git-subtree.sh"; then
  echo "error: missing ../bin/git-subtree.sh"
  exit 1
fi

split_init

# split_repo debian
# split_repo fuse
split_repo fuse-basic
split_repo fuse-mgt
split_repo fusetest
# split_repo fuse-utils
split_repo gdos-tools
split_repo libgdos
# split_repo libspectrum
split_repo website

split_end
