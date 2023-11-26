#!/bin/sh
set -e

## Generate service configuration file
cat << EOF > ~/cli-services.json
{
  "services": [
    {
      "id": "srv2",
      "name": "internal-srv",
      "port": 80,
      "check": {
        "name": "ping check",
        "args": ["ping", "-c1", "consul-service-nginx"],
        "interval": "10s",
        "status": "passing"
      }
    }
  ]
}
EOF

## Register service
consul services register ~/cli-services.json
