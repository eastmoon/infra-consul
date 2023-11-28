#!/bin/sh
set -e

## put kv into consul by CLI
echo "> PUT kv by CLI"
consul kv put leaderboard/scores - << EOF
{
  "user-a": 100,
  "user-b": 250,
  "user-c": 75
}
EOF

## get kv by CLI
echo "> Get kv by CLI"
consul kv get leaderboard/scores

## get kv by API
echo "> Get kv information by API"
curl \
    --request GET \
    http://consul-client-1:8500/v1/kv/leaderboard/scores
echo "> Get kv value by API"
curl \
    --request GET \
    http://consul-client-1:8500/v1/kv/leaderboard/scores?raw
