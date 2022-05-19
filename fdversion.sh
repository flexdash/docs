#! /bin/bash
while true; do
    date
    curl -s https://flows.nodered.org/node/@flexdash/node-red-flexdash | \
        egrep flow-title
    curl -s https://catalogue.nodered.org/catalogue.json | \
        jq '.modules[] | select(.id == "@flexdash/node-red-flexdash") | .id, .version'
    sleep 30
done
