require 'rubygems'
require 'rspec'
require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../src') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../src')

require 'smsified'
require 'smsified_worker'

RSpec.configure do |config|


end