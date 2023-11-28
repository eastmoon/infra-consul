#!/bin/sh
set -e

## trigger event
consul event -name=ev `date +%s`
