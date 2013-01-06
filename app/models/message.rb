class Message < ActiveRecord::Base
  include EncryptionHelper

  attr_accessible :contents, :creation_date, :decryption_attempts, :expiration_date, :id, :sender, :uuid

end
