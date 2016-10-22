# fuse-git-migration
This repository contains the script files to migrate [Fuse - the Free Unix Spectrum Emulator](http://fuse-emulator.sourceforge.net/) from Subversion to Git.

# Overview

Run ./fuse2git.sh to start the migration.

The general process has these steps:

1. Use [Reposurgeon](http://www.catb.org/~esr/reposurgeon/) to create a global git repository with fixed history over svn.
2. Use *git-subtree* and *git-filter-branch* to extract individual repositories of different programs that coexist in the same subversion repository.

The expected output is:

* fuse-emulator-git/: global git repository.
* split-repo/{repo}.git/: individual repositories.
* fuse-emulator.log: verbose output of the migration.

# Contents

The main files that parameterise the migration are:

* fuse-emulator.map: info about contributors with commit rights.
* fuse-emulator.lift: commands for cleaning the commit messages and the CVS history.
* fuse-emulator-stage3.lift: commands to change author attribution in commits.
* tickets_map.txt: map for translating tickets numbers from the old bug tracking system (Trac) to the new one (Allura).
