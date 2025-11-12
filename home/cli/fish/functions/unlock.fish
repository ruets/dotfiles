function unlock
    if test (count $argv) -ne 1
        echo "Usage: unlock <locker_binary_path>"
        return 1
    end

    set -l locker_binary $argv[1]

    echo "Attempting to unlock system..."
    hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
    hyprctl --instance 0 "dispatch exec $locker_binary"
    echo "Unlock commands sent. Please check your display."
end
