module DataMapper
  module SugarGlider
    module Model
      class QueryBlock
        attr_accessor :conditions
        
        def initialize(options={},&query_block)
          @conditions = options.fetch :conditions, DataMapper::Query::Conditions::Operation.new(:and)
          block = query_block || Proc.new{}
#          puts "Evaluating Block"
          instance_eval(&block)
          outer = self.class.to_path.outerclass
#          puts "about to form query"
#          puts @conditions.inspect
          @query = DataMapper::Query.new(outer.repository, outer, options.merge(:conditions=>@conditions))
        end

        def all(&conditions)
#          puts "Yay ALL inside a Block"
          @conditions << self.class.new({},&conditions).conditions
        end
        
        def any(&conditions)
#          puts "Yay ANY inside a Block"
          @conditions << self.class.new({:conditions => DataMapper::Query::Conditions::OrOperation.new},&conditions).conditions
        end

        def to_query
          return @query
        end
        
        def <<(condition)
          @conditions << condition
          condition
        end
      end
    end
  end
end
