module DataMapper
  module SugarGlider
    module Model
      class QueryBlock
        attr_accessor :conditions

        def initialize(options={},&query_block)
          @conditions = options.fetch :conditions, DataMapper::Query::Conditions::Operation.new(:and)
          block = query_block || Proc.new{}
          outer = self.class.to_class_path.outerclass
          @query = DataMapper::Query.new(outer.repository, outer, options.merge(:conditions=>@conditions))
#          puts "Evaluating Block"
          instance_eval(&block)
#          puts "about to form query"
#          puts @conditions.inspect
          @query.update(:conditions => @conditions)
        end

        def all(&conditions)
#          puts "Yay ALL inside a Block"
          @query.update self.class.new({},&conditions).to_query
        end
        
        def any(&conditions)
#          puts "Yay ANY inside a Block"
          @query.update self.class.new({:conditions => DataMapper::Query::Conditions::OrOperation.new},&conditions).to_query
        end

        def to_query
          return @query
        end
        
        def <<(condition)
          @conditions << condition
          condition
        end
        
        def self.define_property_matcher(property)
          self.class_eval <<-PropertyMatcher
            def #{property.name}
              DataMapper::SugarGlider::Query::PropertyMatcher.new(self,#{property.model}.#{property.name})
            end
          PropertyMatcher
          property
        end
        
        def self.define_relationship_matcher(name)
          self.class_eval <<-PropertyMatcher
            def #{name}
              DataMapper::SugarGlider::Query::RelationshipMatcher.new(self,:#{name})
            end
          PropertyMatcher
          self.name
        end
      end
    end
  end
end
