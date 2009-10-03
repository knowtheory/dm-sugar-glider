module DataMapper
  module SugarGlider
    module Relationship
      DataMapper::Model.append_extensions self
      def has(cardinality, name, *args)
        relationship = super
        self::QueryBlock.define_relationship_matcher(relationship.name)
        relationship
      end
      
      def belongs_to(name, *args)
        relationship = super
        self::QueryBlock.define_relationship_matcher(relationship.name)
        relationship
      end
    end
  end
end
