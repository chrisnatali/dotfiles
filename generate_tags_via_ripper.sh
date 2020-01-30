#!/bin/bash
# Script to generate all tags for a bundler based project
# Uses ripper-tags, which tags more of Ruby source than ctags (e.g. constants are missed by ctags, but not by ripper-tags)
#
# This tags the project files AND any ruby files under paths under the bundle based LOAD_PATH
# This includes both bundled gems and stdlib

echo "tagging current project ruby files in `pwd`"
NOEXEC_DISABLE=1 ripper-tags -R || ( echo "tagging current project failed" && exit 1 )

echo "tagging current projects gems and stdlib refs into same tags file"
for d in `bundle exec ruby -e 'puts $LOAD_PATH'`; do
  [ -d "$d" ] && echo $d
done | NOEXEC_DISABLE=1 ripper-tags -a -R -L -
