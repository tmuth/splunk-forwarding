#!/bin/bash

tail -f $SPLUNK_HOME/var/log/splunk/metrics.log \
    | grep --line-buffered --color=none "group=queue.*largest_size=[1-9]" \
    | sed --unbuffered 's/_size//g' \
    |  gawk 'BEGIN { FS = "," } ; {printf " %-30s %-16s %-18s %-18s %-18s  \n", $2,$3,$4,$5,$6 ;fflush()}' \
    | h current=[1-9]+[0-9]+\|current_kb=[1-9]+[0-9]+?