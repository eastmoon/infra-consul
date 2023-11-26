#!/bin/sh
set -e

## Generate service configuration file
cat << EOF > ~/api-services.json
{
  "id": "srv3",
  "name": "demo",
  "port": 80,
  "check": {
    "name": "ping check",
    "args": ["ping", "-c1", "consul-service-nginx"],
    "interval": "10s",
    "status": "passing"
  }
}
EOF


## Register service
curl \
    --request PUT \
    --data @$(echo ~/api-services.json) \
    http://localhost:8500/v1/agent/service/register?replace-existing-checks=true
