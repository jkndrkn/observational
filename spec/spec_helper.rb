require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'observational'
require 'activerecord'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

require 'active_record_env'
