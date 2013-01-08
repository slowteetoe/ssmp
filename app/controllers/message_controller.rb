class MessageController < ApplicationController
  include EncryptionHelper

  require 'word_salad'
  require 'smssender'

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
    # this needs to try decrypting a given message using the provided secret
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
      @decrypted = "Invalid Passphrase"
    end
    @message.save
    render :json => { :msg => @decrypted }
  end

  def create
    @message_submission = MessageSubmission.new(params[:message_submission])
    @message_submission ||= MessageSubmission.new
    if @message_submission.valid?
      @m = Message.new
      @m.contents = encrypt( @message_submission.secret, @message_submission.content )
      @m.save!

      # send email
      logger.info "Please go to http://#{request.host}/view/#{@m.uuid} to retrieve this message"
      begin
        CommunicationMailer.you_have_mail(@message_submission.sender, @message_submission.recipient, @m.uuid).deliver
      rescue
        logger.error "Email sending failed =(  #{$!}"
      end

      if @message_submission.phone.nil?
      else
        begin
          SMSSender.new.send_sms("Your SSMP secret: #{@message_submission.secret}", @message_submission.phone)
        rescue
          logger.error "SMS failed, secret was #{@message_submission.secret}.  Error was #{$!}"
        end
      end

      # redirect to a success page
      render :json => @m
    else
      flash[:error] = "There were errors with your submission, please check the form"
      render :action => :index
    end
  end

end
