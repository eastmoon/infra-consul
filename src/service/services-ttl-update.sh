#!/bin/sh
set -e

## call pass api
sleep 2s
echo "> Call TTL Pass"
curl \
    --request PUT \
    http://consul-client-1:8500/v1/agent/check/pass/service:srv-ttl

## call warn api
sleep 2s
echo "> Call TTL Warn"
curl \
    --request PUT \
    http://consul-client-1:8500/v1/agent/check/warn/service:srv-ttl

## call fail api
sleep 2s
echo "> Call TTL Fail"
curl \
    --request PUT \
    http://consul-client-1:8500/v1/agent/check/fail/service:srv-ttl

## call update api
sleep 2s
cat << EOF > ~/update-ttl.json
{
  "Status": "passing",
  "Output": "curl reported a failure:\n\n..."
}
EOF
echo "> Call TTL Update"
curl \
    --request PUT \
    --data @$(echo ~/update-ttl.json) \
    http://consul-client-1:8500/v1/agent/check/update/service:srv-ttl
