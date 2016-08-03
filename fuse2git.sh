#!/bin/sh

# Force the use of custom reposugeon
PHYS_DIR=`pwd -P`
PATH="$PHYS_DIR/bin:$PATH"

# Convert to Git
make 2>&1 | tee fuse-emulator.log || exit 1
# stdbuf -o 0 make 2>&1 | tee fuse-emulator.log || exit 1

# Create tags on new repository
./create_tags.sh

# Run a garbage-collect on the generated git repository
make gc
