module DataMapper
  module SugarGlider
    module Query
      class PropertyMatcher
        def initialize(queryblock,property)
          raise ArgumentError, "PropertyMatcher must be initialized with a Property" unless property.is_a? DataMapper::Property
          @property   = property
          @queryblock = queryblock
        end
        
        def ==(argument)
          @condition = DataMapper::Query::Conditions::Comparison.new(:eql, @property, argument)
          add_to_queryblock
        end
        
        def >(argument)
          @condition = DataMapper::Query::Conditions::Comparison.new(:gt,  @property, argument)
          add_to_queryblock
        end
        
        def >=(argument)
          @condition = DataMapper::Query::Conditions::Comparison.new(:gte, @property, argument)
          add_to_queryblock
        end
        
        def <(argument)
          @condition = DataMapper::Query::Conditions::Comparison.new(:lt,  @property, argument)
          add_to_queryblock
        end
        
        def <=(argument)
          @condition = DataMapper::Query::Conditions::Comparison.new(:lte, @property, argument)
          add_to_queryblock
        end
        
        def =~(argument)
          @condition = DataMapper::Query::Conditions::Comparison.new(:regexp, @property, argument)
          add_to_queryblock
        end
        
        def like(argument)
          @condition = DataMapper::Query::Conditions::Comparison.new(:like, @property, argument)
          add_to_queryblock
        end
        
        def not(argument)
          #DataMapper::Query::Conditions::
        end
        
        def include?(argument)
          @condition = DataMapper::Query::Conditions::Comparison.new(:in, @property, argument)
          add_to_queryblock
        end
        
        def add_to_queryblock
          @queryblock << @condition
        end
      end
    end
  end
end