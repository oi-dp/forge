function fish_greeting
end # Disable Fish greeting

# source /etc/profile with bash
if status is-login
    if not set -q __sourced_profile
        set -gx __sourced_profile 1
        exec bash -c "\
	    test -e /etc/profile && source /etc/profile
	    test -e \$HOME/.bash_profile && . \$HOME/.bash_profile
	    exec fish --login
	"
    end
    set -e __sourced_profile
end

function zsource --description 'source all my dotfiles'
    source ~/.config/fish/pathenv.fish
    source ~/.config/fish/aliases.fish
    source ~/.config/fish/hyprstart.fish
end

zsource
