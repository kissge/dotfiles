function export-dotenv() {
    local dotenv=${1:-./.env}

    if [ ! -f "$dotenv" ]; then
        echo "No such file: $dotenv"
        return 1
    fi

    exports=$(diff --old-line-format="" --new-line-format="%L" --unchanged-line-format="" \
        <(env -i bash --noprofile --norc -c 'declare -p') \
        <(env -i bash --noprofile --norc -c '. "'"${dotenv}"'" && declare -p') |
        if "${SHELL:-$0}" --version | grep -qF 'GNU bash, version 3'; then
            sed -e 's/^/export /'
        else
            sed -E 's/^(declare( -- ?)?)?/declare -g -x /'
        fi |
        grep -v ' \(BASH_ARGC\|BASH_EXECUTION_STRING\|PIPESTATUS\|_\|PPID\)=')

    eval "${exports}"

    echo "Read ${dotenv} and exported the following:"
    echo "${exports}"
}
