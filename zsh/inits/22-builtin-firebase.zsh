function upp() {
    command upp | less -RFX
}

function ug() {
    grep "$@" <users.jsonl | upp
}
