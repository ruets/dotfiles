function notes
    if test (count $argv) -eq 0
        mkdir -p ~/notes
        set dir ~/notes
    else
        set dir $argv[1]
    end

    cd $dir
    touch notes.md
    set dirname notes-(basename (pwd))
    if test $dirname = notes-notes
        set dirname notes
    end

    echo "Starting tmux session for $dirname"
    if not tmux has-session -t $dirname 2>/dev/null
        # New session for project and window for nvim
        tmux new-session -d -s $dirname -n nvim
        tmux send-keys -t $dirname:nvim 'nvim notes.md' C-m

        # New window for AI
        tmux new-window -t $dirname -n AI
        tmux send-keys -t $dirname:AI $AI C-m

        # New window for lazygit
        tmux new-window -t $dirname -n lazygit
        tmux send-keys -t $dirname:lazygit lazygit C-m

        # New window for fish
        tmux new-window -t $dirname -n fish
        tmux send-keys -t $dirname:fish lt C-m

        # New window for grip
        tmux new-window -t $dirname -n grip
        tmux send-keys -t $dirname:grip 'go-grip notes.md' C-m
    end
    tmux attach -t $dirname:nvim
end
