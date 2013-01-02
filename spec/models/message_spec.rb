require 'spec_helper'

describe "Messages" do
  it "should decrypt a message" do
    secret = "blah"
    message = "this is the body"
    encrypted = Message.encrypt(secret, message)
    decrypted = Message.decrypt(secret, encrypted)
    message.should eql decrypted
  end
  it "should raise exception on invalid key" do
    secret = "blah"
    message = "this is the body"
    encrypted = Message.encrypt(secret, message)
    begin
      Message.decrypt("wrong secret", encrypted)
      raise "unexpected error"
    rescue OpenSSL::Cipher::CipherError => e
      e.message.should eql "bad decrypt"
    end
  end
end