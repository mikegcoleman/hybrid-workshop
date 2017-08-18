echo "Download the DTR CA certificate"
sudo curl -k https://$1/ca -o /usr/local/share/ca-certificates/$1.crt

echo "Refresh the list of certificates to trust"
sudo update-ca-certificates

echo "Restart the Docker daemon"
sudo service docker restart
