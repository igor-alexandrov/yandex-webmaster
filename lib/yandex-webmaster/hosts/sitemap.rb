# encoding: utf-8

module Yandex
  module Webmaster
    module Hosts
      class Sitemap < Base
        
        define_attributes :as => 'api_attributes' do                  
          attr :href, String, :writer => :protected

          attr :latest_info, SitemapInfo, :writer => :protected
          attr :in_search_info, SitemapInfo, :writer => :protected
        end

        attr_accessor :host

        def resources
          @resources ||= {}
        end

        # Load detailed information about the sitemap
        # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/sitemap-id.xml
        # [EN] http://api.yandex.com/webmaster/doc/dg/reference/sitemap-id.xml
        # 
        def load_details          
          self.attributes = self.request(:get, self.href).body
          self
        end

        # Delete information about the sitemap from Yandex.Webmaster
        # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/sitemap-delete.xml
        # [EN] http://api.yandex.com/webmaster/doc/dg/reference/sitemap-delete.xml
        # 
        def delete            
          response = self.request(:delete, self.href)
          @deleted = true if response.status.to_i == 204        
          self
        end

        # @return [Boolean]
        # 
        def deleted?
          !!@deleted
        end

      protected

        def link=(value)          
          raise ArgumentError unless value.is_a?(Array)

          value.each do |link|
            link[:rel] == 'self' ? self.href = link[:href] : self.resources[link[:rel].underscore.to_sym] = link[:href]
          end
        end

        def info=(value)
          raise ArgumentError unless value.is_a?(Array)

          value.each do |info|
            if info[:type].present? && self.respond_to?("#{info[:type].downcase.underscore}_info=")
              self.send("#{info[:type].downcase.underscore}_info=", info.merge({
                  :host => self.host,
                  :configuration => self.configuration
                })
              )                                          
            end
          end
        end

      end
    end
  end
end