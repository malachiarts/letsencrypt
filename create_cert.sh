#!/bin/sh

sudo certbot -d *.majustfortesting.com --manual --preferred-challenges dns certonly
