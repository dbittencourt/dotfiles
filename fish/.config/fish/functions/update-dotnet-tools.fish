function update-dotnet-tools
    if not command -sq dotnet
        echo "dotnet not found in PATH" >&2
        return 127
    end

    set -l tools (command dotnet tool list --global)
    or return
    set -a tools ""

    if string match --quiet --regex '^roslyn-language-server[[:space:]]' -- $tools
        command dotnet tool update --global roslyn-language-server --prerelease
        or return
    else
        command dotnet tool install --global roslyn-language-server --prerelease
        or return
    end

    if string match --quiet --regex '^csharpier[[:space:]]' -- $tools
        command dotnet tool update --global csharpier
        or return
    else
        command dotnet tool install --global csharpier
        or return
    end
end
