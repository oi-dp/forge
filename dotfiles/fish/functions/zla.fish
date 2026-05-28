function zla --description 'substitution for ls -la, nicer'
    eza --classify=auto --icons auto --group-directories-first --sort=extension -a -l --octal-permissions --no-permissions $argv
end
