#!/bin/sh

SOURCE_REPO=../fuse-emulator-git/

split_init() {
  echo "* Create temporary repository"
  git clone $SOURCE_REPO --no-hardlinks -- tmp
}

split_repo() {
  test -n "$1" || exit 1
  echo
  echo "* Repository $1"

  # create final repository
  rm -rf $1
  mkdir $1
  cd $1/
  git init --bare
  cd ..

  # create filtered branch and push to repository
  cd tmp/
  git subtree split -P $1 -b _$1
  git push ../$1 _$1:master
  cd ..
}

split_end() {
  # clean files
  rm -rf tmp
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
