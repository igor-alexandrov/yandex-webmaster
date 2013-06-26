# encoding: utf-8

module Yandex
  module Webmaster
    module Hosts
      class IncomingLinks < Base  

        define_attributes :as => 'api_attributes' do
          attr :links_count, Integer, :writer => :protected
          attr :last_week_links, Array, :writer => :protected
        end

        attr_accessor :host      
      end
    end
  end
end