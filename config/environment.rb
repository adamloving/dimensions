# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RailsBootstrap::Application.initialize!

ENV['LD_LIBRARY_PATH'] ||="/usr/lib"
ENV['LD_LIBRARY_PATH'] +=":/app/lib/native"
Scraper::Base.parser :html_parser
