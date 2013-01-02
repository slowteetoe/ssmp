class MessageController < ApplicationController
  def index
    @default_secret = "foobar"
  end

  def view
    @message = Message.find_by_id( params[:id] ) unless params[:id].nil?
  end
  
  def decrypt
    render :json => "This is my message"
  end

end
