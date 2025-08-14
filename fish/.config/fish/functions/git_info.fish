function git_info
    # get current branch or do nothing if its not a git repo
    set -l git_prompt (fish_git_prompt)
    if test -z "$git_prompt"
        return
    end

    # branch name, commits ahead/behind and stashs
    set -l git_status (git status --porcelain=v2 --branch 2>/dev/null)
    set -l commits (string match -r --groups '.*# branch.ab \+(\d+) -(\d+).*' -- "$git_status")
    set -l ahead (test -n "$commits[1]"; and test "$commits[1]" -gt 0; and echo " ↑$commits[1]")
    set -l behind (test -n "$commits[2]"; and test "$commits[2]" -gt 0; and echo " ↓$commits[2]")
    set -l stash (set -l c (git stash list | wc -l | string trim); and test $c -gt 0; and echo " *$c")
    set -l branch (printf '%s%s' (set_color green) (printf '%s%s%s%s' $git_prompt $ahead $behind $stash))

    # diffs
    set -l staged (set -l c (count (string match -ra '^1 [^.]' $git_status));
      and test $c -gt 0; and echo " +$c")
    set -l modified (set -l c (count (string match -ra '^1 \.M' $git_status));
      and test $c -gt 0; and echo " ~$c")
    set -l deleted (set -l c (count (string match -ra '^1 \.D' $git_status));
      and test $c -gt 0; and echo " -$c")
    set -l changes (printf '%s%s' (set_color yellow) (printf '%s%s%s' $staged $modified $deleted))

    set -l untracked (set -l c (count (string match -ra '^\? ' $git_status));
      and test $c -gt 0; and printf ' %s?%s' (set_color blue) $c)

    printf '%s%s%s' $branch $changes $untracked
end
