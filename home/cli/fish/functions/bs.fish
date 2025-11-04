function bs
    if test (count $argv) -eq 0
        echo "Usage: bs <server|proxy> [options]"
        return 1
    end

    set -l mode $argv[1]
    set -l browser_sync_args

    switch $mode
        case server s
            set browser_sync_args --server
            set -l remaining_args $argv[2..-1]
        case proxy p
            if test (count $argv) -lt 2
                echo "Missing proxy URL"
                return 1
            end
            set browser_sync_args "--proxy $argv[2]"
            set -l remaining_args $argv[3..-1]
        case '*'
            echo "Invalid mode: $mode. Use 'server/s or 'proxy/p'."
            return 1
    end

    set -l options (string join ' ' \
        'f/files=' \
        'h/host' \
    )
    argparse $options -- $remaining_args

    set -l files_glob "'*'"
    if set -q _flag_files
        set files_glob "'$_flag_files'"
    end

    set -l host_arg "--listen localhost"
    if set -q _flag_host
        set host_arg ""
    end

    set -l cmd "browser-sync start $browser_sync_args --files $files_glob $host_arg"
    eval $cmd
end
