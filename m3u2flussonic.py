#!/usr/bin/env python

import sys
import urllib2
import codecs
from contextlib import closing

class Track:
    def __init__(self, length, title, path):
        self.length = length
        self.title = title
        self.path = path


def parse(uri):
    with closing(urllib2.urlopen(uri)
                 if urllib2.splittype(uri)[0]
                 else codecs.open(uri, 'r')) as inf:
        # initialize playlist variables before reading file
        playlist = []
        song = Track(None, None, None)

        for line_no, line in enumerate(inf):
            try:
                line = line.strip(codecs.BOM_UTF8).strip()
                if line.startswith('#EXTINF:'):
                    # pull length and title from #EXTINF line
                    length, title = line.split('#EXTINF:')[1].split(',', 1)
                    song = Track(length, title, None)
                elif line.startswith('#'):
                    # comment, #EXTM3U
                    pass
                elif len(line) != 0:
                    # pull song path from all other, non-blank lines
                    song.path = line
                    playlist.append(song)

                    # reset the song variable so it doesn't use the same EXTINF more than once
                    song = Track(None, None, None)
            except Exception, ex:
                raise Exception("Can't parse line %d: %s" % (line_no, line), ex)

    return playlist


if __name__ == '__main__':

    if len(sys.argv) != 2:
       print 'Usage: %s /path/to/playlist.m3u' % str(sys.argv[0])
       print 'or: %s http://11.22.33.44/path/to/playlist.m3u' % str(sys.argv[0])
       sys.exit(1)

    m3ufile = str(sys.argv[1])
    index=1
    playlist = parse(m3ufile)
    for item in playlist:
        path = item.path
        if item.path.startswith("http://"):
            if "m3u8" in item.path:
                path = item.path.replace('http','hls',1)
            else:
                path = item.path.replace('http','tshttp',1)
        title = item.title
        if not item.title:
            title = 'stream%i' % index
        print ('stream %(name)s {\n  url %(url)s;\n}' % {"name": title.replace(" ","_"), "url": path })
        index += 1
