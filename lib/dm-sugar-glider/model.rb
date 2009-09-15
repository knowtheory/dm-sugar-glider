module DataMapper
  module SugarGlider
    module Model
      DataMapper::Model.append_extensions self
      
      def self.extended(model)
        model.class_eval 'class QueryBlock < DataMapper::SugarGlider::Model::QueryBlock; end'
      end
      
      def all(query={},&query_block)
        query_from_block = query_from(&query_block)
        query_from_options = scoped_query(query)
        super(query_from_options.merge(query_from_block))
      end
      
      def any(query={},&query_block)
        query_from_block = query_from({:conditions=>DataMapper::Query::Conditions::Operation.new(:or)},&query_block)
        query_from_options = scoped_query(query)
        q = query_from_options.merge(query_from_block)
        all(q)
      end
      
      def first(*args,&query_block)
        super
      end
      
      def last(*args,&query_block)
        super
      end
      
      def first_or_new(conditions={},attributes={})
        super
      end

      def first_or_create(conditions={},attributes={})
        super
      end
      
      def query_from(options={},&query_block)
        self::QueryBlock.new(options,&query_block).to_query
      end
    end
  end
end