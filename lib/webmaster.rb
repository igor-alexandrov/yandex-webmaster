require 'webmaster/version'
require 'webmaster/configuration'
require 'webmaster/constants'

require 'webmaster/ext'

require 'webmaster/errors'

require 'oauth2'

module Webmaster
  extend Configuration

  class << self
    # Alias for Webmaster::Client.new
    #
    # @return [Github::Client]
    def new(options = {}, &block)
      Webmaster::Client.new(options, &block)
    end

    # Delegate to Webmaster::Client
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
    # Webmaster.configure do |config|
    #   config.application_id = 'application_id'
    #   config.application_password = 'application_password'    
    # end
    #
    # elsewhere
    #
    # client = Webmaster::Client.new

    def configure
      yield self
      true
    end
  end

  autoload :API, 'webmaster/api'
  autoload :Client, 'webmaster/client'  
end