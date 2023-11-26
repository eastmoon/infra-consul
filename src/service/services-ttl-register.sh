#!/bin/sh
set -e

## Generate service configuration file
#!/bin/sh
set -e

## Generate service configuration file
cat << EOF > ~/api-services.json
{
  "id": "srv-ttl",
  "name": "demo",
  "check": {
    "name": "Shell TTL check demo",
    "notes": "Use shell to update TTL check API",
    "ttl": "5s"
  }
}
EOF

## Register service
apk add curl
curl \
    --request PUT \
    --data @$(echo ~/api-services.json) \
    http://consul-client-1:8500/v1/agent/service/register?replace-existing-checks=true
