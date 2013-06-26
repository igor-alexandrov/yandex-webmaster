# encoding: utf-8

module Yandex
  module Webmaster
    module Hosts
      class TopQueriesInfo < Base  

        define_attributes :as => 'api_attributes' do
          attr :total_shows_count, Integer, :writer => :protected
          attr :top_shows_percent, Float, :writer => :protected
          attr :top_shows, Array, :writer => :protected

          attr :total_clicks_count, Integer, :writer => :protected
          attr :top_clicks_percent, Float, :writer => :protected
          attr :top_clicks, Array, :writer => :protected
        end

        attr_accessor :host

        protected

          def top_shows=(value)
            array = value.is_a?(Hash) ? value[:top_info] : value
            @top_shows = self.objects_from_array(Yandex::Webmaster::Hosts::Query, array)
          end

          def top_clicks=(value)
            array = value.is_a?(Hash) ? value[:top_info] : value
            @top_clicks = self.objects_from_array(Yandex::Webmaster::Hosts::Query, array)
          end

      end
    end
  end
end