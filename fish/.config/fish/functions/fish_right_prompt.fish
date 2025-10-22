function fish_right_prompt
    if not set -q CMD_DURATION; or test $CMD_DURATION -le 100
        return
    end

    set -l seconds (math "$CMD_DURATION / 1000")

    if test $seconds -ge 3600
        printf '%s(%dh %dm) ' (set_color yellow) (math -s0 "$seconds / 3600") (math -s0 "($seconds % 3600) / 60")
    else if test $seconds -ge 60
        printf '%s(%dm %ds) ' (set_color yellow) (math -s0 "$seconds / 60") (math -s0 "$seconds % 60")
    else
        printf '%s(%.2fs) ' (set_color yellow) $seconds
    end
end