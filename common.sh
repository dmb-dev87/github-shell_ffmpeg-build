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
      svn checkout $repo_url $to_dir.tmp  --non-interactive --trust-server-cert || exit 1
    else
      svn checkout -r $desired_revision $repo_url $to_dir.tmp || exit 1
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


FFMPEG_CONFIGURE_FLAGS=(
--disable-everything
--disable-filters
--disable-encoders
--disable-muxers
--disable-demuxers
--disable-decoders
--disable-bsfs
--disable-parsers
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
--enable-demuxer=aac
--enable-demuxer=mov
--enable-demuxer=mp3
--enable-demuxer=apng
--enable-demuxer=mjpeg
--enable-libmp3lame
--enable-debug=3
--disable-optimizations
--disable-ffplay
--enable-ffmpeg
--enable-ffprobe
--disable-securetransport

)
