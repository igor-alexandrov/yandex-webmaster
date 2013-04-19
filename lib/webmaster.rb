require 'webmaster/helpers'
require 'webmaster/ext'

require 'webmaster/client'
require 'webmaster/errors'

require 'oauth2'

module Webmaster

  class << self
    attr_accessor :application_id, :application_password

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
end