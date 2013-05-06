module Webmaster
  module Api
    module Attributes
      module Types
        class Symbol < Base        
          def self.typecast(value, options = {})
            value.underscore.to_sym
          end
        end
      end
    end
  end
end