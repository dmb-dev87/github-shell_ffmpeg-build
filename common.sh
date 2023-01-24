#!/usr/bin/env bash

FFMPEG_VERSION=5.1.2
FFMPEG_TARBALL=ffmpeg-$FFMPEG_VERSION.tar.bz2
FFMPEG_TARBALL_URL=http://ffmpeg.org/releases/$FFMPEG_TARBALL

LAME_TARBALL=


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
--enable-debug=3
--disable-optimizations
--disable-ffplay
--enable-ffmpeg
--enable-ffprobe
--disable-securetransport

)
