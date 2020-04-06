#!/bin/sh
# use ffmpeg to concatenate all the mp4 files in the media directory
# make file executable and run like this
# ./make247.sh /path/to/media/folder
#
IN_DIR="$1";
if [ "$IN_DIR" = '' ] ; then
        IN_DIR="."
fi
for f in ${IN_DIR}/*.mp4; do echo "file '$f'" >> concat-list.txt; done
ffmpeg -noautorotate -safe 0 -f concat -i concat-list.txt -c copy output.mp4
