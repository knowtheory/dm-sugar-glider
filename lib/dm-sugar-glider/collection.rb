module DataMapper
  class Collection
    def all(query={},&query_block)
      puts "MODIFIED COLLECTION ALL"
      if query_block.nil? and (query.nil? || (query.kind_of?(Hash) && query.empty?))
        dup
      else
        query_from_block = query_from(&query_block)
        query_from_options = scoped_query(query)
        super(query_from_options.merge(query_from_block))
      end
    end
    
    def any(query={},&query_block)
      puts "MODIFIED COLLECTION ANY"
      if query_block.nil? and (query.nil? || (query.kind_of?(Hash) && query.empty?))
        dup
      else
        query_from_block = query_from(&query_block)
        query_from_options = scoped_query(query)
        super(query_from_options.merge(query_from_block))
      end
    end
    
    def query_from(options={}, &query_block)
      self.query.model::QueryBlock.new(options,&query_block).to_query
    end
  end
end