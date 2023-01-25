OpenAudible FFmpeg builds
===============================


This fork attempts to add the LibLAME library to the build and also disables more ffmpeg features. 

Currently broken... does not properly compile lame for each ARCH. 


Looking for assistance fixing and testing to produce static binaries for Mac Aarch64, and x86-64 for Linux, Mac and Windows. 

Project is done when the buildActions complete successfully. Will be able to test each build. 

Any assistance welcome! 

Original read me below:

Static audio-only FFmpeg builds
===============================

This project contains scripts for small static audio-only FFmpeg builds that are used
for Chromaprint packaging.

Building is done using GitHub Actions. You can find the built binaries on the releases page.

Supported platforms:

  - Linux
      * `x86\_64-linux-gnu`
  - Windows
      * `x86\_64-w64-mingw32`
  - macOS
      * `x86_64-apple-macos10.9` (macOS Mavericks and newer on Intel CPU)
      * `arm64-apple-macos11` (macOS Big Sur and newer on Apple M1 CPU)
