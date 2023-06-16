#!/bin/bash

# Define the files
files=("electionSafety.mcf" "leaderCompleteness.mcf" "logMatching.mcf" "logMatchingLiveliness.mcf" "stateMachineLiveliness.mcf" "stateMachineSafety.mcf")

# Iterate over the files and create tmux sessions
for file in "${files[@]}"; do
    session_name="${file%.*}_crash" # Extract the session name without the file extension
    
    # Open a new tmux session and run the commands
    tmux new-session -d -s "$session_name"
    tmux send-keys -t "$session_name" 'export PATH=/scratch/mCRL2/master/build/stage/bin/:$PATH' Enter
    tmux send-keys -t "$session_name" 'cd /scratch/20201025' Enter
    tmux send-keys -t "$session_name" "lps2pbes -v raft.lps -f $file raft_$session_name.pbes" Enter
    tmux send-keys -t "$session_name" "pbessolvesymbolic --cached --chaining --groups=simple -v -m200 --threads=5 --timings=timing_$session_name.txt -rjittyc raft_$session_name.pbes" Enter
done

# Attach to the first session
tmux attach-session -t "${files[0]%.*}"
