# encoding: utf-8

module Yandex
  module Webmaster
    module Hosts
      class IndexedUrlsInfo < Base  

        define_attributes :as => 'api_attributes' do
          attr :index_count, Integer, :writer => :protected
          attr :last_week_index_urls, Array, :writer => :protected
        end

        attr_accessor :host      
      end
    end
  end
end