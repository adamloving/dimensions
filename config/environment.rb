# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['LD_LIBRARY_PATH'] ||="/usr/lib"
ENV['LD_LIBRARY_PATH'] +=":/app/lib/native"

# Initialize the rails application
RailsBootstrap::Application.initialize!
