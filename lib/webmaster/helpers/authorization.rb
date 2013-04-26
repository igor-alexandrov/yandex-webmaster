# encoding: utf-8

module Webmaster
  module Helpers
    module Authorization

      attr_accessor :scopes

      # Setup OAuth2 instance
      def oauth
        @client ||= ::OAuth2::Client.new(app_id, app_password,
          {
            :site          => self.configuration.site || Webmaster::Configuration.size,
            :authorize_url => '/authorize',
            :token_url     => '/token',
            :ssl           => { :verify => false }          
          }
        )
      end

      # Strategy token
      # 
      def auth_code
        self.verify_oauth
        self.oauth.auth_code
      end

      # Sends authorization request to Yandex.Webmaster.    
      #
      def authorize_url(params = {})
        self.verify_oauth
        self.oauth.auth_code.authorize_url(params)
      end

      # Makes request to token endpoint and retrieves access token value
      def get_token(authorization_code, params = {})
        self.verify_oauth
        self.oauth.auth_code.get_token(authorization_code, params)
      end

      # Check whether authentication credentials are present
      def authenticated?
        self.configuration.oauth_token?
      end    

    protected

      def verify_oauth # :nodoc:
        raise ArgumentError, 'Need to provide app_id and app_password' unless self.configuration.app_id? && self.configuration.app_password?
      end

    end
  end
end
