# Load the rails application
require File.expand_path('../application', __FILE__)

begin
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
rescue NameError
  # will happen, when using ruby 1.8, can be ignored, though
end

# Initialize the rails application
Anduin::Application.initialize!
