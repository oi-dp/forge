#!/usr/bin/env bash

SESSION="Watchdog"

# if session exists, just attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach-session -t "$SESSION"
    exit 0
fi

# initialize session and create layout
PANE0=$(tmux new-session -d -s "$SESSION" -n "main" -P -F "#{pane_id}")
PANE1=$(tmux split-window -h -t "$PANE0" -P -F "#{pane_id}")
PANE2=$(tmux split-window -v -t "$PANE0" -P -F "#{pane_id}")

tmux set-hook -t "$SESSION" client-attached \
    "run-shell 'sleep 0.3 \
    && tmux send-keys -t $PANE0 ducker Enter \
    && tmux send-keys -t $PANE1 btop Enter \
    && tmux send-keys -t $PANE2 surge Enter \
    && tmux set-hook -t $SESSION -u client-attached'"

tmux select-pane -t "$PANE1"
tmux attach-session -t "$SESSION"
