if status is-interactive
# Commands to run in interactive sessions can go here

# Aliases 
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/'

# Other
if command -q try
    # try init keys its output off $SHELL; force fish so it emits fish syntax
    env SHELL=/usr/bin/fish try init ~/Work/tries | source
end

# Startup Programs
fastfetch
starship init fish | source
zoxide init fish | source
end
