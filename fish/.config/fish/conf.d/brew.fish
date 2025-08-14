status is-interactive; or exit

# configure homebrew if its installed
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end
