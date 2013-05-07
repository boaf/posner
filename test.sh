#!/usr/bin/env bash

if [[ $(ps ax | grep "^ *$PPID" | awk '{print $NF}') == "-bash" ]]; then
    echo Must not be run directly. Exiting.;
    exit
fi
