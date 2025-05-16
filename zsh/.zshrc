# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' mode auto      # update automatically without asking
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source "$ZSH"/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR='nvim'
export GPG_TTY=$(tty)
export NVM_DIR="$HOME/.nvm"
export BAT_THEME="kanagawa"
# avoid issues with huge javascript projects from work
export NODE_OPTIONS="--max-old-space-size=8192"

alias ta="tmux new -A -D -s main"
alias cat="bat" # use bat as default for cat

# update path, check /etc/paths and /etc/paths.d to avoid duplicates
if [[ "$(uname)" == "Darwin" ]] then
  PATH="/opt/homebrew/bin:$PATH"
  export PATH="$HOME/.dotnet/tools:$PATH"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" 
else
  PATH="$HOME/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
  export PATH="$HOME/.dotnet/tools:$PATH"
  # make electron apps use wayland whenever possible 
  export ELECTRON_OZONE_PLATFORM_HINT=auto
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  
fi

[ -s "/opt/adguard-cli/bash-completion.sh" ] && \. "/opt/adguard-cli/bash-completion.sh"

# setup fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"
# use fd as the default find command for fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}
