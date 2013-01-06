class SMSSender
  require 'twilio-ruby'

  def initialize
      @account_sid = ENV['TWILIO_SID']
      @auth_token = ENV['TWILIO_TOKEN']
      @sender_phone = ENV['TWILIO_PHONE']
  end

  def send(body, destination_phone)
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)

    @client.account.sms.messages.create(
        :from => @sender_phone,
        :to => destination_phone,
        :body => body
     )
  end

end
