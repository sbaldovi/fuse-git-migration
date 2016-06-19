This repository contains the (EXPERIMENTAL) script files to migrate
Fuse - the Free Unix Spectrum Emulator ([1]) from Subversion to Git.

It is needed Reposurgeon ([2]) for the migration, currently at version 3.29.

The script `fuse2git.sh' runs the migration. The genaral process is:
  1) `make' for converting the repository.
  2) `make gc' to repack the repository before submitting to a server.

The file tickets_map.txt contains a map for translating tickets numbers from
the old bug tracking system to the new one (Allura). It has been build by:

    svn log | grep -o -E "#[0-9][0-9][0-9][0-9]+" | sort | uniq | \
        xargs -I{} ticket2allura.sh {} >> tickets_map.txt

but some misspelled tickets have been fixed with info from the mailing lists. 

The file fuse-emulator.map contains the committers map.

The file fuse-emulator.lift has commands used by reposurgeon to tidy up
the repository.

The file fuse-emulator-stage3.lift has commands used by reposurgeon to change
author attribute.

[1] http://fuse-emulator.sourceforge.net/
[2] http://www.catb.org/~esr/reposurgeon/
