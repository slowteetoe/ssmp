class CommunicationMailer < ActionMailer::Base
  default from: "ssmp.mailer@gmail.com"

  def you_have_mail(sender, recipient, uuid)
    @message_pickup_url = "http://ssmp.herokuapp.com/view/#{uuid}"
    @sender = sender
    mail(
      :to => "Recipient <#{recipient}>",
      :from => "SSMP Mailer <ssmp.mailer@gmail.com>",
      :subject => "You have a Simply Secure Message waiting for you"
    )
  end

end
