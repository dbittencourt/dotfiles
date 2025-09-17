function livegrep
    # check if query is non-empty before calling rg
    set -l reload_cmd 'if test -n "{q}"; rg --hidden --line-number --no-heading --color=always --smart-case {q} .; end'

    fzf --ansi --reverse --query "$argv" \
        --bind "start:reload:$reload_cmd" \
        --bind "change:reload:$reload_cmd" \
        --preview 'bat --style=plain --color=always --highlight-line {2} {1}' \
        --delimiter ':' \
        --bind 'enter:execute(nvim {1} +{2})'
end

