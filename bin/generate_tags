#!/bin/bash
#
# Script to generate all tags for a bundler based project
# Users ctags AND ripper-tags and combine the results since both tagging
# programs cover different language elements
#
# This tags the project files AND any ruby files under paths under the bundle based LOAD_PATH
# including bundled gems and stdlib

echo "." > tmp_tag_src_dirs
for d in `bundle exec ruby -e 'puts $LOAD_PATH'`; do
  [ -d "$d" ] && echo $d
done >> tmp_tag_src_dirs

NOEXEC_DISABLE=1 ripper-tags -R -L tmp_tag_src_dirs -f tmp_tag_rtags
ctags -R -L tmp_tag_src_dirs -f tmp_tag_ctags

cat tmp_tag_rtags tmp_tag_ctags | sort | uniq > tags
rm tmp_tag_rtags tmp_tag_ctags
