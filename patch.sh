#!/bin/bash
set -e
echo "Installing patch at `pwd`"
patch libavformat/movenc.c < patch.diff
echo "installed patch"

