status is-interactive; or exit

# disable path abbreviation
set -g fish_prompt_pwd_dir_length 0

set -gx EDITOR nvim
set -gx BAT_THEME kanagawa
set -gx NODE_OPTIONS "--max-old-space-size=8192" # increase memory limit for large js projects
set -gx ELECTRON_OZONE_PLATFORM_HINT auto # wayland
set -gx MSBUILDDISABLENODEREUSE 1 # prevent dotnet build zombie processes

if test -d "$HOME/.cargo/bin"
    source "$HOME/.cargo/env.fish"
end

if test -d "$HOME/.dotnet/tools"
    fish_add_path "$HOME/.dotnet/tools"
end

if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

fzf --fish | source

fnm env --use-on-cd --shell fish | source
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path $PNPM_HOME

zoxide init fish --cmd cd | source
