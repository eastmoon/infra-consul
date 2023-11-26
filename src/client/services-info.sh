#!/bin/sh
set -e

## List all services in current node
echo ""
echo "> List all services in current node"
curl http://localhost:8500/v1/agent/services
echo ""

## Retrieve id "srv1" service information
echo ""
echo "> Retrieve id 'srv3' service information"
curl http://localhost:8500/v1/agent/service/srv3
echo ""

## Retrieve id "srv1" service health
echo ""
echo "> Retrieve id 'srv3' service health"
curl http://localhost:8500/v1/agent/health/service/id/srv3
echo ""

## Retrieve name 'internal-srv' service health
echo ""
echo "> Retrieve name "internal-srv" service health"
curl http://localhost:8500/v1/agent/health/service/name/internal-srv
echo ""
