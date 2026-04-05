function fontsearch
    fc-list \
        | grep -ioE ": [^:]*$argv[1][^:]+:" \
        | sed -E 's/(^: |:)//g' \
        | tr , \\n \
        | sort \
        | uniq
end