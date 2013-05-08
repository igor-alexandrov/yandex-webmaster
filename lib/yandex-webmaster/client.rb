# encoding: utf-8

module Yandex
  module Webmaster
    class Client < Base
      def hosts(reload = false)      
        @hosts = nil if reload
        @hosts ||= self.objects_from_response(Webmaster::Host, self.request(:get, '/hosts'), :host)      
      end

      def create_host(name)
        xml = "<host><name>#{name}</name></host>"
        response = self.request(:post, '/hosts', xml)
        if response.status.to_i == 201
          host = Yandex::Webmaster::Host.new(:href => response.headers['Location'])
          host.configuration = self.configuration
          return host
        end
      end
    end
  end
end