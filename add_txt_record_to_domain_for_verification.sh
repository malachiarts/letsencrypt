#!/usr/bin/env bash

#
# Adds TXT record to your DNS entry in AWS for letsencrypt verification.
#
# https://docs.aws.amazon.com/cli/latest/reference/route53/change-resource-record-sets.html

HOST=$1
VALUE=$2

IFS='' read -r -d '' JSON <<EOF
{
  "Comment": "SSL Certification Renewal Verification",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "_acme-challenge.${HOST}",
        "Type": "TXT",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "\"${VALUE}\""
          }
          ]
        }
      }
      ]
}
EOF

echo "$JSON" | tee /tmp/txt_record_update.json
# Yes, you need that '.' after the hostname.
ZONE_ID=`aws route53 list-hosted-zones | jq --arg host ${HOST}. '.HostedZones[] | select(.Name==$host) | .Id' | tr -d \" | tr -d '\n' | awk -F/ '{print $3}'`
echo $ZONE_ID

aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file:///tmp/txt_record_update.json
