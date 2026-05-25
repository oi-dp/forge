function batman --description 'wrapper for batman to use themes'
    set -lx BAT_THEME 'Solarized (dark)'
    command batman $argv
end
