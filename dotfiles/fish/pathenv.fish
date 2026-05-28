# PATH
fish_add_path $HOME/.local/bin

# ENVIRONMENT
# bat, for syntax highlighting in the terminal
set -gx BAT_CONFIG_DIR $HOME/.config/bat
set -gx BAT_CONFIG_PATH $HOME/.config/bat/config

# terminals
set -gx TERMCMD foot

# Set the default editor to neovim
set -gx EDITOR nvim

# Nvidia environment for Hyprland
set -gx LIBVA_DRIVER_NAME nvidia
set -gx XDG_SESSION_TYPE wayland
set -gx GBM_BACKEND nvidia-drm
set -gx __GLX_VENDOR_LIBRARY_NAME nvidia
set -gx NVD_BACKEND direct
set -gx MOZ_DISABLE_RDD_SANDBOX 1

# fzf.fish plugins environment
set -gx FZF_DEFAULT_OPTS "\
  --style full \
  --border rounded \
  --border-label ' fzf '  \
  --list-label ' files ' \
  --input-label ' find ' \
  --preview-label ' preview ' \
  --margin 1 \
  --padding 1 \
  --height 60% \
  --color 'border:#444b6a, label:#a9b1d6' \
  --color 'preview-border:#cf87e8, preview-label:#cf87e8' \
  --color 'list-border:#8cc85f, list-label:#8cc85f' \
  --color 'input-border:#ff5454, input-label:#ff5454' \
  --info inline \
  --bind 'ctrl-/:toggle-preview' \
  --bind 'ctrl-c:abort'"

fzf_configure_bindings --directory=shift-alt-f --variables=shift-alt-v --git_status=shift-alt-g --history=shift-alt-h
set -gx fzf_preview_dir_cmd eza --classify=auto --color=always --icons auto --group-directories-first --sort=extension -A
set -gx fzf_fd_opts --hidden --exclude=.git
set -gx fzf_directory_opts --prompt="> " --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
