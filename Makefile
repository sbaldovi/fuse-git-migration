# Generic makefile for DVCS conversions using reposurgeon
#
# Steps to using this:
# 0. Copy this into a scratch directory as Makefile.
# 1. Make sure reposurgeon, repostreamer, and repopuller are on your $PATH.
# 2. Set PROJECT to the name of your project.
# 3. Set SOURCE_VCS to svn or cvs.
# 4. Set TARGET_VCS to git, hg, or bzr.
# 5. For svn, set REMOTE_URL to point at the remote repository
#    you want to convert.
# 6. For cvs, set CVS_HOST to the repo hostname and CVS_MODULE to the module,
#    then uncomment the line that builds REMOTE_URL 
#    Note: for CVS hosts other than Sourceforge or Savannah you will need to 
#    include the path to the CVS modules directory after the hostname.
# 7. Create a fuse-emulator.lift script for your custom commands, initially empty.
# 8. Run 'make stubmap' to create a stub author map.
# 9. (Optional) set REPOSURGEON to point at a faster cython build of the tool.
# 10. Run 'make' to build a converted repository.
#
# The reason both first- and second-stage stream files are generated is that,
# especially with Subversion, making the first-stage stream file is often
# painfully slow. By splitting the process, we lower the overhead of
# experiments with the lift script.
#
# For a production-quality conversion you will need to edit the map
# file and the lift script.  During the process you can set EXTRAS to
# name extra metadata such as a comments mailbox.
#
# After the conversion, you may be able to perform a sanity check with
# 'make diff' (supported for CVS and svn).  You can check
# individual tags or branches with 'make diff-tag'
#
# Note that CVS-checkout directories not matched in a conversion may be
# historical relics containing only CVSROOT directories.

EXTRAS = README ticket2allura.sh tickets_replace.sh tickets_map.txt
#REMOTE_URL = file:///home/user/fuse-emulator/code
REMOTE_URL = https://svn.code.sf.net/p/fuse-emulator/code/
VERBOSITY = "verbose 1"

# Configuration ends here

.PHONY: local-clobber remote-clobber gitk gc compare clean dist stubmap diff
# Tell make not to auto-remove tag directories, because it only tries rm and hence fails
.PRECIOUS: fuse-emulator-%-checkout fuse-emulator-%-git

default: fuse-emulator-git

# Build the converted repo from the second-stage fast-import stream
fuse-emulator-git: fuse-emulator.fi
	rm -fr fuse-emulator-git; reposurgeon "read <fuse-emulator.fi" "prefer git" "rebuild fuse-emulator-git"

# Build the second-stage fast-import stream from the first-stage stream dump
fuse-emulator.fi: fuse-emulator.svn fuse-emulator.lift fuse-emulator.map $(EXTRAS)
	reposurgeon $(VERBOSITY) "read <fuse-emulator.svn" "authors read <fuse-emulator.map" "sourcetype svn" "prefer git" "script fuse-emulator.lift" "legacy write >fuse-emulator.fo" "write --legacy >fuse-emulator.fi"

# Build the first-stage stream dump from the local mirror
fuse-emulator.svn: fuse-emulator-mirror
	repotool mirror fuse-emulator-mirror
	(cd fuse-emulator-mirror/ >/dev/null; repotool export) >fuse-emulator.svn

# Build a local mirror of the remote repository
fuse-emulator-mirror:
	repotool mirror $(REMOTE_URL) fuse-emulator-mirror

#  Get a list of tags from the project mirror
fuse-emulator-tags.txt: fuse-emulator-mirror
	cd fuse-emulator-mirror >/dev/null; repotool tags

# Make a local checkout of the source mirror for inspection
fuse-emulator-checkout: fuse-emulator-mirror
	cd fuse-emulator-mirror >/dev/null; repotool checkout ../fuse-emulator-checkout

# Make a local checkout of the source mirror for inspection at a specific tag
fuse-emulator-%-checkout: fuse-emulator-mirror
	cd fuse-emulator-mirror >/dev/null; repotool ../fuse-emulator-$*-checkout $*

# Force rebuild of first-stage stream from the local mirror on the next make
local-clobber: clean
	rm -fr fuse-emulator.fi fuse-emulator-git *~ .rs* fuse-emulator-conversion.tar.gz fuse-emulator-*-git

# Force full rebuild from the remote repo on the next make.
remote-clobber: local-clobber
	rm -fr fuse-emulator.svn fuse-emulator-mirror fuse-emulator-checkout fuse-emulator-*-checkout

# Get the (empty) state of the author mapping from the first-stage stream
stubmap: fuse-emulator.svn
	reposurgeon "read <fuse-emulator.svn" "authors write >fuse-emulator.map"

# Compare the histories of the unconverted and converted repositories at head
# and all tags.
EXCLUDE = -x CVS -x .svn -x .git
EXCLUDE += -x .svnignore -x .gitignore
headcompare:
	repotool compare $(EXCLUDE) fuse-emulator-checkout fuse-emulator-git
tagscompare:
	repotool compare-tags $(EXCLUDE) fuse-emulator-checkout fuse-emulator-git

# General cleanup and utility
clean:
	rm -fr *~ .rs* fuse-emulator-conversion.tar.gz *.svn *.fi *.fo

# Bundle up the conversion metadata for shipping
SOURCES = Makefile fuse-emulator.lift fuse-emulator.map $(EXTRAS)
fuse-emulator-conversion.tar.gz: $(SOURCES)
	tar --dereference --transform 's:^:fuse-emulator-conversion/:' -czvf fuse-emulator-conversion.tar.gz $(SOURCES)

dist: fuse-emulator-conversion.tar.gz

# Browse the generated git repository
gitk: fuse-emulator-git
	cd fuse-emulator-git; gitk --all

# Run a garbage-collect on the generated git repository.  Import doesn't.
# This repack call is the active part of gc --aggressive.  This call is
# tuned for very large repositories.
gc: fuse-emulator-git
	cd fuse-emulator-git; time git -c pack.threads=1 repack -AdF --window=1250 --depth=250
