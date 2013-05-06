module Webmaster
  module Api
    module Attributes
      module Types
        class Integer < Base        
          def self.typecast(value, options = {})
            value.to_i
          end
        end
      end
    end
  end
end