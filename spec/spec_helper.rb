

# This is the new helper ^^^^^^
#  -- Not sure which one will work best
# This is the old helper VVVVVV

ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'
require 'remarkable_rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = true
  config.fixture_path = File.dirname(__FILE__) + '/fixtures/'
end
