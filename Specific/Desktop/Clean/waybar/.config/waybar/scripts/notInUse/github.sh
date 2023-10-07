#!/bin/bash

count=`curl -u ${GITHUB_USERNAME}:${GITHUB_NOTIFICATION_KEY} https://api.github.com/notifications | jq '. | length'`

if [[ "$count" != "0" ]]; then
    echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
fi
