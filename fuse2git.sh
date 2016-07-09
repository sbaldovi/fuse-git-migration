#!/bin/sh

# Convert to Git
make 2>&1 | tee fuse-emulator.log || exit 1
# stdbuf -o 0 make 2>&1 | tee fuse-emulator.log || exit 1

# Tag svn conversion at r2858: 2007-05-19T16:19:04Z!philip-fuse@shadowmagic.org.uk
cd fuse-emulator-git
git tag -a conversion-to-svn \
    $(git log --grep '^Legacy-ID: 2858$' --abbrev-commit | head -n 1 | cut -d ' ' -f 2) \
    -m 'Marks the spot at which this repository was converted from CVS to Subversion.'
cd ..

# Run a garbage-collect on the generated git repository
make gc
