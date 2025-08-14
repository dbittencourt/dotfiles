function fish_prompt
    # sets the arrow green or red if the previous command return an error 
    set -l arrow (printf ' %s❯ ' (set_color (if test $status -eq 0; echo green; else; echo red; end)))

    set -l pwd (printf '%s%s' (set_color blue) (prompt_pwd))

    printf '%s%s%s' $pwd (git_info) $arrow
end
