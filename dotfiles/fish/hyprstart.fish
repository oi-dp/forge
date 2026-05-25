# auto-start hyprland
if status is-login
  if test (tty) = /dev/tty1; and test -z "$WAYLAND_DISPLAY"
    exec start-hyprland
  end
end
