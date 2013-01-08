class MessageController < ApplicationController

  require 'word_salad'

  def index
    @message_submission = MessageSubmission.new
    @message_submission.secret = 2.words.join("")
  end

  def view
    @message = Message.find_by_id( params[:id] ) unless params[:id].nil?
  end

  def decrypt
    render :json => "This is my message"
  end

  def create
    @message_submission = MessageSubmission.new(params[:message_submission])
    @message_submission ||= MessageSubmission.new
    if @message_submission.valid?
      render :json => @message_submission
    else
      flash[:error] = "There were errors with your submission, please check the form"
      render :action => :index
    end
  end

end
