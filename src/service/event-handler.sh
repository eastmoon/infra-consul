#!/bin/sh
set -e

echo input : ${@}

##
tmpfile=~/.tmp.`date +%s`
curl http://consul-server-1:8500/v1/event/list > ${tmpfile}
echo Event : total $(jq length ${tmpfile})
echo Event latest :
jq '.[-1]' ${tmpfile}
echo Event payload message :
jq '.[-1].Payload' ${tmpfile} | sed -e 's/"//g' | base64 -d
echo ""
