#!/bin/bash

set -e

# Download the DTR CA certificate
echo -e "\nDownloading DTR self-signed CA certificate from https://$1/ca..."
sudo curl -ksS https://"$1"/ca -o /usr/local/share/ca-certificates/"$1".crt
echo -e "done.\n"

# Refresh the list of certificates to trust
echo "Adding DTR self-signed CA certificate to the system's trust store..."
sudo update-ca-certificates
echo -e "\n"

# Restart the Docker daemon
echo "Restarting Docker daemon..."
sudo service docker restart
echo -e "done.\n"
