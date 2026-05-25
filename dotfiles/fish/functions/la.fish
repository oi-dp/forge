function la --wraps=ls --description 'List contents of directory, including hidden files in directory using long format'
    ls -lAh --group-directories-first --time-style=long-iso $argv
end
