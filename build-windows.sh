#!/usr/bin/env bash

set -eu

cd $(dirname $0)
BASE_DIR=$(pwd)


source common.sh

ARCH=x86_64
host=x86_64-w64-mingw32

: ${ARCH?}

OUTPUT_DIR=artifacts/ffmpeg-$FFMPEG_VERSION-audio-$ARCH-win

BUILD_DIR=$(mktemp -d -p $(pwd) build.XXXXXXXX)
# TODO: PUT BACK IN trap 'rm -rf $BUILD_DIR' EXIT

extract_ffmpeg $BUILD_DIR

cd $BUILD_DIR
# tar --strip-components=1 -xf $BASE_DIR/$FFMPEG_TARBALL


PREFIX=$BASE_DIR/$OUTPUT_DIR

FFMPEG_CONFIGURE_FLAGS+=(
    --prefix=$PREFIX
    --extra-ldflags=-L$PREFIX/lib
    --target-os=mingw32
    --arch=$ARCH
    --cross-prefix=$ARCH-w64-mingw32-
    --extra-cflags="-static -static-libgcc -static-libstdc++ -I$PREFIX/include"

)


# Build lame
PREFIX=$BASE_DIR/$OUTPUT_DIR
FFMPEG_CONFIGURE_FLAGS+=(--prefix=$PREFIX)


do_svn_checkout https://svn.code.sf.net/p/lame/svn/trunk/lame lame_svn
  cd lame_svn
    echo "Compiling lame: prefix $PREFIX"
    ./configure --disable-decoder --prefix=$PREFIX --enable-static --disable-shared --host=$host
    make -j8
    make install
  cd ..
echo "compiled LAME... "


echo "configure ffmpeg: ${FFMPEG_CONFIGURE_FLAGS[@]}"


./configure "${FFMPEG_CONFIGURE_FLAGS[@]}"
make
make install

chown $(stat -c '%u:%g' $BASE_DIR) -R $BASE_DIR/$OUTPUT_DIR
