#!/bin/sh

# This script split a directory on master to a new repository, without
# branches or tags.

SOURCE_REPO=../fuse-emulator-git/
TMP_REPO=tmp-subtree

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
  rm -rf $1
  git init --bare $1

  # Push to repository
  cd $TMP_REPO/
  git subtree push --prefix=$1 ../$1 master
  cd ..

  # Prune reflogs
  cd $1/
  git reflog expire --expire=now --all && git gc --prune=now --aggressive
  cd ..
}

split_end() {
  # clean files
  rm -rf $TMP_REPO
}

split_init

split_repo debian
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
