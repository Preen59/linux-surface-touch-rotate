#!/usr/bin/env bash
set -euo pipefail

# Default touch device name for linux-surface + iptsd on Surface Pro 4.
# Override at install time like:
#   TOUCHNAME="..." ./install.sh
TOUCHNAME_DEFAULT='IPTSD Virtual Touchscreen 1B96:006A'
TOUCHNAME="${TOUCHNAME:-$TOUCHNAME_DEFAULT}"

# Dependencies (Mint/Ubuntu)
if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y iio-sensor-proxy xinput
else
  echo "No apt found. Install dependencies manually: iio-sensor-proxy, xinput"
fi

mkdir -p "${HOME}/.local/bin"

cat > "${HOME}/.local/bin/surface-touch-rotate.sh" <<EOF2
#!/usr/bin/env bash
set -euo pipefail

TOUCHNAME="${TOUCHNAME}"
export DISPLAY="\${DISPLAY:-:0}"

# Wait for the touch device to exist (iptsd can come up slightly after login)
for _ in {1..80}; do
  xinput list --name-only 2>/dev/null | grep -Fx "\$TOUCHNAME" >/dev/null && break
  sleep 0.25
done

apply() {
  xinput set-prop "\$TOUCHNAME" "Coordinate Transformation Matrix" "\$@"
}

monitor-sensor --accel | while read -r line; do
  # Only react to orientation lines (ignore lux spam)
  [[ "\$line" == *"orientation"* ]] || continue

  case "\$line" in
    *"left-up"*)    apply 0 -1 1  1 0 0  0 0 1 ;;
    *"right-up"*)   apply 0 1 0  -1 0 1  0 0 1 ;;
    *"bottom-up"*)  apply -1 0 1  0 -1 1  0 0 1 ;;
    *"normal"*)     apply 1 0 0  0 1 0  0 0 1 ;;
  esac
done
EOF2

chmod +x "${HOME}/.local/bin/surface-touch-rotate.sh"

mkdir -p "${HOME}/.config/systemd/user"
cp -f "systemd-user/surface-touch-rotate.service" "${HOME}/.config/systemd/user/surface-touch-rotate.service"
sed -i "s|__HOME__|${HOME}|g" "${HOME}/.config/systemd/user/surface-touch-rotate.service"

systemctl --user daemon-reload
systemctl --user enable --now surface-touch-rotate.service

echo
echo "Installed. Check status with:"
echo "  systemctl --user status surface-touch-rotate.service --no-pager"
EOF
