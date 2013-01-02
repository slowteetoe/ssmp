require 'spec_helper'
require 'smssender'

describe "sms sender" do
  it "should send a text message" do
    sender = SMSSender.new
    sender.send("Steve sent you a secure messaging code 1j2d73", "+17022181502")
  end
end
