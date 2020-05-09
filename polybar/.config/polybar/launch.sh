#!/bin/sh

# Terminate already running bar instances
killall -q polybar
# Get default network interface name
export DEFAULT_NETWORK_INTERFACE=$(ip route | awk '/^default/ {print $5}' | head -n1)
polybar mybar >>/tmp/polybar.log 2>&1 &

