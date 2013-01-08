# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ssmp::Application.initialize!

# Bootstrap hack to make error divs work right
ActionView::Base.field_error_proc = Proc.new {|html, instance| html }
