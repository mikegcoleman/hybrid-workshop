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

invoke-webrequest -uri "https://$DTR_URL/ca" -o c:\ca.crt

$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 c:\ca.crt

$store = new-object System.Security.Cryptography.X509Certificates.X509Store('Root','localmachine')

$store.Open('ReadWrite')

$store.Add($cert)

$store.Close()
