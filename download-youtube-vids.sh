#!/bin/bash

mkdir -p downloads
cd downloads

input="../videos.txt"
while IFS= read -r line; do
    echo "Downloadng: $line"
    youtube-dl -x "$line"
done < "$input"

for f in *.opus; do
    ffmpeg -i "$f" -acodec mp3 "$f.mp3"
done

rm -rf *.opus

