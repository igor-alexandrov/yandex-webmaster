# encoding: utf-8

module Yandex
  module Webmaster
    module Hosts
      class TopQueries < Base  

        define_attributes :as => 'api_attributes' do
          attr :total_shows_count, Integer, :writer => :protected
          attr :top_shows_percent, Float, :writer => :protected
          attr :top_shows, Array, :writer => :protected

          attr :total_clicks_count, Integer, :writer => :protected
          attr :top_clicks_percent, Float, :writer => :protected
          attr :top_clicks, Array, :writer => :protected
        end

        attr_accessor :host      
      end
    end
  end
end