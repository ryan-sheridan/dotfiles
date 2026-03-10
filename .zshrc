export TERM=xterm-256color

# nvim man
export MANPAGER="nvim +Man!"
export MANWIDTH=999

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ----------------------
# ALIASES
# ----------------------
alias nconfig="nvim ~/.config/nvim/init.lua"
alias zconfig="nvim ~/.zshrc"
alias his="cat ~/.zsh_history"
alias vim='nvim'
alias zreload='source ~/.zshrc'

# ----------------------
# ENVIRONMENT
# ----------------------
export EDITOR='nvim'
export VISUAL='nvim'

# typeset -g MODE_INDICATOR_INSERT="%F{green}[INSERT]%f"
# typeset -g MODE_INDICATOR_NORMAL="%F{yellow}[NORMAL]%f"
# typeset -g MODE_INDICATOR_VISUAL="%F{magenta}[VISUAL]%f"
# typeset -g MODE_INDICATOR="${MODE_INDICATOR_INSERT}"

export ZPLUG_HOME=$HOME/.zplug
source $ZPLUG_HOME/init.zsh

# ----------------------
# PERFORMANCE OPTIMIZATIONS
# ----------------------
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="false"
DISABLE_AUTO_TITLE="true"

# History optimizations
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

 # Speed optimizations
 setopt NO_NOMATCH
 setopt NO_GLOB_DOTS

# ----------------------
# OH MY ZSH
# ----------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

# ----------------------
# LOAD OH MY ZSH
# ----------------------
source "$ZSH/oh-my-zsh.sh"

# ----------------------
# Install Powerlevel10k if not already installed
if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Source Powerlevel10k theme configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ----------------------
# VI MODE (with mode indicators on RPROMPT)
# ----------------------
setopt vi
bindkey -v

export KEYTIMEOUT=1

# Default to insert mode indicator
MODE_INDICATOR=$MODE_INDICATOR_INSERT

# Update mode indicator based on keymap changes
zle-keymap-select() {
  case $KEYMAP in
    vicmd)
      MODE_INDICATOR=$MODE_INDICATOR_NORMAL
      ;;
    visual|select|viopp|vicolumn)
      MODE_INDICATOR=$MODE_INDICATOR_VISUAL
      ;;
    *)
      MODE_INDICATOR=$MODE_INDICATOR_INSERT
      ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

# Show mode indicator on the right prompt
# RPROMPT='${MODE_INDICATOR}'

# Optional: keep your cursor shape default (no changes)
# If you want cursor shape changes, uncomment and tweak below:
set_cursor_beam() { printf '\e[6 q' }
set_cursor_block() { printf '\e[1 q' }

zle-keymap-select() {
  case $KEYMAP in
    vicmd|visual|viopp)
      set_cursor_block ;;
    *)
      set_cursor_beam ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

# Enhanced vi-mode keybindings
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# Accept line and reset cursor (no prompt update needed)
accept-and-reset() {
  zle accept-line
}
zle -N accept-and-reset
bindkey '^M' accept-and-reset

# Escape from visual mode
force-escape-visual() {
  zle vi-cmd-mode
  zle deactivate-region
}
zle -N force-escape-visual

# ESCAPE key bindings
bindkey -M viins '^[' vi-cmd-mode
bindkey -M vicmd '^[' vi-cmd-mode
bindkey -M visual '^[' force-escape-visual

# Visual mode action bindings
bindkey -M visual 'y' vi-yank
bindkey -M visual 'd' vi-delete
bindkey -M visual 'c' vi-change
bindkey -M visual 'i' force-escape-visual

# ----------------------
# LAZY NVM LOADING
# ----------------------
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" || \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" || \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() { unset -f nvm node npm npx; nvm use default; node "$@" }
npm()  { unset -f nvm node npm npx; nvm use default; npm "$@" }
npx()  { unset -f nvm node npm npx; nvm use default; npx "$@" }

# ----------------------
# FINAL SETUP
# ----------------------
setopt PROMPT_SUBST
setopt NO_PROMPT_BANG
setopt NO_PROMPT_CR
setopt PROMPT_SP

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

autoload -Uz compinit
autoload -Uz compaudit

if [[ -z "$ZSH_COMPDUMP" ]]; then
  ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
fi

if [[ ! -f "$ZSH_COMPDUMP" || "$ZSH_COMPDUMP" -ot "$ZSH/functions" ]]; then
  compinit -i -D
else
  compinit -C
fi

# Additional performance optimizations
setopt NO_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
