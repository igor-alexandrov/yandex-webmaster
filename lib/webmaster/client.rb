module Webmaster
  class Client < Base
    def hosts(reload = false)      
      @hosts = nil if reload
      @hosts ||= self.objects_from_response(Webmaster::Host, self.request(:get, '/hosts'), :host)      
    end

    def create_host(xml)
      # xml = "<host><name>#{name}</name></host>"
      self.request(:post, '/hosts', xml)
    end
  end
end