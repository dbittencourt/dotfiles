function git_info
    # do nothing if not in a git repo
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$git_root"
        return
    end

    # return cached information if new prompt is less than 5 seconds away
    set -l now (date +%s)
    if test "$g_git_info_cache_dir" = "$PWD"; and test -n "$g_git_info_cache_timestamp";
        and test (math "$now - $g_git_info_cache_timestamp") -lt 2; and set -q g_git_info_cache
        printf '%s' $g_git_info_cache
        return
    end

    set -l git_prompt (fish_git_prompt)
    if test -z "$git_prompt"
        return
    end

    set -l git_status (git status --porcelain=v2 --branch 2>/dev/null)
    set -l commits (string match -r --groups '.*# branch.ab \+(\d+) -(\d+).*' -- "$git_status")
    set -l ahead (test -n "$commits[1]"; and test "$commits[1]" -gt 0; and echo " ↑$commits[1]")
    set -l behind (test -n "$commits[2]"; and test "$commits[2]" -gt 0; and echo " ↓$commits[2]")
    set -l stash_file "$git_root/.git/logs/refs/stash"
    set -l stash (test -e $stash_file; and set -l c (count (cat $stash_file)); and test $c -gt 0; and echo " *$c")
    set -l branch (printf '%s%s' (set_color green) (printf '%s%s%s%s' $git_prompt $ahead $behind $stash))

    set -l staged (set -l c (count (string match -ra '^[12] [^.]' $git_status));
      and test $c -gt 0; and echo " +$c")
    set -l modified (set -l c (count (string match -ra '^1 \.M' $git_status));
      and test $c -gt 0; and echo " ~$c")
    set -l deleted (set -l c (count (string match -ra '^1 \.D' $git_status));
      and test $c -gt 0; and echo " -$c")
    set -l changes (printf '%s%s' (set_color yellow) (printf '%s%s%s' $staged $modified $deleted))

    set -l untracked (set -l c (count (string match -ra '^\? ' $git_status));
      and test $c -gt 0; and printf ' %s?%s' (set_color blue) $c)

    set -g g_git_info_cache (printf '%s%s%s' $branch $changes $untracked)
    set -g g_git_info_cache_dir "$PWD"
    set -g g_git_info_cache_timestamp $now

    printf '%s' $g_git_info_cache
end
