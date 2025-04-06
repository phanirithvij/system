#!/usr/bin/env nix-shell
#!nix-shell -i bash
#shellcheck shell=bash

python make_opml.py >feeds.opml
jq -r '.[].feedurl' feeds.json | sort -t: -k1,1 -k2 >feeds.txt
