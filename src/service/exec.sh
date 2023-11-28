#!/bin/sh
set -e

##
echo "> Exec a command at node id 'client-2'"
consul exec -node client-2 "cat /etc/os-release"

##
echo "> Exec a command at service id 'srv1'"
consul exec -service srv1 "cat /etc/os-release"
