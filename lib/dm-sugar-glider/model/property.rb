module DataMapper
  module SugarGlider
    module Model
      module Property
        DataMapper::Model.append_extensions self
        def property(name, type, options={})
          result = super
          # ToDo:
          # Add matcher methods to self::Query.
          # need an object which can take different methods as matchers
          # such as: include?, ==, =~ etc.
          subject_klass = self
          self.class_eval <<-PropertyMatcher
            class QueryBlock
              def #{name}
                DataMapper::SugarGlider::Query::PropertyMatcher.new(self,#{subject_klass}.#{name})
              end
            end
          PropertyMatcher
          return result
        end
      end
    end
  end
end