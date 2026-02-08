#!/usr/bin/env bash
set -euo pipefail

systemctl --user disable --now surface-touch-rotate.service 2>/dev/null || true
rm -f "${HOME}/.config/systemd/user/surface-touch-rotate.service"
systemctl --user daemon-reload 2>/dev/null || true

rm -f "${HOME}/.local/bin/surface-touch-rotate.sh"

echo "Uninstalled."
