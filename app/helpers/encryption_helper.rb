module EncryptionHelper
  require 'encryptor'
  
  def key(secret)
    Digest::SHA256.hexdigest( APP_KEY + secret )
  end

  def encrypt(secret, body)
    Encryptor.encrypt( :value => body, :key => key(secret) )
  end

  def decrypt(secret, body)
    Encryptor.decrypt( :value => body, :key => key(secret) )
  end
end