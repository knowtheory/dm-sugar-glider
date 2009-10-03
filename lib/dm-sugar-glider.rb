require 'pathname'
require 'rubygems'

dir = Pathname(__FILE__).dirname.expand_path + 'dm-sugar-glider'

require 'dm-core'
require 'dm-core/version'

require dir / 'model'
require dir / 'model' / 'property'
require dir / 'model' / 'query_block'
require dir / 'query'
require dir / 'query' / 'property_matcher'
require dir / 'query' / 'relationship_matcher'
require dir / 'relationship'
require dir / 'support' / 'class_path'

module DataMapper
  class Query
    include SugarGlider::Query
  end
end