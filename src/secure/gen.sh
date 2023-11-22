#!/bin/sh
set -e

#
[ -d /app/cache/certs ] && rm -rf /app/cache/certs
mkdir /app/cache/certs
[ -d /app/cache/config ] && rm -rf /app/cache/config
mkdir /app/cache/config

# Generate gossip encryption
CONSUL_GOSSIP_KEY=$(consul keygen)
cat << EOF > /app/cache/config/encrypt.json
{
    "encrypt": "${CONSUL_GOSSIP_KEY}"
}
EOF

# Generate TLS certificates file
cd /app/cache/certs
consul tls ca create
consul tls cert create -server -dc dc1
cat << EOF > /app/cache/config/tls-server.json
{
  "tls": {
    "defaults": {
      "ca_file": "/consul/certs/consul-agent-ca.pem",
      "cert_file": "/consul/certs/dc1-server-consul-0.pem",
      "key_file": "/consul/certs/dc1-server-consul-0-key.pem",
      "verify_incoming": true,
      "verify_outgoing": true,
      "verify_server_hostname": true
    }
  },
  "auto_encrypt": {
    "allow_tls": true
  },
  "ports": {
    "grpc_tls": -1
  }
}
EOF
cat << EOF > /app/cache/config/tls-client.json
{
  "tls": {
    "defaults": {
      "ca_file": "/consul/certs/consul-agent-ca.pem",
      "verify_incoming": false,
      "verify_outgoing": true,
      "verify_server_hostname": true
    }
  },
  "auto_encrypt": {
    "tls": true
  }
}
EOF
