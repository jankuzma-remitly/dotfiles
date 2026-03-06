#!/bin/bash

WS="${NAME#space.}"

if [ "$FOCUSED_WORKSPACE" = "$WS" ]; then
  sketchybar --set "$NAME" \
    label.color=0xffffffff \
    background.drawing=on \
    background.color=0xff313244
else
  sketchybar --set "$NAME" \
    label.color=0xff585b70 \
    background.drawing=off \
    background.color=0x00000000
fi
