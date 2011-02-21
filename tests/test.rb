$:.unshift File.expand_path("../../classes", __FILE__)
require 'Cert'
require 'Csr'
require 'Ca'

csr = Csr.new
csr.create_with_cert '-----BEGIN CERTIFICATE-----
MIIEEDCCAvigAwIBAgIFMUeG8mMwDQYJKoZIhvcNAQEFBQAwSDELMAkGA1UEBhMC
VVMxIDAeBgNVBAoTF1NlY3VyZVRydXN0IENvcnBvcmF0aW9uMRcwFQYDVQQDEw5T
ZWN1cmVUcnVzdCBDQTAeFw0xMDA4MjQxNDEwMDJaFw0xMzA4MjMxNDEwMDJaMFwx
CzAJBgNVBAYTAlVTMREwDwYDVQQIEwhJbGxpbm9pczEQMA4GA1UEBxMHQ2hpY2Fn
bzEUMBIGA1UEChMLUGF1bCBLZWhyZXIxEjAQBgNVBAMTCWxhbmd1aS5zaDCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMMdaJzUD0I8PRwbK6c3y7Wl+PtP
IHN5eawaNFWZAVWd/wRZt9MNl4BzVtGYPldPzaC4sdcEDC7YyB+31nVDWVETa3Jw
LnFZ1lcCrfydeQh2IfXkoH7boRMmqqSYxlHNSijTb7HYYIMb5sekM742v3nQ4Muh
lDWrgmOrxQiNEp2w0rj0qeM9jeJP4S1TPN6CJZohR4KdFSZYLGTSGZNNtbzbUXHl
30Ou6Tg+K9HpAWJ9KB+sYmL4wsxnW9ZC4AHppOY2dx3BVy91RuEE4nCI1ZfGh3Vn
R80hy0IBYjoupnm6efwVCdHlHnwM81tlLAD7BG+syVYyKJ5H+y10XtbXOssCAwEA
AaOB7DCB6TAJBgNVHRMEAjAAMB0GA1UdDgQWBBQAjd1USmQruNPPCOSePFXkZP4E
4DAfBgNVHSMEGDAWgBRCMrYW+gT9/l1LesP990xAHVpDrzALBgNVHQ8EBAMCBaAw
EwYDVR0lBAwwCgYIKwYBBQUHAwEwNAYDVR0fBC0wKzApoCegJYYjaHR0cDovL2Ny
bC5zZWN1cmV0cnVzdC5jb20vU1RDQS5jcmwwRAYDVR0gBD0wOzA5BgxghkgBhv1k
AQECAwEwKTAnBggrBgEFBQcCARYbaHR0cDovL3NzbC50cnVzdHdhdmUuY29tL0NB
MA0GCSqGSIb3DQEBBQUAA4IBAQCp6++bP8QfrJ9W1usAmDcIZu+PVp/wux0OSXf5
2I4m44NAwT20yevWxnqzF2JZ/R2mCi41sPbV6Uvk+/6YWezSdTFPGPNZ1mwuQ7Bu
BZB3DR71BJTP/YUOD6uWOFSh8didm3kHNbAvG4X/xWyj07n70Cof0PBDGtw8QKlt
CBydpPHBeew14n0PXXLB8jrDd6PtlKvKWrLVs9igASBuW584chaWNw039zxRKoqq
PsMwIw+1he4Bax4hH4fM4wQOFpnhk5Y34VmdZqo1JtF7Vn41ghGwsXVswvl6wPC1
g4+GUUwJtQ6cJyMmN4sIHDbCFTOWBlUijvMrvl3wxncqDmOp
-----END CERTIFICATE-----', 2048, ['langui.sh','victoly.com','victoly.com','ssl.trustwave.com']
puts Ca::sign_cert csr,'test_ca','server',nil,['langui.sh']
puts Ca::sign_cert csr,'test_ca','server',[['CN','someotherdomain.com']],['langui.sh']
=begin
csr = Csr.new
csr.create_csr_with_subject([['CN','langui.sh'],['ST','Illinois'],['L','Chicago'],['C','US'],['emailAddress','ca@langui.sh']])
puts csr.to_pem
csr = Csr.new
csr.create_csr_with_subject([['serialNumber','3939737'],['1.3.6.1.4.1.311.60.2.1.3','US'],['1.3.6.1.4.1.311.60.2.1.2','Delaware'],['2.5.4.15','V1.0, Clause 5.(d)'],['C','US'],['ST','Illinois'],['L','Chicago'], ['O','Trustwave Holdings, Inc.'],['CN','ssl.trustwave.com']])
puts csr.to_pem
create_with_cert '-----BEGIN CERTIFICATE-----
MIIEwjCCA6qgAwIBAgIFMUeGxxIwDQYJKoZIhvcNAQEFBQAwSDELMAkGA1UEBhMC
VVMxIDAeBgNVBAoTF1NlY3VyZVRydXN0IENvcnBvcmF0aW9uMRcwFQYDVQQDEw5T
ZWN1cmVUcnVzdCBDQTAeFw0wOTEwMzAxNjI0NTdaFw0xMjAxMjgxNjI0NTdaMIHQ
MRAwDgYDVQQFEwczOTM5NzM3MRMwEQYLKwYBBAGCNzwCAQMTAlVTMRkwFwYLKwYB
BAGCNzwCAQITCERlbGF3YXJlMRswGQYDVQQPExJWMS4wLCBDbGF1c2UgNS4oZCkx
CzAJBgNVBAYTAlVTMREwDwYDVQQIEwhJbGxpbm9pczEQMA4GA1UEBxMHQ2hpY2Fn
bzEhMB8GA1UEChMYVHJ1c3R3YXZlIEhvbGRpbmdzLCBJbmMuMRowGAYDVQQDExFz
c2wudHJ1c3R3YXZlLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AL+BD3uS2rGvK0/d4Rfv7vo04rcG9INMn57aYyrZy9l6xJ/1vs/yFSTn0JrqPV86
YpbVIdrap8Qt7uxYyRs1aVk28TZfDnM0qJrZ6DzleT56tFnLKy2zZ5Fdf2WjQuGw
clJ/Gf8lkgEF/XaqY43AFNlruE88CrFpAfWfNBO1cQNP1YLSHW6laaUOLgv8t1M8
/uCKu6Bt4No9ZAweBupbIKk0RN5Xtg28naIFCslsAujIZctLJyc4NGyCeHk/QOoU
txo+fVlF2APSnCKWP7sdmRR+4fkLMwvlo5ArVQeFTf+y7+8DFbY5CVjChoBl6sIX
FmINmCceXCP4srBKzrj7lgECAwEAAaOCASgwggEkMAwGA1UdEwEB/wQCMAAwHwYD
VR0jBBgwFoAUQjK2FvoE/f5dS3rD/fdMQB1aQ68wHQYDVR0OBBYEFNhfgXpmXBwi
/Pk4fpitQTJtFSvzMAsGA1UdDwQEAwIFoDATBgNVHSUEDDAKBggrBgEFBQcDATA0
BgNVHR8ELTArMCmgJ6AlhiNodHRwOi8vY3JsLnNlY3VyZXRydXN0LmNvbS9TVENB
LmNybDA2BggrBgEFBQcBAQQqMCgwJgYIKwYBBQUHMAGGGmh0dHA6Ly9vY3NwLnRy
dXN0d2F2ZS5jb20vMEQGA1UdIAQ9MDswOQYMYIZIAYb9ZAEBAgQBMCkwJwYIKwYB
BQUHAgEWG2h0dHA6Ly9zc2wudHJ1c3R3YXZlLmNvbS9DQTANBgkqhkiG9w0BAQUF
AAOCAQEAGVmORKcYMtxHeIZf4zauvMImijnMh1O2FWaUBDXbylDNFjI3PUH9Gomh
g23DBv/VcShxAvD3z22TQlDosoO4mnFp/bMxqwN/hoIHELG9HeHSUs/zCltNWNgS
tzisYpJDGHU1YTc4U/ZeMWV/Dmv1Bt4gIk/ecnJyRSyq8Qp5pbz6eCxoCeBe9EOR
DAAjNpyRb9HnQe1oMM908CtsDo9cwQqrpMWJVufRUHU3TnDxlQB8AeAuIwBiyXFO
PN/d/qjcvBPeNHj1E9QHn1t6PbgLzb398Oc8NVIq4bA0X9PV1kJDs/4R7H4D7QbI
wLaJSZZBpGDcPm/ak7is8kZy3CVs9A==
-----END CERTIFICATE-----', 1024
create_with_cert '-----BEGIN CERTIFICATE-----
MIID3jCCAsagAwIBAgIQWBfAIo0YFQAEOjrbmfO2GTANBgkqhkiG9w0BAQUFADBk
MQswCQYDVQQGEwJVUzERMA8GA1UECBMISWxsaW5vaXMxEDAOBgNVBAcTB0NoaWNh
Z28xEjAQBgNVBAoTCVRydXN0d2F2ZTEcMBoGA1UEAxMTVHJ1c3R3YXZlIFNUQ0Eg
VGVzdDAeFw0xMTAyMTYxNjQ1MzlaFw0xMjAyMTYxNzQ0MDRaMGQxGTAXBgNVBAMT
EHZpa2luZ2hhbW1lci5jb20xEDAOBgNVBAcTB0NoaWNhZ28xETAPBgNVBAgTCEls
bGlub2lzMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMVmlraW5naGFtbWVyMIGfMA0G
CSqGSIb3DQEBAQUAA4GNADCBiQKBgQCZiQy7eIsZvggLaG8ssgtp895ee+yvzzT/
BxXJ8DLgw2ek9AMjAZa0bmv43kEUdbml9w8Q3qGMlhxTnsygY/mShXIw/jgiENbW
vOLuuHHCvBoEgN0XKZS2G3szEGZLm030NK2n3HQtBEZCJ1+VY25/ubTRNli89Q1q
9tDBlo8w8QIDAQABo4IBDjCCAQowCQYDVR0TBAIwADAdBgNVHQ4EFgQUimYraAuu
/PGLqkTzey4HG2YIzjcwCwYDVR0PBAQDAgWgMBMGA1UdJQQMMAoGCCsGAQUFBwMB
MDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwuc2VjdXJldHJ1c3QuY29tL1NU
Q0EuY3JsMEQGA1UdIAQ9MDswOQYMYIZIAYb9ZAEBAgMBMCkwJwYIKwYBBQUHAgEW
G2h0dHA6Ly9zc2wudHJ1c3R3YXZlLmNvbS9DQTBABgNVHREEOTA3ghB2aWtpbmdo
YW1tZXIuY29tghR3d3cudmlraW5naGFtbWVyLmNvbYINZmlyZWdhcmR5LmNvbTAN
BgkqhkiG9w0BAQUFAAOCAQEAY4PRDnwn0sjzNi9r4UE9VEwE8oM1jB70J5Dz5AF9
HMW6v8oqWi569sW6jizZEUxD0YFLoT+5Qijqg009q+R8xUkBtgw65EyYBBQj0OF6
alVAkDLxL74EY0owt5eHQ4janFUHXm/4//gO+XEfwgU4w49FlDCfJazzid65wRek
6Zbkx5JKvLEEDf1c7O3a4hCF4cNMz04plZZKxPwqiRI+e478qFOc3L4esnUQcest
mF3S1f6vdNHmpi+ZXA3jqkJ53Y1/cmFKmRd9R3UVs0iVPjfM3BBtr7CD/7xeKemb
69Kqv+HoQnih/sfVUC8+gI19GKLvrzSKNf6oN9cD4Sq7rQ==
-----END CERTIFICATE-----', 2048
=end
