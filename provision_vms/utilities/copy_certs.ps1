param([string]$DTR_URL)

Write-Host "`nDownloading DTR self-signed CA certificate from https://$DTR_URL/ca..."
Invoke-WebRequest -uri "https://$DTR_URL/ca" -o c:\ca.crt
Write-Host "done.`n"

Write-Host "Adding DTR self-signed CA certificate to the system's trust store..."
Import-Certificate c:\ca.crt -CertStoreLocation Cert:\LocalMachine\AuthRoot
Write-Host "done.`n"

Write-Host "Restart of Docker daemon not required on Windows; skipping...`ndone.`n"
