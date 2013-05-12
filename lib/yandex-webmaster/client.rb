# encoding: utf-8

module Yandex
  module Webmaster
    class Client < Base
      def hosts(reload = false)
        @hosts = nil if reload
        @hosts ||= Yandex::Webmaster::ApiFactory.new({
          :klass => Yandex::Webmaster::Host,
          :url => '/hosts',
          :configuration => self.configuration
        })
      end
    end
  end
end