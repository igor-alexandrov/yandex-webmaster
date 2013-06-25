require 'yandex-webmaster/version'
require 'yandex-webmaster/configuration'
require 'yandex-webmaster/errors'

require 'yandex-webmaster/core_ext/date'
require 'yandex-webmaster/core_ext/date_time'
require 'yandex-webmaster/core_ext/hash'
require 'yandex-webmaster/core_ext/string'

module Yandex
  module Webmaster
    class << self
      # Alias for Yandex::Webmaster::Client.new
      #
      # @return [Yandex::Webmaster::Client]
      def new(options = {}, &block)
        Yandex::Webmaster::Client.new(:configuration => options, &block)
      end

      # Delegate to Yandex::Webmaster::Client
      #
      def method_missing(method, *args, &block)
        return super unless new.respond_to?(method)
        new.send(method, *args, &block)
      end

      def respond_to?(method, include_private = false)
        new.respond_to?(method, include_private) || super(method, include_private)
      end

      # config/initializers/webmaster.rb (for instance)
      #
      # Yandex::Webmaster.configure do |config|
      #   config.application_id = 'application_id'
      #   config.application_password = 'application_password'    
      # end
      #
      # elsewhere
      #
      # client = Yandex::Webmaster::Client.new

      def configure
        yield self
        true
      end
    end

    autoload :Helpers, 'yandex-webmaster/helpers'

    autoload :Base, 'yandex-webmaster/base'
    autoload :ApiFactory, 'yandex-webmaster/api_factory'
    autoload :Client, 'yandex-webmaster/client'  

    autoload :Host, 'yandex-webmaster/host'
    
    module Hosts
      autoload :Crawling, 'yandex-webmaster/hosts/crawling'
      autoload :Sitemap, 'yandex-webmaster/hosts/sitemap'
      autoload :SitemapInfo, 'yandex-webmaster/hosts/sitemap_info'
      autoload :TopInfo, 'yandex-webmaster/hosts/top_info'
      autoload :Verification, 'yandex-webmaster/hosts/verification'
    end

    module Request
      autoload :OAuth2, 'yandex-webmaster/request/oauth2'  
    end

    module Response
      autoload :Hashify, 'yandex-webmaster/response/hashify'  
    end

    module Api
      autoload :AttributesBuilder, 'yandex-webmaster/api/attributes_builder'
      autoload :Attributes, 'yandex-webmaster/api/attributes' 
    end
  end
end