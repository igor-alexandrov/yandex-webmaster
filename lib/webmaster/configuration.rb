# encoding: utf-8

module Webmaster
  module Configuration

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

    # By default, don't set a user login name
    DEFAULT_LOGIN = nil

    # By default, don't set a user password
    DEFAULT_PASSWORD = nil

    # By default, don't set a user basic authentication
    DEFAULT_BASIC_AUTH = nil

    # The api endpoint used to connect to Yandex.Webmaster if none is set
    DEFAULT_ENDPOINT = 'https://webmaster.yandex.ru/api/v2/'.freeze

    # The web endpoint used to connect to Yandex.Webmaster if none is set
    DEFAULT_SITE = 'https://webmaster.yandex.ru'.freeze

    # The default SSL configuration
    DEFAULT_SSL = {}

    # The value sent in the http header for 'User-Agent' if none is set
    DEFAULT_USER_AGENT = "Webmaster Ruby Gem #{Webmaster::Version::STRING}".freeze

    # By default uses the Faraday connection options if none is set
    DEFAULT_CONNECTION_OPTIONS = {}

    attr_accessor *VALID_OPTIONS_KEYS

    # Convenience method to allow for global setting of configuration options
    def configure
      yield self
    end

    def self.extended(base)
      base.reset!
    end

    class << self
      def keys
        VALID_OPTIONS_KEYS
      end
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each { |k| options[k] = send(k) }
      options
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

  end
end
