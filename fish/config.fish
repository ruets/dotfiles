if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_key_bindings fish_vi_key_bindings

#set PATH $PATH:/usr/lib/ruby/gems/3.0.0:/home/ruets/.local/share/gem/ruby/3.0.0
set PATH /home/ruets/.local/bin/:/home/ruets/.jdks/openjdk-21.0.2/platform-tools:$PATH
#starship preset nerd-font-symbols
starship init fish | source
