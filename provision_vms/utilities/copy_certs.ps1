param([string]$DTR_URL)

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class IDontCarePolicy : ICertificatePolicy {
        public IDontCarePolicy() {}
        public bool CheckValidationResult(
            ServicePoint sPoint, X509Certificate cert,
            WebRequest wRequest, int certProb) {
            return true;
        }
    }
"@

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

[System.Net.ServicePointManager]::CertificatePolicy = new-object IDontCarePolicy

Write-Host "`nDownloading DTR self-signed CA certificate from https://$DTR_URL/ca..."
Invoke-WebRequest -uri "https://$DTR_URL/ca" -o c:\ca.crt
Write-Host "done.`n"

Write-Host "Adding DTR self-signed CA certificate to the system's trust store..."
Import-Certificate c:\ca.crt -CertStoreLocation Cert:\LocalMachine\AuthRoot
Write-Host "done.`n"

Write-Host "Restart of Docker daemon not required on Windows; skipping...`ndone.`n"
