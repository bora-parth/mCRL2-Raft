#!/bin/bash

# Define the files
files=("electionSafety.mcf" "leaderCompleteness.mcf"  "logMatching.mcf" "stateMachineSafety.mcf")
# Execute a command outside tmux sessions
echo "Executing command outside tmux sessions"
export PATH=/scratch/mCRL2/master/build/stage/bin/:$PATH
cd /scratch/20201025
mcrl22lps raft_spec_AN_12.mcrl2 raft_AN_12.lps

# Iterate over the files and create tmux sessions
for file in "${files[@]}"; do
    session_name="${file%.*}_12" # Extract the session name without the file extension
    
    # Open a new tmux session and run the commands
    tmux new-session -d -s "$session_name"
    tmux send-keys -t "$session_name" 'export PATH=/scratch/mCRL2/master/build/stage/bin/:$PATH' Enter
    tmux send-keys -t "$session_name" 'cd /scratch/20201025' Enter
    tmux send-keys -t "$session_name" "lps2pbes -v raft_AN_12.lps -f $file raft_$session_name.pbes" Enter
    tmux send-keys -t "$session_name" "pbessolvesymbolic --cached --chaining --groups=simple -v -m100 --threads=4 --timings=timing_$session_name.txt -rjittyc raft_$session_name.pbes" Enter
done

