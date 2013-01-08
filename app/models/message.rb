class Message < ActiveRecord::Base
  attr_accessible :contents, :creation_date, :decryption_attempts, :expires_at, :id, :sender, :uuid

  before_create :generate_hash

  def generate_hash
    self.uuid = Digest::SHA1.hexdigest("#{Time.now},#{contents}")
    logger.info "hash is #{@uuid}"
  end

end
