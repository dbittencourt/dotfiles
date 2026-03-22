function fish_prompt
    # sets the arrow green or red if the previous command return an error 
    set -l last_status $status
    set -l arrow (printf ' %s❯ ' (set_color (if test $last_status -eq 0; echo green; else; echo red; end)))

    set -l pwd (printf '%s%s' (set_color blue) (prompt_pwd))

    # git prompt
    set -g __fish_git_prompt_show_informative_status true
    set -g __fish_git_prompt_showstashstate true
    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_showuntrackedfiles true
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_showcolorhints true
    set -g __fish_git_prompt_char_stateseparator " "
    set -g __fish_git_prompt_char_stagedstate "+"
    set -g __fish_git_prompt_char_stateseparator " "
    set -g __fish_git_prompt_color_prefix green
    set -g __fish_git_prompt_color_suffix green

    printf '%s%s%s' $pwd (fish_git_prompt) $arrow
end
