require 'webmaster/version'
require 'webmaster/configuration'
require 'webmaster/constants'

require 'webmaster/ext'

require 'webmaster/client'
require 'webmaster/errors'

require 'oauth2'

module Webmaster
  extend Configuration

  class << self
    attr_accessor :application_id, :application_password

    # Alias for Webmaster::Client.new
    #
    # @return [Webmaster::Client]
    def new(application_id = Webmaster.application_id, application_password = Webmaster.application_password)
      Webmaster::Client.new(application_id, application_password)
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
end