module Webmaster
  class Client
    
    def initialize(application_id = Webmaster.application_id, application_password = Webmaster.application_password)
      @application_id = application_id
      @application_password = application_password
    end

  end
end