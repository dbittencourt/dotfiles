status is-interactive; or exit

set -g fish_color_command green
# disable path abbreviation
set -g fish_prompt_pwd_dir_length 0

set -x EDITOR nvim
set -x BAT_THEME kanagawa
set -x NODE_OPTIONS "--max-old-space-size=8192" # for large JS projects
set -x ELECTRON_OZONE_PLATFORM_HINT auto

if test -d "$HOME/.cargo/bin"
    set -p PATH "$HOME/.cargo/bin"
end
if test -d "$HOME/.dotnet/tools"
    set -p PATH "$HOME/.dotnet/tools"
end
