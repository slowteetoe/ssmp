class MessageController < ApplicationController
  include EncryptionHelper

  require 'word_salad'
  require 'smssender'

  MAX_DECRYPTION_ATTEMPTS = 100

  def index
    @message_submission = MessageSubmission.new
    @message_submission.secret = 2.words.join("")
    flash[:error] = nil
  end

  def view
    @message = Message.find_by_uuid( params[:uuid] ) unless params[:uuid].nil?
    if @message.nil?
      @message = Message.new
      flash[:error] = "Uhoh, that message doesn't seem to exist.  Please double-check"
    end
  end

  def decrypt_message
    logger.info "Attempting to decrypt uuid[#{params[:uuid]}]"

    @message = Message.find_by_uuid( params[:uuid] )

    if @message.nil?
      render :json => {:msg => "Unknown message" }
      return
    end

    begin
      logger.info "Attempting to decrypt #{@message.contents} using #{params[:secret]}"
      @decrypted = decrypt( params[:secret], @message.contents )
      @message.decryption_attempts = 0
    rescue
      logger.error "Decryption failed #{$!}"
      # it must increment attempt count for all failures as well
      @message.decryption_attempts += 1
      if (@message.decryption_attempts >= MAX_DECRYPTION_ATTEMPTS)
        logger.warn "Permanently deleting #{@message.uuid} because of too many decryption attempts"
        Message.delete(@message.id)
      end
      @decrypted = "Invalid Passphrase"
    end
    @message.save
    render :json => {:msg => @decrypted}
  end

  def success
  end

  def create
    @message_submission = MessageSubmission.new(params[:message_submission])
    @message_submission ||= MessageSubmission.new
    if @message_submission.valid?
      @m = Message.new
      @m.contents = encrypt( @message_submission.secret, @message_submission.content )
      @m.save!

      # send email
      logger.debug "A new message was created at https://#{request.host}/view/#{@m.uuid}"
      begin
        CommunicationMailer.you_have_mail(@message_submission.sender, @message_submission.recipient, @m.uuid).deliver
      rescue
        logger.error "Email sending failed ->  #{$!}"
      end

      if @message_submission.phone.blank?
        logger.info "No phone number provided, skipping SMS"
      else
        begin
          SMSSender.new.send_sms("The secret phrase to access your SSMP from #{@message_submission.sender} is: #{@message_submission.secret}", @message_submission.phone)
        rescue
          logger.error "Could not send SMS message. Error was #{$!}"
        end
      end

      redirect_to :success
    else
      flash[:error] = "There were errors with your submission, please check the form"
      render :action => :index
    end
  end

end
