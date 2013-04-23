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

      def default_options(options={})
        {
          :headers => {            
            ACCEPT_CHARSET   => "utf-8",
            USER_AGENT       => user_agent,
            CONTENT_TYPE     => 'application/xml'
          },
          :ssl => options.fetch(:ssl) { ssl },
          :url => options.fetch(:endpoint) { Webmaster.endpoint }
        }.merge(options)
      end

      # Default middleware stack that uses default adapter as specified at
      # configuration stage.
      #
      def default_middleware(options={})
        Proc.new do |builder|          
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use Webmaster::Helpers::OAuth2, self.oauth_token

          builder.use Faraday::Response::Logger if ENV['DEBUG']
          
          # builder.use Github::Response::RaiseError
          builder.adapter adapter
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
      def connection(options={})
        conn_options = default_options(options)
        clear_cache unless options.empty?
        puts "OPTIONS:#{conn_options.inspect}" if ENV['DEBUG']

        @connection ||= Faraday.new(conn_options.merge(:builder => stack(options)))
      end

    end
  end
end
