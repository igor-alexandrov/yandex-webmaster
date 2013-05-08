# encoding: utf-8

module Yandex
  module Webmaster
    module Api
      module Attributes
        module Types
          class Time < Base        
            def self.typecast(value, options = {})
              options[:format].present? ? ::Time.strftime(value, options[:format]) : ::Time.parse(value)
            end
          end
        end
      end
    end
  end
end