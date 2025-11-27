#!/usr/bin/env bash

set -x

while sudo iptables -D INPUT -j reaction 2>/dev/null; do :; done
while sudo iptables -D FORWARD -j reaction 2>/dev/null; do :; done
while sudo ip6tables -D FORWARD -j reaction 2>/dev/null; do :; done
while sudo ip6tables -D INPUT -j reaction 2>/dev/null; do :; done
sudo ip6tables -X reaction
sudo iptables -X reaction
