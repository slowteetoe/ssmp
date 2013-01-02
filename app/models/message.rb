class Message < ActiveRecord::Base
  include EncryptionHelper
  APP_KEY = "hats9gr12irtfpgadsgfbisuadtv7terg1iuw4grkqwkleuf"
  attr_accessible :contents, :creation_date, :decryption_attempts, :expiration_date, :id, :sender, :uuid

end
