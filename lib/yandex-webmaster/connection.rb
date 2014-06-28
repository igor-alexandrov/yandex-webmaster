# encoding: utf-8

require 'faraday'

module Yandex
  module Webmaster
    module Connection
      extend self

      USER_AGENT = 'User-Agent'.freeze
      ACCEPT = 'Accept'.freeze
      ACCEPT_CHARSET = 'Accept-Charset'.freeze
      CONTENT_TYPE = 'Content-Type'.freeze
      ALLOWED_OPTIONS = [
        :headers,
        :url,
        :params,
        :request,
        :ssl
      ].freeze

      # Returns a Faraday::Connection object
      #
      def connection(options = {})

        options = self.connection_options(options)
        
        if @connection_options != options
          @connection = nil
          @connection_options = options
        end

        @connection ||= Faraday.new(@connection_options.merge(:builder => self.stack))
      end

    protected
      def config
        Yandex::Webmaster::Configuration.instance
      end
      
      def connection_options(options = {})
        options.slice!(*ALLOWED_OPTIONS)
        
        {
          :headers => {
            ACCEPT_CHARSET   => "utf-8",
            USER_AGENT       => config.user_agent,
            
            # Due to error in Yandex.Webmaster API I had to change this header
            # http://clubs.ya.ru/webmaster-api/replies.xml?item_no=150
            # CONTENT_TYPE     => 'application/xml'
            CONTENT_TYPE     => 'application/x-www-form-urlencoded'
          },
          :ssl => options.fetch(:ssl) { config.ssl },
          :url => options.fetch(:endpoint) { config.endpoint }
        }.merge(options)
      end

      # Exposes middleware builder to facilitate custom stacks and easy
      # addition of new extensions such as cache adapter.
      #
      def stack(&block)
        @stack ||= begin
          block_given? ? Faraday::Builder.new(&block) : Faraday::Builder.new(&default_middleware)
        end
      end

      # Default middleware stack that uses default adapter as specified at
      # configuration stage.
      #
      def default_middleware
        Proc.new do |builder|
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use Yandex::Webmaster::Request::OAuth2, config.oauth_token

          builder.use Faraday::Response::Logger if ENV['DEBUG']
          builder.use Yandex::Webmaster::Response::Hashify
          # builder.use Yandex::Webmaster::Response::RaiseError
          
          builder.adapter config.adapter
        end
      end

    end
  end
end
