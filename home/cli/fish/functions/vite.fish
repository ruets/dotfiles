function vite
    if test (count $argv) -eq 0
        set dir (pwd)
    else
        set dir $argv[1]
    end

    cd $dir
    set dirname (basename (pwd))
    echo "Starting tmux session for $dirname"
    if not tmux has-session -t $dirname 2>/dev/null
        # New session for vite project and window for nvim
        tmux new-session -d -s $dirname -n nvim
        tmux send-keys -t $dirname:nvim nvim C-m

        # New window for lazygit
        tmux new-window -t $dirname -n lazygit
        tmux send-keys -t $dirname:lazygit lazygit C-m

        # New window for fish
        tmux new-window -t $dirname -n fish
        tmux send-keys -t $dirname:fish lt C-m

        # New window for nodejs
        tmux new-window -t $dirname -n nodejs
        tmux send-keys -t $dirname:nodejs 'npm run dev' C-m
    end
    tmux attach -t $dirname:nvim
end
