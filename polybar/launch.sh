#!/usr/bin/env bash

# Terminate already running bar instances
# polybar-msg cmd quit
killall -q polybar

# Launch polybar
echo "---" | tee -a /tmp/polybar1.log 
polybar mybar 2>&1 | tee -a /tmp/polybar1.log & disown
