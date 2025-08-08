# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# environment variables
export EDITOR='nvim'
export GPG_TTY=$(tty)
export NVM_DIR="$HOME/.nvm"
export BAT_THEME="kanagawa"
export NODE_OPTIONS="--max-old-space-size=8192" # For large JS projects
export ZSH="$HOME/.oh-my-zsh"

# oh my zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX="true"
zstyle ':omz:update' mode disabled
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source "$ZSH/oh-my-zsh.sh"

# to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# aliases
alias ta="tmux new -A -D -s dotfiles"
alias cat="bat" # Use bat as a replacement for cat

# configure path
add_to_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

if [[ "$(uname)" == "Darwin" ]]; then
  # macOS specific settings
  add_to_path "/opt/homebrew/bin"
  for script in "/opt/homebrew/opt/nvm/nvm.sh" "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"; do
    [ -s "$script" ] && source "$script"
  done
else
  # linux specific settings
  add_to_path "$HOME/.cargo/bin"
  export ELECTRON_OZONE_PLATFORM_HINT=auto
  for script in "$NVM_DIR/nvm.sh" "$NVM_DIR/bash_completion"; do
    [ -s "$script" ] && source "$script"
  done
fi

add_to_path "$HOME/.dotnet/tools"
unset -f add_to_path

# fzf
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir() { fd --type=d --hidden --exclude .git . "$1"; }

# adguard
[ -s "/opt/adguard-cli/bash-completion.sh" ] && source "/opt/adguard-cli/bash-completion.sh"
