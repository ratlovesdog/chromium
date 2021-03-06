#!/bin/bash
# Copyright 2013 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Changes all RPATHs in a given directory from XORIGIN to $ORIGIN
# See the comment about XORIGIN in download_build_install.py

# Fixes rpath from XORIGIN to $ORIGIN in a single file $1.
function fix_rpath {
  chrpath -r $(chrpath $1 | cut -d " " -f 2 | sed s/XORIGIN/\$ORIGIN/g \
    | sed s/RPATH=//g) $1 > /dev/null
}

for i in $(find $1 | grep "\.so$"); do
  fix_rpath $i
done

# Mark that rpaths are fixed.
# This file is used by GYP as 'output' to mark that RPATHs are already fixed
# for incremental builds.
touch $1/rpaths.fixed.txt
