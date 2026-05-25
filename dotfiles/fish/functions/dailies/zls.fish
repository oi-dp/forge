function zls --description 'substitution for ls -l, just nicer'
    eza --classify=auto --icons auto --group-directories-first --oneline --sort=extension -A $argv
end
