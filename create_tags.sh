#!/bin/sh

cd fuse-emulator-git

# The cvs2svn migration created some manufactured commits on tags to
# clean-up the tree of files from mirror files.  These mirror files
# have been removed in the svn2git migration and the empty commits have
# been removed too.  The next commands create lightweight tags to keep
# the references.

# r22 - This commit was manufactured by cvs2svn to create tag 'Release-0_3_1'.
git tag Release-0_3_1 $(git log --grep '^Legacy-ID: 21$' | head -n 1 | cut -d ' ' -f 2)
# r41 - This commit was manufactured by cvs2svn to create tag 'Release-0_3_2pre1'.
git tag Release-0_3_2pre1 $(git log --grep '^Legacy-ID: 40$' | head -n 1 | cut -d ' ' -f 2)
# r65 - This commit was manufactured by cvs2svn to create tag 'Release-0_3_2pre2'.
git tag Release-0_3_2pre2 $(git log --grep '^Legacy-ID: 64$' | head -n 1 | cut -d ' ' -f 2)
# r84 - This commit was manufactured by cvs2svn to create tag 'Release-0_3_2pre3'.
git tag Release-0_3_2pre3 $(git log --grep '^Legacy-ID: 83$' | head -n 1 | cut -d ' ' -f 2)
# r88 - This commit was manufactured by cvs2svn to create tag 'Release-0_3_2'.
git tag Release-0_3_2 $(git log --grep '^Legacy-ID: 87$' | head -n 1 | cut -d ' ' -f 2)
# r91 - This commit was manufactured by cvs2svn to create tag 'Release-0_3_2_1'.
git tag Release-0_3_2_1 $(git log --grep '^Legacy-ID: 90$' | head -n 1 | cut -d ' ' -f 2)
# r117 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_0pre1'.
git tag Release-0_4_0pre1 $(git log --grep '^Legacy-ID: 116$' | head -n 1 | cut -d ' ' -f 2)
# r139 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_0pre2'.
git tag Release-0_4_0pre2 $(git log --grep '^Legacy-ID: 138$' | head -n 1 | cut -d ' ' -f 2)
# r152 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_0pre3'.
git tag Release-0_4_0pre3 $(git log --grep '^Legacy-ID: 151$' | head -n 1 | cut -d ' ' -f 2)
# r164 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_0pre4'.
git tag Release-0_4_0pre4 $(git log --grep '^Legacy-ID: 163$' | head -n 1 | cut -d ' ' -f 2)
# r181 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_0pre5'.
git tag Release-0_4_0pre5 $(git log --grep '^Legacy-ID: 180$' | head -n 1 | cut -d ' ' -f 2)
# r201 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_0pre6'.
git tag Release-0_4_0pre6 $(git log --grep '^Legacy-ID: 200$' | head -n 1 | cut -d ' ' -f 2)
# r239 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_1pre1'.
git tag Release-0_4_1pre1 $(git log --grep '^Legacy-ID: 238$' | head -n 1 | cut -d ' ' -f 2)
# r262 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_1pre2'.
git tag Release-0_4_1pre2 $(git log --grep '^Legacy-ID: 261$' | head -n 1 | cut -d ' ' -f 2)
# r291 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_1pre3'.
git tag Release-0_4_1pre3 $(git log --grep '^Legacy-ID: 290$' | head -n 1 | cut -d ' ' -f 2)
# r324 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_1pre4'.
git tag Release-0_4_1pre4 $(git log --grep '^Legacy-ID: 323$' | head -n 1 | cut -d ' ' -f 2)
# r330 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_1'.
git tag Release-0_4_1 $(git log --grep '^Legacy-ID: 329$' | head -n 1 | cut -d ' ' -f 2)
# r343 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_2pre1'.
git tag Release-0_4_2pre1 $(git log --grep '^Legacy-ID: 342$' | head -n 1 | cut -d ' ' -f 2)
# r363 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_2pre2'.
git tag Release-0_4_2pre2 $(git log --grep '^Legacy-ID: 362$' | head -n 1 | cut -d ' ' -f 2)
# r399 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_2pre3'.
git tag Release-0_4_2pre3 $(git log --grep '^Legacy-ID: 398$' | head -n 1 | cut -d ' ' -f 2)
# r428 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_2pre4'.
git tag Release-0_4_2pre4 $(git log --grep '^Legacy-ID: 427$' | head -n 1 | cut -d ' ' -f 2)
# r439 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_2'.
git tag Release-0_4_2 $(git log --grep '^Legacy-ID: 438$' | head -n 1 | cut -d ' ' -f 2)
# r444 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_2-merge-1'.
git tag Release-0_4_2-merge-1 $(git log --grep '^Legacy-ID: 443$' | head -n 1 | cut -d ' ' -f 2)
# r452 - This commit was manufactured by cvs2svn to create tag 'Release-0_4_2-merge-2'.
git tag Release-0_4_2-merge-2 $(git log --grep '^Legacy-ID: 451$' | head -n 1 | cut -d ' ' -f 2)
# r478 - This commit was manufactured by cvs2svn to create tag 'Release-0_5_0pre1'.
git tag Release-0_5_0pre1 $(git log --grep '^Legacy-ID: 477$' | head -n 1 | cut -d ' ' -f 2)
# r492 - This commit was manufactured by cvs2svn to create tag 'Release-0_5_0pre1-merge-1'.
git tag Release-0_5_0pre1-merge-1 $(git log --grep '^Legacy-ID: 491$' | head -n 1 | cut -d ' ' -f 2)
# r545 - This commit was manufactured by cvs2svn to create tag 'Release-0_5_0pre2'.
git tag Release-0_5_0pre2 $(git log --grep '^Legacy-ID: 544$' | head -n 1 | cut -d ' ' -f 2)
# r560 - This commit was manufactured by cvs2svn to create tag 'libspectrum_start'.
git tag libspectrum_start $(git log --grep '^Legacy-ID: 569$' | head -n 1 | cut -d ' ' -f 2)
# r568 - This commit was manufactured by cvs2svn to create tag 'Release-0_5_0-trunk'.
git tag Release-0_5_0-trunk $(git log --grep '^Legacy-ID: 566$' | head -n 1 | cut -d ' ' -f 2)
# r1496 - This commit was manufactured by cvs2svn to create tag 'libspectrum_0_1_0-pre1-crypto-branch-1'.
git tag libspectrum_0_1_0-pre1-crypto-branch-1 $(git log --grep '^Legacy-ID: 1495$' | head -n 1 | cut -d ' ' -f 2)
# r1540 - This commit was manufactured by cvs2svn to create tag 'libspectrum_0_1_0-pre1-crypto-branch-2'.
git tag libspectrum_0_1_0-pre1-crypto-branch-2 $(git log --grep '^Legacy-ID: 1539$' | head -n 1 | cut -d ' ' -f 2)

# r4988 - branch /branches/Release-1_1_0 accidentally created in r4987, moved to /tags/Release-1_1_0 in r4988, but the actual tarball was r4955.
git tag Release-1_1_0 $(git log --grep '^Legacy-ID: 4955$' | head -n 1 | cut -d ' ' -f 2)

# Tag svn conversion at r2858: 2007-05-19T16:19:04Z!philip-fuse@shadowmagic.org.uk
git tag -a conversion-to-svn \
    $(git log --grep '^Legacy-ID: 2858$' | head -n 1 | cut -d ' ' -f 2) \
    -m 'Marks the spot at which this repository was converted from CVS to Subversion.'

cd ..
