#!/usr/bin/env bash
	# shell is blocked by SC2240
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later
# Based in part upon 'lfs-scripts' from emmet1 (https://github.com/emmett1/lfs-scripts), which is:
# 		Copyright 2018-2019 Emmet1 <emmett1.2miligrams@gmail.com> as GPLv3

# shellcheck source=kreypi/kreypi.sh

: '
Scratcher - Simple way to build Linux from scratch/source'

. hierarcher.bash "$1" fsh-core
. coreutils-export.bash "$1"

printf '%s\n' "Minimal Linux from scratch/source has been made in $1"
