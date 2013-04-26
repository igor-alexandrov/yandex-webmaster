# encoding: utf-8

require 'faraday'

require 'webmaster/helpers/oauth2'


module Webmaster
  module Helpers
    module Connection
      extend self
      include Webmaster::Constants

      ALLOWED_OPTIONS = [
        :headers,
        :url,
        :params,
        :request,
        :ssl
      ].freeze

      def connection_options(options={})
        {
          :headers => {            
            ACCEPT_CHARSET   => "utf-8",
            USER_AGENT       => self.configuration.user_agent,
            # Due to error in Yandex.Webmaster API I had to change this header
            # http://clubs.ya.ru/webmaster-api/replies.xml?item_no=150
            # CONTENT_TYPE     => 'application/xml'
            CONTENT_TYPE     => 'application/x-www-form-urlencoded'
          },
          :ssl => options.fetch(:ssl) { self.configuration.ssl },
          :url => options.fetch(:endpoint) { self.configuration.endpoint }
        }.merge(options)
      end

      # Default middleware stack that uses default adapter as specified at
      # configuration stage.
      #
      def default_middleware(options={})
        Proc.new do |builder|          
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use Webmaster::Helpers::OAuth2, self.configuration.oauth_token

          builder.use Faraday::Response::Logger if ENV['DEBUG']
          builder.use Webmaster::Response::Hashify
          # builder.use Webmaster::Response::RaiseError
          
          builder.adapter self.configuration.adapter
        end
      end

      @connection = nil

      @stack = nil

      def clear_cache
        @connection = nil
      end

      def caching?
        !@connection.nil?
      end

      # Exposes middleware builder to facilitate custom stacks and easy
      # addition of new extensions such as cache adapter.
      #
      def stack(options={}, &block)
        @stack ||= begin
          if block_given?
            Faraday::Builder.new(&block)
          else
            Faraday::Builder.new(&default_middleware(options))
          end
        end
      end

      # Returns a Fraday::Connection object
      #
      def connection(options = {})
        opts = self.connection_options(options)
        clear_cache unless opts.empty?
        puts "OPTIONS:#{opts.inspect}" if ENV['DEBUG']

        @connection ||= Faraday.new(opts.merge(:builder => stack(options)))
      end

    end
  end
end
