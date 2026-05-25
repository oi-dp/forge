#!/usr/bin/env sh

export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP:-Hyprland}"
export XDG_SESSION_TYPE=wayland
VARIABLES="XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE"
VARIABLES="${VARIABLES} WAYLAND_DISPLAY"
SESSION_TARGET="hyprland-session.target"

# Check if another Hyprland session is already active.
#
if systemctl --user -q is-active "$SESSION_TARGET"; then
  echo "Another session found; refusing to overwrite the variables"
  exit 1
fi

if hash dbus-update-activation-environment 2>/dev/null; then
  # shellcheck disable=SC2086
  dbus-update-activation-environment --systemd ${VARIABLES:- --all}
fi

# reset failed state of all user units
systemctl --user reset-failed

# shellcheck disable=SC2086
systemctl --user import-environment $VARIABLES
systemctl --user start "$SESSION_TARGET"
