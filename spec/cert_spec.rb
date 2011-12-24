require 'spec_helper'

describe R509::Cert do
    before :all do
        @cert = TestFixtures::CERT
        @cert_public_key_modulus = TestFixtures::CERT_PUBLIC_KEY_MODULUS
        @cert3 = TestFixtures::CERT3
        @cert_der = TestFixtures::CERT_DER
        @cert_san = TestFixtures::CERT_SAN
        @key3 = TestFixtures::KEY3
        @cert4 = TestFixtures::CERT4
        @cert5 = TestFixtures::CERT5
        @cert6 = TestFixtures::CERT6
    end
    it "raises exception when no hash supplied" do
        expect { R509::Cert.new('no hash')}.to raise_error(ArgumentError, 'Must provide a hash of options')
    end
    it "raises exception when no :cert supplied" do
        expect { R509::Cert.new(:key => "random")}.to raise_error(ArgumentError, 'Must provide :cert')
    end
    it "has a public_key" do
        cert = R509::Cert.new(:cert => @cert)
        #this is more complex than it should have to be. diff versions of openssl
        #return subtly diff PEM encodings so we need to look at the modulus (n)
        #but beware, because n is not present for DSA certificates
        cert.public_key.n.to_i.should == @cert_public_key_modulus.to_i
    end
    it "returns bit strength" do
        cert = R509::Cert.new(:cert => @cert)
        cert.bit_strength.should == 2048
    end
    it "has the right issuer" do
        cert = R509::Cert.new(:cert => @cert)
        cert.issuer.to_s.should == "/C=US/O=SecureTrust Corporation/CN=SecureTrust CA"
    end
    it "returns true from has_private_key? when a key is present" do
        cert = R509::Cert.new(:cert => @cert3, :key => @key3)
        cert.has_private_key?.should == true
    end
    it "returns false from has_private_key? when a key is not present" do
        cert = R509::Cert.new(:cert => @cert)
        cert.has_private_key?.should == false
    end
    it "has the right not_before" do
        cert = R509::Cert.new(:cert => @cert)
        cert.not_before.to_i.should == 1282659002
    end
    it "has the right not_after" do
        cert = R509::Cert.new(:cert => @cert)
        cert.not_after.to_i.should == 1377267002
    end
    it "fetches a subject component" do
        cert = R509::Cert.new(:cert => @cert)
        cert.subject_component('CN').should == 'langui.sh'
    end
    it "returns nil when subject component not found" do
        cert = R509::Cert.new(:cert => @cert)
        cert.subject_component('OU').should be_nil
    end
    it "returns signature algorithm" do
        cert = R509::Cert.new(:cert => @cert)
        cert.signature_algorithm.should == 'sha1WithRSAEncryption'
    end
    it "returns the RSA key algorithm" do
        cert = R509::Cert.new(:cert => @cert)
        cert.key_algorithm.should == 'RSA'
    end
    it "returns the DSA key algorithm" do
        cert = R509::Cert.new(:cert => @cert6)
        cert.key_algorithm.should == 'DSA'
    end
    it "returns list of san_names when it is a san cert" do
        cert = R509::Cert.new(:cert => @cert_san)
        cert.san_names.should == ['langui.sh']
    end
    it "returns an empty list when it is not a san cert" do
        cert = R509::Cert.new(:cert => @cert)
        cert.san_names.should == nil
    end
    it "raises exception when providing invalid cert" do
        expect { R509::Cert.new(:cert => "invalid cert") }.to raise_error(OpenSSL::X509::CertificateError)
    end
    it "raises exception when providing invalid key" do
        expect { R509::Cert.new(:cert => @cert, :key => 'invalid key') }.to raise_error(R509::R509Error, 'Failed to load private key. Invalid key or incorrect password.')
    end
    it "raises exception on non-matching key" do
        expect { R509::Cert.new(:cert => @cert, :key => @key3) }.to raise_error(R509::R509Error, 'Key does not match cert.')
    end
    it "return normal object on matching key/cert pair" do
        expect { R509::Cert.new(:cert => @cert3, :key => @key3) }.to_not raise_error
    end
    it "writes to pem" do
        cert = R509::Cert.new(:cert => @cert)
        sio = StringIO.new
        sio.set_encoding("BINARY") if sio.respond_to?(:set_encoding)
        cert.write_pem(sio)
        sio.string.should == @cert + "\n"
    end
    it "writes to der" do
        cert = R509::Cert.new(:cert => @cert)
        sio = StringIO.new
        sio.set_encoding("BINARY") if sio.respond_to?(:set_encoding)
        cert.write_der(sio)
        sio.string.should == @cert_der
    end
    it "parses san extension" do
        cert = R509::Cert.new(:cert => @cert_san)
        cert.san_names.should == ["langui.sh"]
    end
    context "when initialized with an OpenSSL::X509::Certificate" do
        it "returns pem on to_pem" do
            test_cert = OpenSSL::X509::Certificate.new(@cert)
            cert = R509::Cert.new(:cert => test_cert)
            cert.to_pem.should == @cert
        end
        it "returns der on to_der" do
            test_cert = OpenSSL::X509::Certificate.new(@cert)
            cert = R509::Cert.new(:cert => test_cert)
            cert.to_der.should == @cert_der
        end
        it "returns pem on to_s" do
            test_cert = OpenSSL::X509::Certificate.new(@cert)
            cert = R509::Cert.new(:cert => test_cert)
            cert.to_s.should == @cert
        end
    end
    context "when initialized with a pem" do
        it "returns on to_pem" do
            cert = R509::Cert.new(:cert => @cert)
            cert.to_pem.should == @cert
        end
        it "returns der on to_der" do
            cert = R509::Cert.new(:cert => @cert)
            cert.to_der.should == @cert_der
        end
        it "returns pem on to_s" do
            cert = R509::Cert.new(:cert => @cert)
            cert.to_s.should == @cert
       end
    end
    it "gets key usage from the extensions array" do
        cert = R509::Cert.new(:cert => @cert)
        cert.extensions["keyUsage"].count.should == 1
        cert.extensions["keyUsage"][0]["value"].should == "Digital Signature, Key Encipherment"
    end
    it "gets key usage from #key_usage" do
        cert = R509::Cert.new(:cert => @cert)
        cert.key_usage.should == ["Digital Signature", "Key Encipherment"]
    end
    it "handles lack of key usage" do
        cert = R509::Cert.new(:cert => @cert4)
        cert.key_usage.should == []
    end
    it "gets extended key usage from the extensions array" do
        cert = R509::Cert.new(:cert => @cert)
        cert.extensions["extendedKeyUsage"].count.should == 1
        cert.extensions["extendedKeyUsage"][0]["value"].should == "TLS Web Server Authentication"
    end
    it "get extended key usage from #extended_key_usage" do
        cert = R509::Cert.new(:cert => @cert)
        cert.extended_key_usage.should == ["TLS Web Server Authentication"]
    end
    it "handles lack of extended key usage" do
        cert = R509::Cert.new(:cert => @cert4)
        cert.extended_key_usage.should == []
    end
    it "handles multiple extended key usages" do
        cert = R509::Cert.new(:cert => @cert5)
        cert.extended_key_usage.should == ["TLS Web Server Authentication","TLS Web Client Authentication","Microsoft Server Gated Crypto"]
    end

    it "checks rsa?" do
        cert = R509::Cert.new(:cert => @cert)
        cert.rsa?.should == true
        cert.dsa?.should == false
    end
    it "gets RSA bit strength" do
        cert = R509::Cert.new(:cert => @cert)
        cert.bit_strength.should == 2048
    end
    it "checks dsa?" do
        cert = R509::Cert.new(:cert => @cert6)
        cert.rsa?.should == false
        cert.dsa?.should == true
    end
    it "gets DSA bit strength" do
        cert = R509::Cert.new(:cert => @cert6)
        cert.bit_strength.should == 1024
    end
    it "gets serial of cert" do
        cert = R509::Cert.new(:cert => @cert6)
        cert.serial.should == 951504
    end
end
