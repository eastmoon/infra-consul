#!/bin/sh
set -e

## Generate service configuration file
cat << EOF > ~/cli-services.json
{
  "services": [
    {
      "id": "srv2",
      "name": "demo",
      "port": 80,
      "check": {
        "name": "tcp to 80",
        "tcp": "consul-service-nginx:80",
        "interval": "10s",
        "timeout": "1s"
      }
    }
  ]
}
EOF

## Register service
consul services register ~/cli-services.json
