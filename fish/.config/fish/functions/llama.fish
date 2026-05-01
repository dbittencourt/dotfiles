function __llama_models
    printf '%s\n' gemma qwen
end

function __llama_model_args --argument-names name
    switch "$name"
        case gemma
            printf '%s\n' \
                -m "$HOME/code/llama.cpp/models/personal/gemma-4-31B-it-UD-IQ3_XXS.gguf" \
                --temp 1.0 \
                --top-p 0.95 \
                --top-k 64

        case qwen
            printf '%s\n' \
                -m "$HOME/code/llama.cpp/models/personal/Qwen3.6-27B-UD-IQ3_XXS.gguf" \
                --temp 0.7 \
                --top-p 0.8 \
                --top-k 20

        case '*'
            return 2
    end
end

function __llama_pid_command --argument-names pid
    command ps -p "$pid" -o comm= 2>/dev/null | string trim
end

function __llama_is_server_pid --argument-names pid
    test "$(__llama_pid_command "$pid")" = llama-server
end

function __llama_stop_server --argument-names pid
    command kill "$pid"
    or return

    for attempt in (seq 1 20)
        command kill -0 "$pid" 2>/dev/null
        or return 0

        __llama_is_server_pid "$pid"
        or return 0

        sleep 0.1
    end

    __llama_is_server_pid "$pid"
    and return 1

    return 0
end

function llama
    set -l action "$argv[1]"
    set -l models (__llama_models)
    set -l host 127.0.0.1
    set -l port 8080
    set -l state_dir "$HOME/.local/state/llama.cpp"
    set -l pid_file "$state_dir/server.pid"
    set -l log_file "$state_dir/server.log"
    set -l usage "usage: llama start <"(string join '|' $models)"> [ctx] | llama stop"

    switch "$action"
        case start
            argparse --name 'llama start' --max-args 2 -- $argv[2..]
            or return

            set -l name "$argv[1]"
            set -l ctx "$argv[2]"

            if test -z "$name"
                echo "pick a model: "(string join ', ' $models)
                return 2
            end

            if test -z "$ctx"
                set ctx 32768
            else if not string match -qr '^[1-9][0-9]*$' -- "$ctx"
                echo "ctx must be a positive integer: $ctx"
                return 2
            end

            set -l model_args (__llama_model_args "$name")
            if test $status -ne 0
                echo "$name is not a valid option. pick: "(string join ', ' $models)
                return 2
            end

            set -l model "$model_args[2]"

            if not command -sq llama-server
                echo "llama-server not found in PATH"
                return 127
            end

            if not test -f "$model"
                echo "model file not found: $model"
                return 1
            end

            llama stop --quiet
            or return

            command mkdir -p "$state_dir"
            or return

            command nohup llama-server \
                $model_args \
                -ngl 999 \
                -c "$ctx" \
                --host "$host" \
                --port "$port" \
                --no-webui \
                --reasoning off \
                --reasoning-budget 0 \
                --chat-template-kwargs '{"enable_thinking":false}' \
                --min-p 0 \
                --alias "$name" >"$log_file" 2>&1 &

            set -l pid $last_pid
            printf '%s\n' "$pid" >"$pid_file"
            echo "llama-server started with $name, pid $pid"
            echo "api: http://$host:$port/v1"
            echo "log: $log_file"

        case stop
            argparse --name 'llama stop' --max-args 1 quiet -- $argv[2..]
            or return

            if test (count $argv) -gt 0
                echo "usage: llama stop [--quiet]"
                return 2
            end

            if not test -f "$pid_file"
                if not set -q _flag_quiet
                    echo "llama-server is not running"
                end

                return 0
            end

            read -l pid <"$pid_file"
            set pid (string trim -- "$pid")

            if test -z "$pid"; or not string match -qr '^[1-9][0-9]*$' -- "$pid"
                command rm -f "$pid_file"

                if not set -q _flag_quiet
                    echo "removed invalid pid file"
                end

                return 0
            end

            if not __llama_is_server_pid "$pid"
                command rm -f "$pid_file"

                if not set -q _flag_quiet
                    echo "llama-server is not running"
                end

                return 0
            end

            if not __llama_stop_server "$pid"
                echo "llama-server did not stop, pid $pid"
                return 1
            end

            command rm -f "$pid_file"

            if not set -q _flag_quiet
                echo "llama-server stopped"
            end

        case '*'
            echo "$usage"
            return 2
    end
end
