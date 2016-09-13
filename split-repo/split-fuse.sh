#!/bin/sh

# This script split a repository with fuse, master branch, active
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
TMP_SPLIT_REPO=${TEMPFS_DIR}/tmp-fuse-split
TMP_PUSH_REPO=${TEMPFS_DIR}/tmp-fuse-push
TMP_REPARENT_REPO=${TEMPFS_DIR}/tmp-fuse-reparent
FUSE_REPO=${PHYS_DIR}/fuse.git

# Split prefix and push to branch
split_branch() {
  echo
  echo " * Branch $1"

  git checkout -B $1 origin/$1
  git-subtree.sh split --prefix=fuse -b subtree_$1
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
rm -rf $FUSE_REPO
git init --bare $FUSE_REPO

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
split_branch 2007-08-31-xvideo
split_branch 2008-05-18-console
split_branch 2008-08-28-wii
split_branch 2009-04-11-ntsc
split_branch 2009-07-22-opus
split_branch 2010-08-07-ffmpeg
split_branch 2010-09-14-fmfx
split_branch 2011-02-16-spectranet
split_branch 2011-02-18-memory
split_branch 2011-05-04-memory
split_branch 2014-09-07-ulaplus
split_branch 2014-12-28-sdl2
#split_branch 2016-04-25-didaktik
split_branch 2016-05-17-debugger-dereference
split_branch bug-349-fix-wildcard-events
split_branch bug-353-startup-ordering
split_branch feature-53-zip-support
split_branch feature-80-more-debugger-variables
split_branch feature-100-remote-debugger
split_branch patches-356-threadsafe-libspectrum
split_branch patch-358-recreated-zxspectrum
split_branch patches-377-more-startup-manager
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
graft_merge 3007 3005 3006
filter_branch

# Unmerged branch
git checkout 2007-08-31-xvideo

# Unmerged branch
git checkout 2008-05-18-console

# Reparent inactive branch
git checkout 2008-08-28-wii
graft_merge 3944 3941 3938
filter_branch

# Reparent inactive branch
git checkout 2009-04-11-ntsc
graft_merge 4148 4147 4002
filter_branch

# Reparent inactive branch
git checkout 2009-07-22-opus
graft_merge 4060 4045 4059
filter_branch

# Unmerged branch
git checkout 2010-08-07-ffmpeg

# Reparent inactive branch
git checkout 2010-09-14-fmfx
graft_merge 4664 4663 4662
filter_branch

# Reparent inactive branch
git checkout 2011-02-16-spectranet
graft_merge 4624 4617 4623
filter_branch

# Reparent inactive branch
git checkout 2011-02-18-memory
graft_merge 4415 4413 4414
filter_branch

# Reparent inactive branch (merged into 2011-02-16-spectranet)
git checkout 2011-05-04-memory
graft_merge 4551 4529 4550
filter_branch

# Unmerged branch, reparent sync merges
git checkout 2014-09-07-ulaplus
graft_merge 5341 5340 5338
graft_merge 5609 5344 5606
filter_branch

# Unmerged branch, reparent sync merges
git checkout 2014-12-28-sdl2
graft_merge 5374 5108 5373
filter_branch

# Reparent inactive branch
git checkout 2016-05-17-debugger-dereference
graft_merge 5517 5513 5516
filter_branch

# Reparent inactive branch
git checkout bug-349-fix-wildcard-events
graft_merge 5538 5536 5521
filter_branch

# Reparent inactive branch
git checkout bug-353-startup-ordering
graft_merge 5670 5668 5669
filter_branch

# Reparent inactive branch
git checkout feature-53-zip-support
graft_merge 5718 5706 5717
filter_branch

# Reparent inactive branch
git checkout feature-80-more-debugger-variables
graft_merge 5661 5656 5657
filter_branch

# Unmerged branch, no syncs
git checkout feature-100-remote-debugger

# Unmerged branch, no syncs
git checkout patches-356-threadsafe-libspectrum

# Reparent inactive branch
git checkout patch-358-recreated-zxspectrum
graft_merge 5797 5793 5796
filter_branch

# Unmerged branch, no syncs
git checkout patches-377-more-startup-manager

# Unmerged branch, no syncs
git checkout patches-380-libspectrum_buffer-api

# Push to final repo
git push --all $FUSE_REPO
cd ..
rm -rf $TMP_REPARENT_REPO
rm -rf $TMP_PUSH_REPO

# Prune reflogs
cd $FUSE_REPO
git tag -a conversion-to-git $(git rev-list -n 1 HEAD) \
    -m 'Marks the spot at which this repository was converted from Subversion to Git.'
git reflog expire --expire=now --all && git gc --prune=now --aggressive
cd ..
