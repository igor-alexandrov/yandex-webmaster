module Webmaster
  module Hosts
    class TopInfo < Base  

      define_attributes :as => 'api_attributes' do        
        attr :query, String, :writer => :protected
        attr :count, Integer, :writer => :protected
        attr :position, Integer, :writer => :protected
        attr :is_custom, Boolean, :writer => :protected        
      end

      attr_accessor :host      
    end
  end
end
