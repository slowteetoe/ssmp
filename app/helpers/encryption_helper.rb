module EncryptionHelper
  require 'encryptor'
  require "base64"

  def key(secret)
    Digest::SHA256.hexdigest( ENV['SSMP_APP_KEY'] + secret )
  end

  def encrypt(secret, body)
    Base64.encode64( Encryptor.encrypt( :value => body, :key => key(secret)) )
  end

  def decrypt(secret, body)
    Encryptor.decrypt( :value => Base64.decode64(body), :key => key(secret) )
  end
end
