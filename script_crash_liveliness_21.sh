#!/bin/bash

# Define the files
files=("clientCommand.mcf" "electionSafetyLiveliness.mcf" "leaderCompletenessLiveliness.mcf" "timeout.mcf" "logMatchingLiveliness.mcf" "stateMachineLiveliness.mcf" )
# Execute a command outside tmux sessions
echo "Executing command outside tmux sessions"
export PATH=/scratch/mCRL2/master/build/stage/bin/:$PATH
cd /scratch/20201025
mcrl22lps raft_spec_AC_21.mcrl2 raft_AC_21.lps

echo "going tmux mode rn"
# Iterate over the files and create tmux sessions
for file in "${files[@]}"; do
    session_name="${file%.*}_crash_21" # Extract the session name without the file extension
    
    # Open a new tmux session and run the commands
    tmux new-session -d -s "$session_name"
    tmux send-keys -t "$session_name" 'export PATH=/scratch/mCRL2/master/build/stage/bin/:$PATH' Enter
    tmux send-keys -t "$session_name" 'cd /scratch/20201025' Enter
    tmux send-keys -t "$session_name" "lps2pbes -v raft_AC_21.lps -f $file raft_$session_name.pbes" Enter
    tmux send-keys -t "$session_name" "pbessolvesymbolic --cached --chaining --groups=simple -v -m200 --threads=5 --timings=timing_$session_name.txt -rjittyc -s2 raft_$session_name.pbes" Enter
done

