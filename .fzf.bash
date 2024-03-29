# Setup fzf
# ---------
if [[ ! "$PATH" == */home/user/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/user/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/user/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/user/.fzf/shell/key-bindings.bash"
