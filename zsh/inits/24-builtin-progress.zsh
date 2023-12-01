function foreach-line() {
    local file=$1
    shift
    local i=0

    (
        wc -l "$file" >&3
        while read -r line; do
            "$@" "$line" || {
                echo "Command failed:" "$@" "$line" >&2
                exit 1
            }
            echo $((++i)) >&3
        done < "$file"
    ) 3> >(progress)
}

function foreach-file() {
    local cmd=$1
    shift
    local i=0

    (
        echo $# >&3
        for file; do
            "$cmd" "$file" || {
                echo "Command failed:" "$cmd" "$file" >&2
                exit 1
            }
            echo $((++i)) >&3
        done
    ) 3> >(progress)
}
