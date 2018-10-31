
These scripts help renew the majustfortesting.com certificates using
certbot/letsencrypt.

We first assume that you have AWS client install and configured.

When the certificate expires, you first run ./create_cert.sh. We verify
the certificate via DNS so you will have to update the DNS TXT record.
At this point, the script will pause, you will then run
add_txt_record_to_domain_for_verification.sh in a separate window with 
the hostname and given challenge response. Wait a little while (maybe a
minute or two) and go back to the original window and hit return to
continue. This will finish the process of renewing the certificate with
letsencrypt and you'll have the cert locally.

The last step is to run import_certificate_to_aws.sh. You just need to
pass it a hostname and it will find the cert on your local drive and
upload it to AWS.

1. ./create_cert.sh # *.majustfortesting.com is assumed.
2. ./add_txt_record_to_domain_for_verification.sh majustfortesting.com
   <CHALLENGE VALUE>
3. ./import_certificate_to_aws.sh majustfortesting.com
