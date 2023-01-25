#!/usr/bin/env bash

set -eu

cd $(dirname $0)
BASE_DIR=$(pwd)

source common.sh

if [ ! -e $FFMPEG_TARBALL ]
then
	curl -s -L -O $FFMPEG_TARBALL_URL
fi

: ${ARCH?}

OUTPUT_DIR=artifacts/ffmpeg-$FFMPEG_VERSION-audio-$ARCH-w64-mingw32

BUILD_DIR=$(mktemp -d -p $(pwd) build.XXXXXXXX)
trap 'rm -rf $BUILD_DIR' EXIT

cd $BUILD_DIR
tar --strip-components=1 -xf $BASE_DIR/$FFMPEG_TARBALL

FFMPEG_CONFIGURE_FLAGS+=(
    --prefix=$BASE_DIR/$OUTPUT_DIR
    --extra-cflags='-static -static-libgcc -static-libstdc++'
    --target-os=mingw32
    --arch=$ARCH
    --cross-prefix=$ARCH-w64-mingw32-
)

# Build lame
PREFIX=$BASE_DIR/$OUTPUT_DIR
FFMPEG_CONFIGURE_FLAGS+=(--prefix=$PREFIX)


do_svn_checkout https://svn.code.sf.net/p/lame/svn/trunk/lame lame_svn
  cd lame_svn
    echo "Compiling lame: prefix $PREFIX"
    ./configure --enable-nasm --disable-decoder --prefix=$PREFIX --enable-static --disable-shared
    make -j8
    make install
  cd ..
echo "compiled LAME... "


FFMPEG_CONFIGURE_FLAGS+=(--extra-cflags="-I$PREFIX/include")
FFMPEG_CONFIGURE_FLAGS+=(--extra-ldflags="-L$PREFIX/lib")

echo "configure ffmpeg: ${FFMPEG_CONFIGURE_FLAGS[@]}"


./configure "${FFMPEG_CONFIGURE_FLAGS[@]}"
make
make install

chown $(stat -c '%u:%g' $BASE_DIR) -R $BASE_DIR/$OUTPUT_DIR
