# linux-surface-touch-rotate
Auto touch rotation for Surface 4 Pro running Linux Mint w/ Linux-Surface kernel

Fixes Surface Pro (linux-surface + iptsd) touchscreen coordinates so touch follows screen rotation on X11/Cinnamon.

This listens for orientation changes from `monitor-sensor --accel` and applies the correct XInput
"Coordinate Transformation Matrix" to the **iptsd virtual touchscreen** device.

## Tested on
- Microsoft Surface Pro 4
- Linux Mint (Cinnamon, X11)
- linux-surface kernel
- iptsd

## Requirements
- `iio-sensor-proxy` (provides `monitor-sensor`)
- `xinput`
- A running X11 session (this is an X11 solution)

## Install

```bash
git clone https://github.com/YOURNAME/surface-touch-rotate.git
cd surface-touch-rotate
./install.sh
