# encoding: utf-8

module Webmaster
  class Client < Base
    def hosts(reload = false)      
      @hosts = nil if reload
      @hosts ||= self.objects_from_response(Webmaster::Host, self.request(:get, '/hosts'), :host)      
    end

    def create_host(name)
      xml = "<host><name>#{name}</name></host>"
      self.request(:post, '/hosts', xml)
    end
  end
end