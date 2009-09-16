require 'pathname'
require 'rubygems'

dir = Pathname(__FILE__).dirname.expand_path + 'dm-sugar-glider'

require 'dm-core'
require 'dm-core/version'

require dir / 'model'
require dir / 'model' / 'property'
require dir / 'model' / 'query'
require dir / 'query'
require dir / 'query' / 'property_matcher'

module DataMapper
  class Query
    include SugarGlider::Query
  end
end