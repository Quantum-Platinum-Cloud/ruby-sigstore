require "rubygems/sigstore/cert_chain"

module Gem::Sigstore::Rekor::Signature
  def signature
    @signature ||= begin
      signature = Base64.decode64(body.dig("spec", "signature", "content"))
      raise "Expecting a signature in #{body}" unless signature
      signature
    end
  end

  def cert_chain
    Gem::Sigstore::CertChain.new(cert)
  end

  def signer_email
    cert_chain.signing_cert.subject_alt_name
  end

  def signer_public_key
    cert_chain.signing_cert.public_key
  end

  private

  def cert
    @cert ||= begin
      cert = Base64.decode64(body.dig("spec", "signature", "publicKey", "content"))
      raise "Expecting a publicKey in #{body}" unless cert
      cert
    end
  end
end
