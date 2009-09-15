$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'dm-sugar-glider'
require 'spec'
require 'spec/autorun'
require 'dm-sweatshop'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, "mysql://localhost/dm_pets")

here = File.dirname(__FILE__)
require File.join(here,'models','schema','people_and_pets')
DataMapper.auto_migrate!
require File.join(here, 'spec_fixtures')

Spec::Runner.configure do |config|
  
end
