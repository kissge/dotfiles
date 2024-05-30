if [ ! -f ~/.line-api-token ] && yesno 'Set ~/.line-api-token up by pasting?'; then
    read -srp 'Paste your token file content: ' token
    echo "$token" > ~/.line-api-token
    chmod 600 ~/.line-api-token
fi
