# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/togume/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aws brew git iterm2 postgres yarn)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='mvim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ll='ls -alh'
alias cb='cd ..'
alias scrl='screen -ls'
alias scrr='screen -r'
alias relver='echo release-`date +"%Y%m%d%H%M%S"`'
alias dnsf='dscacheutil -flushcache'
alias rnri='react-native run-ios'
alias st='npx speed-cloudflare-cli'
alias pt='ping 1.1.1.1 -i .1'
alias ptl='ping 192.168.0.1 -i .1'
alias tpng='pngquant'

# Use nvim instead of vi
alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'

# Compress PDF
alias cpdf='gs -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -q -o `date +"%Y%m%d%H%M%S"`-min.pdf'

# Restart coreaudiod
alias rcad='sudo launchctl kickstart -kp system/com.apple.audio.coreaudiod'

# Writing Aliases
# alias jour='touch ~/Notes/Personal/Journal/`date +"%Y%m%d".md` && code ~/Notes/Personal/Journal/`date +"%Y%m%d".md`'
alias ia="open $1 -a /Applications/iA\ Writer.app"
alias jour='cp ~/Notes/Templates/fmj-boot-sequence.md ~/Notes/Personal/Journal/`date +"%Y%m%d".md` && ia ~/Notes/Personal/Journal/`date +"%Y%m%d".md`'
alias daily='echo `date +"# %Y%m%d\n\n## Action Items"` >> ~/Library/Mobile\ Documents/27N4MQEA55~pro~writer/Documents/Daily/`date +"%Y%m%d.md"` && ia ~/Library/Mobile\ Documents/27N4MQEA55~pro~writer/Documents/Daily/`date +"%Y%m%d.md"`'

alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

# Brew (cached for faster startup)
if [[ -f ~/.zsh_brew_cache ]]; then
  source ~/.zsh_brew_cache
else
  /opt/homebrew/bin/brew shellenv > ~/.zsh_brew_cache
  source ~/.zsh_brew_cache
fi
export PATH="/usr/local/sbin:$PATH"



# Functions

## Show charging power
chrg() {
  local batt=$(pmset -g batt)
  local pct=$(echo "$batt" | grep -o '[0-9]*%' | tr -d '%')
  local charging=$(echo "$batt" | grep -q 'charging' && echo "Yes" || echo "No")
  local time=$(echo "$batt" | grep -o '[0-9]*:[0-9]* remaining' | cut -d' ' -f1)
  local watts=$(ioreg -rn AppleSmartBattery | grep -o '"Watts"=[0-9]*' | head -1 | cut -d= -f2)
  
  if [[ "$charging" == "Yes" ]]; then
    if [[ -n "$time" ]]; then
      echo "⚡ ${watts}W · 🔋 ${pct}% · ⏱ ${time}"
    else
      echo "⚡ ${watts}W · 🔋 ${pct}%"
    fi
  else
    echo "🔋 ${pct}%"
  fi
}

## Extract audio for Whisper processing
xaft() {
  echo "ffmpeg -i $1 -acodec pcm_s16le -ar 16000 $1.wav"
  ffmpeg -i $1 -acodec pcm_s16le -ar 16000 $1.wav
}

## Extract audio for Whisper processing
transcribe() {
  echo "~/Projects/AI/Whisper/whisper.cpp/main -m ~/Projects/AI/Whisper/whisper.cpp/models/ggml-large.bin -f $1 -otxt -of ./$1 -bs 5 -et 2.8 -mc 64"
  ~/Projects/AI/Whisper/whisper.cpp/main -m ~/Projects/AI/Whisper/whisper.cpp/models/ggml-large.bin -f $1 -otxt -of ./$1 -bs 5 -et 2.8 -mc 64
}

# pnpm
export PNPM_HOME="/Users/togume/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# Cached pnpm completions for faster startup
if [[ ! -f ~/.zsh_pnpm_completion || ~/.zsh_pnpm_completion -ot $(which pnpm) ]]; then
  pnpm completion zsh > ~/.zsh_pnpm_completion 2>/dev/null
fi
[[ -f ~/.zsh_pnpm_completion ]] && source ~/.zsh_pnpm_completion
# pnpm end

# >>> conda initialize (lazy-loaded for faster startup) >>>
conda() {
  unfunction conda
  __conda_setup="$('/Users/togume/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/Users/togume/miniconda3/etc/profile.d/conda.sh" ]; then
      . "/Users/togume/miniconda3/etc/profile.d/conda.sh"
    else
      export PATH="/Users/togume/miniconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup
  conda "$@"
}
# <<< conda initialize <<<


# Mise Setup (using shims for faster startup)
eval "$(/Users/togume/.local/bin/mise activate zsh --shims)"

# Try Setup (lazy-loaded for faster startup)
try() {
  unfunction try
  eval "$(command try init)"
  try "$@"
}

