#!/usr/bin/env bash

FFMPEG_VERSION=5.1.2
FFMPEG_TARBALL=ffmpeg-$FFMPEG_VERSION.tar.bz2
FFMPEG_TARBALL_URL=http://ffmpeg.org/releases/$FFMPEG_TARBALL

do_svn_checkout() {
  repo_url="$1"
  to_dir="$2"
  desired_revision=""
  if [ ! -d $to_dir ]; then
    echo "svn checking out to $to_dir"
    if [[ -z "$desired_revision" ]]; then
      svn checkout -q $repo_url $to_dir.tmp  --non-interactive --trust-server-cert || exit 1
    else
      svn checkout -q -r $desired_revision $repo_url $to_dir.tmp || exit 1
    fi
    mv $to_dir.tmp $to_dir
  else
    cd $to_dir
    echo "not svn Updating $to_dir since usually svn repo's aren't updated frequently enough..."
    # XXX accomodate for desired revision here if I ever uncomment the next line...
    # svn up
    cd ..
  fi
}

# Args: configure options, configure env
# Not yet used.
build_lame()
{
  do_svn_checkout https://svn.code.sf.net/p/lame/svn/trunk/lame lame_svn
  cd lame_svn
    echo "Compiling lame with config: $1"
    $2 ./configure "$1"
    make -j8
    make install
  cd ..
  echo "compiled LAME... $PREFIX "
}


extract_ffmpeg()
{

if [ ! -e $FFMPEG_TARBALL ]
then
	echo "curl get $FFMPEG_TARBALL_URL"
        curl -O $FFMPEG_TARBALL_URL
fi

cp patch.* $BUILD_DIR

cd $BUILD_DIR

tar --strip-components=1 -xf $BASE_DIR/$FFMPEG_TARBALL


cp ../patch.* .
echo "running patch:"
./patch.sh

#  Apply patch(s)

}

# add the env at the top as a comment about what version and patches were applied
# and are printed when ffmpeg/ffprobe starts (with the rest of the configure flags)

FFMPEG_CONFIGURE_FLAGS=(
--env=ffmpeg_version=$FFMPEG_VERSION
--env=ffmpeg_builder=github.com/openaudible/ffmpeg-build
--disable-shared
--enable-static
--enable-pic
--disable-doc
--disable-debug
--disable-avdevice
--enable-swscale
--disable-programs
--enable-encoders 
--disable-muxers 
--disable-demuxers 
--disable-protocols 
--disable-parsers 
--disable-filters 
--disable-network
--disable-bsfs 
--enable-protocol=file 
--enable-muxer=ffmetadata 
--enable-demuxer=ffmetadata 
--enable-libmp3lame 
--enable-encoder=libmp3lame 
--enable-parser=aac 
--enable-parser=ac3 
--enable-encoder=aac 
--enable-encoder=ac3 
--enable-muxer=mp4 
--enable-muxer=mov 
--enable-muxer=mp3 
--enable-muxer=mjpeg 
--enable-muxer=mov 
--enable-muxer=apng 
--enable-muxer=ipod 
--enable-decoder=aac 
--enable-demuxer=mjpeg_2000 
--enable-demuxer=image2 
--enable-muxer=image2 
--enable-demuxer=smjpeg 
--enable-demuxer=aac 
--enable-demuxer=mov 
--enable-demuxer=mp3 
--enable-demuxer=apng 
--enable-demuxer=mjpeg 
--enable-decoder=mjpeg
--enable-encoder=mjpeg
--enable-filter=scale 
--enable-filter=aformat
--enable-filter=anull
--enable-filter=atrim
--enable-filter=format
--enable-filter=null
--enable-filter=setpts
--enable-filter=trim
--disable-securetransport
--disable-ffplay 
--enable-ffmpeg 
--enable-ffprobe 
)
