class Message < ActiveRecord::Base
  include EncryptionHelper

  attr_accessible :contents, :creation_date, :decryption_attempts, :expires_at, :id, :sender, :uuid

end
