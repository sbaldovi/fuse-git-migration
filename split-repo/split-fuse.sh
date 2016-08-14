#!/bin/sh

# This script split a repository with fuse, master branch, active
# branches and no tags
#
# Requires modified git-subtree.sh

SOURCE_REPO=../fuse-emulator-git/
TMP_SPLIT_REPO=tmp-fuse-split
TMP_PUSH_REPO=tmp-fuse-push
TMP_REPARENT_REPO=tmp-fuse-reparent
FUSE_REPO=fuse.git

# Split prefix and push to branch
split_branch() {
  echo
  echo " * Branch $1"

  git checkout -B $1 origin/$1
  ../../bin/git-subtree.sh split --prefix=fuse -b subtree_$1
  git push ../$TMP_PUSH_REPO subtree_$1:$1
}

# Change parents based on svn revisions
graft_merge()
{
  merge_hash=$(git log --all --grep '^Legacy-ID: '$1'$' | head -n 1 | cut -d ' ' -f 2)
  parent1_hash=$(git log --all --grep '^Legacy-ID: '$2'$' | head -n 1 | cut -d ' ' -f 2)
  parent2_hash=$(git log --all --grep '^Legacy-ID: '$3'$' | head -n 1 | cut -d ' ' -f 2)
  echo "$merge_hash $parent1_hash $parent2_hash" >> .git/info/grafts
  git update-server-info
}

# Make grafts permanent
filter_branch()
{
  branch=$(git rev-parse --abbrev-ref HEAD)
  merge_base=$(git merge-base $branch master)
  echo "git filter-branch -- $merge_base..HEAD"
  git filter-branch -- $merge_base..HEAD

  rm .git/info/grafts
  git update-server-info
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

# Split and push active branches
cd $TMP_SPLIT_REPO
split_branch master
split_branch 2014-09-07-ulaplus
split_branch 2014-12-28-sdl2
#split_branch 2016-04-25-didaktik
split_branch feature-100-remote-debugger
split_branch patches-356-threadsafe-libspectrum
split_branch patches-377-more-startup-manager
cd ..
rm -rf $TMP_SPLIT_REPO

# Clone to temporary repository
rm -rf $TMP_REPARENT_REPO
git clone $TMP_PUSH_REPO --no-hardlinks -- $TMP_REPARENT_REPO

# Make branches local
cd $TMP_REPARENT_REPO
git checkout 2014-09-07-ulaplus
git checkout 2014-12-28-sdl2
#git checkout 2016-04-25-didaktik
git checkout feature-53-zip-support
git checkout feature-100-remote-debugger
git checkout patches-356-threadsafe-libspectrum
git checkout patches-377-more-startup-manager
git remote remove origin

# Reparent sync merges (trunk->branch)
git checkout 2014-09-07-ulaplus
graft_merge 5341 5340 5338
graft_merge 5609 5344 5606
filter_branch

# Reparent sync merges (trunk->branch)
git checkout 2014-12-28-sdl2
graft_merge 5374 5108 5373
filter_branch

# Push to final repo
git push --all ../$FUSE_REPO
cd ..
rm -rf $TMP_REPARENT_REPO
rm -rf $TMP_PUSH_REPO

# Prune reflogs
cd $FUSE_REPO
git tag -a conversion-to-git $(git rev-list -n 1 HEAD) \
    -m 'Marks the spot at which this repository was converted from Subversion to Git.'
git reflog expire --expire=now --all && git gc --prune=now --aggressive
cd ..
