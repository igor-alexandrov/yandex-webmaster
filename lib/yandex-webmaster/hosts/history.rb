# encoding: utf-8

# Information about history for the host
# @return [Hash: {date => value}]
#
# TIC History
# [RU] http://api.yandex.ru/webmaster/doc/dg/reference/history-tic.xml
# [EN] http://api.yandex.com/webmaster/doc/dg/reference/history-tic.xml
#
# History of Incoming Links 
# [RU] http://api.yandex.ru/webmaster/doc/dg/reference/history-incoming-links.xml
# [EN] http://api.yandex.com/webmaster/doc/dg/reference/history-incoming-links.xml
#
# History of the number of URLs accessed by the robot
# [RU] http://api.yandex.ru/webmaster/doc/dg/reference/history-crawled-urls.xml
# [EN] http://api.yandex.com/webmaster/doc/dg/reference/history-crawled-urls.xml
#
# History of the number of indexed URLs
# [RU] http://api.yandex.ru/webmaster/doc/dg/reference/history-indexed-urls.xml
# [EN] http://api.yandex.com/webmaster/doc/dg/reference/history-indexed-urls.xml
#
# History of of excluded URLs
# [RU] http://api.yandex.ru/webmaster/doc/dg/reference/history-excluded-urls.xml
# [EN] http://api.yandex.com/webmaster/doc/dg/reference/history-excluded-urls.xml

module Yandex
  module Webmaster
    module Hosts
      class History < Base

        define_attributes :as => 'api_attributes' do
          attr :tic, Hash, :writer => :protected
          attr :incoming_links, Hash, :writer => :protected
          attr :crawled_urls, Hash, :writer => :protected
          attr :indexed_urls, Hash, :writer => :protected
          attr :excluded_urls, Hash, :writer => :protected
        end

        attr_accessor :host

        class << self

          protected

          def define_attribute_load_method(attribute)
            define_method "load_#{attribute.name}" do
              resource = :"#{attribute.name}_history"

              self.host.send(:validate_resource!, resource)
              self.send(attribute.writer_method_name, self.fetch_value(self.host.request(:get, host.resources[resource]), :value))

              self
            end

            protected "load_#{attribute.name}"
          end

          def define_attribute_reader(attribute)
            define_method attribute.reader_method_name do |reload = false|
              if reload || !self.instance_variable_defined?(attribute.instance_variable_name)
                self.send("load_#{attribute.name}") 
              end

              self.instance_variable_get(attribute.instance_variable_name)
            end
          end

          def define_attribute_writer(attribute)
            define_method attribute.writer_method_name do |value|
              value = value.inject({}) { |memo, hash| memo[hash[:date]] = hash[:value].to_i; memo }
              self.instance_variable_set(attribute.instance_variable_name, value)
            end
          end

        end

        self.api_attributes.values.each do |attribute|
          define_attribute_load_method(attribute)
          define_attribute_reader(attribute)
          define_attribute_writer(attribute)
        end
      end
    end
  end
end