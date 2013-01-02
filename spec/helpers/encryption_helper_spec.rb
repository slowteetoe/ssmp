
describe "EncryptionHelpers" do
  before(:each) do
    @d = Message.new
  end
  it "should decrypt a message" do
    secret = "blah"
    message = "this is the body"
    encrypted = @d.encrypt(secret, message)
    decrypted = @d.decrypt(secret, encrypted)
    message.should eql decrypted
  end
  it "should raise exception on invalid key" do
    secret = "blah"
    message = "this is the body"
    encrypted = @d.encrypt(secret, message)
    begin
      @d.decrypt("wrong secret", encrypted)
      raise "unexpected error"
    rescue OpenSSL::Cipher::CipherError => e
      e.message.should eql "bad decrypt"
    end
  end
end