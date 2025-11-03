function dev-latex
    set -l WORKING_DIR $argv[1]
    if test -z "$WORKING_DIR"
        echo "Usage: latex <working_dir>"
        return 1
    end

    cd $WORKING_DIR

    if not tmux has-session -t latex_$PWD 2>/dev/null
        # New session for latex project and window for nvim
        tmux new-session -d -s latex_$PWD -n nvim
        tmux send-keys -t latex_$PWD:nvim nvim C-m
        tmux send-keys -t latex_$PWD:nvim ":NvimTreeFocus" C-m

        # New window for AI
        tmux new-window -t $dirname -n AI
        tmux send-keys -t $dirname:AI $AI C-m

        # New window for fish
        tmux new-window -t $dirname -n fish
        tmux send-keys -t $dirname:fish lt C-m

        # New window for zathura
        tmux new-window -t latex_$PWD -n zathura
        tmux send-keys -t latex_$PWD:zathura ls C-m

        # New window for latexmk
        tmux new-window -t latex_$PWD -n latexmk
        tmux send-keys -t latex_$PWD:latexmk "latexmk -pdf -pvc main.tex" C-m
    end
    # Start zathura
    # zathura main.pdf --fork
    tmux attach -t latex_$PWD:nvim
end
