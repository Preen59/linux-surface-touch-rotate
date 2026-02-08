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
git clone https://github.com/Preen59/linux-surface-touch-rotate.git
cd linux-surface-touch-rotate
chmod +x install.sh uninstall.sh
./install.sh
```
Log out/in or reboot.

## Verify

Check the service
```bash
systemctl --user status surface-touch-rotate.service --no-pager
```

Check the matrix changes when rotating:
```bash
xinput list-props "IPTSD Virtual Touchscreen 1B96:006A" | grep -A1 "Coordinate Transformation Matrix"
```

## Customize

If your touchscreen device name differs, edit:

- install.sh (search for TOUCHNAME=), or
- ~/.local/bin/surface-touch-rotate.sh after install

Find your device name:
```bash
xinput list | grep -i -E "iptsd|touchscreen|elan|hid"
```

## Uninstall
```bash
./uninstall.sh
```

## Notes
- `iio-sensor-proxy` may be a "static" unit on some distros (not enableable). That's OK: it is DBus-activated.

- If your `monitor-sensor --accel` outputs `Accelerometer orientation changed: left-up` (etc), this repo matches that.
