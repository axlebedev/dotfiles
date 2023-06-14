# Setup fzf
# ---------
if [[ ! "$PATH" == */home/l-e-b-e-d-e-v/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/l-e-b-e-d-e-v/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/l-e-b-e-d-e-v/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/l-e-b-e-d-e-v/.fzf/shell/key-bindings.bash"
