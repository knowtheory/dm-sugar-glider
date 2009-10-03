module DataMapper
  module SugarGlider
    module Model
      module Property
        DataMapper::Model.append_extensions self
        def property(name, type, options={})
          self::QueryBlock.define_property_matcher(super)
        end
      end
    end
  end
end
