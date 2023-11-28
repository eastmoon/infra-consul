#!/bin/sh
set -e

## Register watch
consul watch -type=event -name=ev ${PWD}/event-handler.sh call-ev
