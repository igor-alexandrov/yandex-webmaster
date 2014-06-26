# encoding: utf-8

module Yandex
  module Webmaster
    class Configuration
      
      VALID_OPTIONS_KEYS = [
        :adapter,
        :app_id,
        :app_password,
        :oauth_token,
        :endpoint,
        :site,
        :ssl,
        :user_agent,
        :connection_options
      ].freeze

      # Other adapters are :typhoeus, :patron, :em_synchrony, :excon, :test
      DEFAULT_ADAPTER = :net_http

      # By default, don't set an application id
      DEFAULT_APP_ID = nil

      # By default, don't set an application password
      DEFAULT_APP_PASSWORD = nil

      # By default, don't set a user oauth access token
      DEFAULT_OAUTH_TOKEN = nil

      # The api endpoint used to connect to Yandex.Webmaster if none is set
      DEFAULT_ENDPOINT = 'https://webmaster.yandex.ru/api/v2/'.freeze

      # The web endpoint used to connect to Yandex.Webmaster if none is set
      DEFAULT_SITE = 'https://oauth.yandex.ru/'.freeze

      # The default SSL configuration
      DEFAULT_SSL = {}

      # The value sent in the http header for 'User-Agent' if none is set
      DEFAULT_USER_AGENT = "Webmaster Ruby Gem #{Yandex::Webmaster::Version::STRING}".freeze

      # By default uses the Faraday connection options if none is set
      DEFAULT_CONNECTION_OPTIONS = {}

      attr_accessor *VALID_OPTIONS_KEYS

      def initialize(options = {})
        raise ArgumentError if (Helpers.symbolize_hash_keys(options).keys - VALID_OPTIONS_KEYS).any?

        self.reset!
        options.each { |k,v| send("#{k}=", v) }
      end

      def keys
        VALID_OPTIONS_KEYS
      end

      def current
        VALID_OPTIONS_KEYS.inject({}) { |h, k| h[k] = send(k); h }
      end

      # Reset configuration options to their defaults
      #
      def reset!
        self.adapter            = DEFAULT_ADAPTER
        self.app_id             = DEFAULT_APP_ID
        self.app_password       = DEFAULT_APP_PASSWORD
        self.oauth_token        = DEFAULT_OAUTH_TOKEN
        self.endpoint           = DEFAULT_ENDPOINT
        self.site               = DEFAULT_SITE
        self.ssl                = DEFAULT_SSL
        self.user_agent         = DEFAULT_USER_AGENT
        self.connection_options = DEFAULT_CONNECTION_OPTIONS
        self
      end

      # Convenience method to allow for global setting of configuration options
      #
      def configure
        yield self
      end

      # Responds to attribute query or attribute clear
      #
      def method_missing(method, *args, &block) # :nodoc:
        case method.to_s
        when /^(.*)\?$/
          return !!self.send($1.to_s)
        when /^clear_(.*)$/
          self.send("#{$1.to_s}=", nil)
        else
          super
        end
      end
    end
  end
end
