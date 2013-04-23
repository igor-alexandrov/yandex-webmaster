# encoding: utf-8

require 'faraday'

module Webmaster
  module Helpers
    class OAuth2 < Faraday::Middleware
      
      AUTH_HEADER  = 'Authorization'.freeze

      dependency 'oauth2'

      def call(env)
        env[:request_headers].merge!(AUTH_HEADER => "OAuth #{@token}") if @token.present?

        @app.call env
      end

      def initialize(app, *args)
        super app
        @app = app
        @token = args.shift
      end

      def query_params(url)
        if url.query.nil? or url.query.empty?
          {}
        else
          parse_query url.query
        end
      end
    end
  end
end
