require 'webmaster/version'
require 'webmaster/configuration'
require 'webmaster/constants'
require 'webmaster/errors'

require 'webmaster/core_ext/hash'
require 'webmaster/core_ext/object'
require 'webmaster/core_ext/string'

module Webmaster
  # extend Configuration

  class << self
    # Alias for Webmaster::Client.new
    #
    # @return [Github::Client]
    def new(options = {}, &block)
      Webmaster::Client.new(:configuration => options, &block)
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

  autoload :Base, 'webmaster/base'
  autoload :ApiFactory, 'webmaster/api_factory'
  autoload :Client, 'webmaster/client'  

  autoload :Host, 'webmaster/host'

  module Hosts
    autoload :Verification, 'webmaster/hosts/verification'    
  end

  module Response
    autoload :Hashify, 'webmaster/response/hashify'  
  end
end