#!/bin/sh

# This script split a repository with libspectrum, master branch, active
# branches and no tags
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
TMP_SPLIT_REPO=${TEMPFS_DIR}/tmp-libspectrum-split
TMP_PUSH_REPO=${TEMPFS_DIR}/tmp-libspectrum-push
TMP_REPARENT_REPO=${TEMPFS_DIR}/tmp-libspectrum-reparent
LIBSPECTRUM_REPO=${PHYS_DIR}/libspectrum.git

# Split prefix and push to branch
split_branch() {
  echo
  echo " * Branch $1"

  git checkout -B $1 origin/$1
  git-subtree.sh split --prefix=libspectrum -b subtree_$1
  git push $TMP_PUSH_REPO subtree_$1:$1
}

# Change parents based on svn revisions
graft_merge()
{
  merge_hash=$(git log --all --grep '^Legacy-ID: '$1'$' | head -n 1 | cut -d ' ' -f 2)
  parent1_hash=$(git log --all --grep '^Legacy-ID: '$2'$' | head -n 1 | cut -d ' ' -f 2)
  parent2_hash=$(git log --all --grep '^Legacy-ID: '$3'$' | head -n 1 | cut -d ' ' -f 2)
  echo "$merge_hash $parent1_hash $parent2_hash" >> .git/info/grafts
}

# Make grafts permanent
filter_branch()
{
  branch=$(git rev-parse --abbrev-ref HEAD)
  echo
  echo " * Filter branch $branch"

  git filter-branch -- --all
  rm .git/info/grafts
  git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d
}

if test ! -d "$SOURCE_REPO"; then
  echo "error: missing $SOURCE_REPO"
  exit 1
fi

if test ! -x "../bin/git-subtree.sh"; then
  echo "error: missing ../bin/git-subtree.sh"
  exit 1
fi

# Create final repository
rm -rf $LIBSPECTRUM_REPO
git init --bare $LIBSPECTRUM_REPO

# Clone to temporary repository
rm -rf $TMP_SPLIT_REPO
git clone $SOURCE_REPO --no-hardlinks -- $TMP_SPLIT_REPO

# Create temporary repository
rm -rf $TMP_PUSH_REPO
git init --bare $TMP_PUSH_REPO

# Split and push branches
cd $TMP_SPLIT_REPO
split_branch master
split_branch 2007-06-09-plusd
split_branch 2008-05-18-console
split_branch 2008-08-28-wii
split_branch 2009-04-11-ntsc
split_branch 2009-07-22-opus
split_branch 2011-02-16-spectranet
#split_branch 2011-02-18-memory
#split_branch 2011-05-04-memory
split_branch 2014-09-07-ulaplus
#split_branch 2014-12-28-sdl2
#split_branch 2016-04-25-didaktik
split_branch bug-353-startup-ordering
split_branch feature-53-zip-support
#split_branch feature-100-remote-debugger
split_branch patches-356-threadsafe-libspectrum
#split_branch patch-358-recreated-zxspectrum
#split_branch patches-377-more-startup-manager
split_branch patches-380-libspectrum_buffer-api
cd ..
rm -rf $TMP_SPLIT_REPO

# Clone to temporary repository
rm -rf $TMP_REPARENT_REPO
git clone $TMP_PUSH_REPO --no-hardlinks -- $TMP_REPARENT_REPO

# Make branches local
cd $TMP_REPARENT_REPO

# Reparent inactive branch
git checkout 2007-06-09-plusd
graft_merge 3007 2953 2992
filter_branch

# Reparent inactive branch
git checkout 2008-08-28-wii
graft_merge 3947 3921 3926
filter_branch

# Reparent inactive branch
git checkout 2009-04-11-ntsc
graft_merge 4148 4140 4009
filter_branch

# Reparent inactive branch
git checkout 2009-07-22-opus
graft_merge 4060 4039 4055
filter_branch

# Reparent inactive branch
git checkout 2011-02-16-spectranet
graft_merge 4624 4548 4551
filter_branch

# Reparent active branch
git checkout 2014-09-07-ulaplus
graft_merge 5341 5323 5316
graft_merge 5609 5345 5603
filter_branch

# Reparent inactive branch
git checkout bug-353-startup-ordering
graft_merge 5670 5649 5669
filter_branch

# Reparent inactive branch
git checkout feature-53-zip-support
graft_merge 5718 5697 5716
filter_branch

# Unmerged branch, no syncs
git checkout 2008-05-18-console

# Unmerged branch, no syncs
git checkout patches-356-threadsafe-libspectrum

# Unmerged branch, no syncs
git checkout patches-380-libspectrum_buffer-api

# Push to final repo
git push --all $LIBSPECTRUM_REPO
cd ..
rm -rf $TMP_REPARENT_REPO
rm -rf $TMP_PUSH_REPO

# Prune reflogs
cd $LIBSPECTRUM_REPO
git tag -a conversion-to-git $(git rev-list -n 1 HEAD) \
    -m 'Marks the spot at which this repository was converted from Subversion to Git.'
git reflog expire --expire=now --all && git gc --prune=now --aggressive
cd ..
