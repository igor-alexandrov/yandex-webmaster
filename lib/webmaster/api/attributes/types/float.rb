module Webmaster
  module Api
    module Attributes
      module Types
        class Float < Base        
          def self.typecast(value, options = {})
            value.to_f
          end
        end
      end
    end
  end
end