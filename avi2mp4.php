#!/usr/bin/env php
<?php
declare(strict_types = 1);
if ($argc !== 2) {
    fprintf ( STDERR, "usage: %s dir\n", $argv [0] );
    die ( 1 );
}
$dir = rtrim ( $argv [1], DIRECTORY_SEPARATOR );
if (! is_readable ( $dir )) {
    fprintf ( STDERR, "supplied path is not readable! (try running as an administrator?)" );
    die(1);
}
if (! is_dir ( $dir )) {
    fprintf ( STDERR, "supplied path is not a directory!" );
    die(1);
}
$files = glob ( $dir . DIRECTORY_SEPARATOR . '*.avi' );
foreach ( $files as $file ) {
    system ( "ffmpeg -i " . escapeshellarg ( $file ) . ' ' . escapeshellarg ( $file . '.mp4' ) );
}
