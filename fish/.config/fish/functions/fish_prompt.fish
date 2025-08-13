function fish_prompt
    # sets the arrow green or red if the previous command return an error 
    set -l arrow (printf ' %s❯ ' (set_color (if test $status -eq 0; echo green; else; echo red; end)))

    set -l pwd (printf '%s%s' (set_color blue) (prompt_pwd))

    set -l duration ''
    if set -q CMD_DURATION; and test $CMD_DURATION -gt 100
        set duration (printf ' %s(%ss)' (set_color yellow) (math --scale=2 "$CMD_DURATION / 1000"))
    end

    printf '%s%s%s%s' $pwd (git_info) $duration $arrow
end
