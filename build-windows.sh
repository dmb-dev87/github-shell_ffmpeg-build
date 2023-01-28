#!/usr/bin/env bash

set -eu

cd $(dirname $0)
BASE_DIR=$(pwd)
echo "step1......"

echo $BASE_DIR

source common.sh

if [ ! -e $FFMPEG_TARBALL ]
then
	curl -s -L -O $FFMPEG_TARBALL_URL
fi
ARCH=x86_64
host=x86_64-w64-mingw32

: ${ARCH?}

OUTPUT_DIR=artifacts/ffmpeg-$FFMPEG_VERSION-audio-$ARCH-w64-mingw32

BUILD_DIR=$(mktemp -d -p $(pwd) build.XXXXXXXX)
# TODO: PUT BACK IN trap 'rm -rf $BUILD_DIR' EXIT

cd $BUILD_DIR
tar --strip-components=1 -xf $BASE_DIR/$FFMPEG_TARBALL


PREFIX=$BASE_DIR/$OUTPUT_DIR
CF="-static -static-libgcc -static-libstdc++ -I$PREFIX/include"
# CF="'$CF'"
echo "CF=$CF"

FFMPEG_CONFIGURE_FLAGS+=(
    --prefix=$PREFIX
    --extra-ldflags=-L$PREFIX/lib
    --target-os=mingw32
    --arch=$ARCH
    --cross-prefix=$ARCH-w64-mingw32-
    --extra-cflags="-static -static-libgcc -static-libstdc++ -I$PREFIX/include"

)

echo "test ./configure ${FFMPEG_CONFIGURE_FLAGS[@]}"


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
echo "compiled LAME... $PREFIX "

find $PREFIX 

echo "./configure ${FFMPEG_CONFIGURE_FLAGS[@]}"
PL=$PREFIX/lib
ls -la $PL
file $PL/libmp3lame.a
pwd && ls

FFMPEG_CONFIGURE_FLAGS+=(--extra-cflags="-I$PREFIX/include")
# FFMPEG_CONFIGURE_FLAGS+=(--extra-ldflags="-L$PREFIX/lib")
# echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

# LD_LIBRARY_PATH+=" $PREFIX/lib"

echo "configure ffmpeg: ${FFMPEG_CONFIGURE_FLAGS[@]}"

set -x

./configure "${FFMPEG_CONFIGURE_FLAGS[@]}"
make
make install

chown $(stat -c '%u:%g' $BASE_DIR) -R $BASE_DIR/$OUTPUT_DIR
