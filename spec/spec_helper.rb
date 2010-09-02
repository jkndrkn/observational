require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'observational'
require 'active_record'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

# require 'active_record_env'
