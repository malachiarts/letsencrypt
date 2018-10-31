#!/usr/bin/env bash

HOST=$1
# https://docs.aws.amazon.com/acm/latest/userguide/import-reimport.html#reimport-certificate-cli
# aws acm import-certificate --certificate file://Certificate.pem
                                 # --certificate-chain file://CertificateChain.pem
                                 # --private-key file://PrivateKey.pem
                                 # --certificate-arn arn:aws:acm:region:123456789012:certificate/12345678-1234-1234-1234-12345678901
#

DIR="/etc/letsencrypt/live/${HOST}"

CERT_ARN=`aws acm list-certificates | jq --arg host \*.${HOST} '.CertificateSummaryList[] | select(.DomainName==$host) | .CertificateArn' | sed -e 's/"//g'`
echo "CERT_ARN: $CERT_ARN"
sudo aws acm import-certificate --certificate file://${DIR}/cert.pem \
                           --certificate-chain file://${DIR}/chain.pem \
                           --private-key file://${DIR}/privkey.pem \
                           --certificate-arn "$CERT_ARN"
