#!/bin/bash -u

FORM="Content-Type: application/x-www-form-urlencoded"
NOW=$(date -R)

#get these from the Duo Admin interface
INT="DIFL7MGV8XGGSFFT77YK"
KEY="aG5qjeloKgt8jKpFNJR7N7Q2vlYblWSVHGvSvMpf"
API="api-7a2d8e99.duosecurity.com"

URL="/auth/v2/check"
REQ="$NOW\nGET\n$API\n$URL\n"

#could also use awk here, or the --binary mode as suggested elsewhere
HMAC=$(echo -n "$REQ" | openssl sha1 -hmac "$KEY" | cut -d" " -f 2)

AUTH=$(echo -n "$INT:$HMAC" | base64 -w0)

curl -s -H "Date: $NOW" -H $FORM -H "Authorization: Basic $AUTH" https://$API$URL
