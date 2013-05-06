# encoding: utf-8

module Webmaster
  module Hosts
    class Crawling < Base
      STATES = [
        'indexed',
        'not_indexed',
        'waiting'
      ].freeze

      define_attributes :as => 'api_attributes' do        
        attr :state, String, :writer => :protected      
      end

      attr_accessor :host

      def state=(value)
        value = value.downcase.underscore
        @state = value if STATES.include?(value)
      end
    end
  end
end
