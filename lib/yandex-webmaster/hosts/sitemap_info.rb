module Yandex
  module Webmaster
    module Hosts
      class SitemapInfo < Base        

        ADDED_BY = [
          'user',
          'robot_txt'          
        ].freeze

        FORMATS = [
          'XML',
          'RSS',
          'TEXT'
        ].freeze

        TYPES = [
          'SITEMAP',
          'SITEMAPINDX'
        ].freeze

        define_attributes :as => 'api_attributes' do        
          attr :url_count, Integer, :writer => :protected
          attr :url_error_count, Integer, :writer => :protected
          attr :error_count, Integer, :writer => :protected
          attr :submitted_on, DateTime, :writer => :protected
          attr :added_by, Array, :writer => :protected
          attr :processed_on, DateTime, :writer => :protected
          attr :real_processed_on, DateTime, :writer => :protected
          attr :format, String, :writer => :protected
          attr :type, String, :writer => :protected    
        end

        attr_accessor :host

      protected

        def added_by=(value)
          @added_by = Array.wrap(value).flatten.map{ |v| v.downcase.underscore }.select{ |v| ADDED_BY.include?(v) }           
        end

        def format=(value)
          value = value.upcase
          @format = value if FORMATS.include?(value)
        end

        def type=(value)
          value = value.upcase
          @type = value if TYPES.include?(value)
        end
 
      end
    end
  end
end
