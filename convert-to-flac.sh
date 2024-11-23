#!/bin/bash -eu

for f in ~/Music/5.1/*.m4a; do
    ffmpeg -i "$f" \
           -acodec flac \
           "$f.flac"
done
