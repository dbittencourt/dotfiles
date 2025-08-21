status is-interactive; or exit

# remove the gretting message
set -U fish_greeting

# disable path abbreviation
set -g fish_prompt_pwd_dir_length 0

set -gx EDITOR nvim
set -gx BAT_THEME kanagawa
set -gx NODE_OPTIONS "--max-old-space-size=8192" # for large JS projects
set -gx ELECTRON_OZONE_PLATFORM_HINT auto

if test -d "$HOME/.cargo/bin"
    set -p PATH "$HOME/.cargo/bin"
end
if test -d "$HOME/.dotnet/tools"
    set -p PATH "$HOME/.dotnet/tools"
end
