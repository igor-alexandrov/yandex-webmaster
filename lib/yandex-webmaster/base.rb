# encoding: utf-8

require 'yandex-webmaster/configuration'

require 'yandex-webmaster/authorization'
require 'yandex-webmaster/connection'
require 'yandex-webmaster/request'

require 'attrio'

module Yandex
  module Webmaster
    class Base
      include Authorization
      include Connection
      include Request
      include Attrio

      attr_accessor :configuration

      def initialize(attributes = {})
        self.attributes = attributes
      end

      def attributes=(attributes = {})
        unless attributes.nil?
          attributes.each do |attr,value|
            self.send("#{attr}=", value) if self.respond_to?("#{attr}=")
          end
        end
      end

      def configuration=(value)
        configuration_instance = Yandex::Webmaster::Configuration.instance
        configuration_instance.options = value unless value.is_a?(Yandex::Webmaster::Configuration)
        @configuration = configuration_instance
      end

      # Responds to attribute query or attribute clear
      def method_missing(method, *args, &block) # :nodoc:
        case method.to_s
        when /^(.*)\?$/
          return !!self.send($1.to_s)
        when /^clear_(.*)$/
          self.send("#{$1.to_s}=", nil)
        else
          super
        end
      end

      # Acts as setter and getter for api requests arguments parsing.
      #
      # Returns Arguments instance.
      #
      # def arguments(args=(not_set = true), options={}, &block)
      #   if not_set
      #     @arguments
      #   else
      #     @arguments = Arguments.new(self, options).parse(*args, &block)
      #   end
      # end

    protected

      def objects_from_response(klass, response, prefix)
        self.objects_from_array(klass, self.fetch_value(response, prefix))
      end

      def fetch_value(response, prefix)
        response.body[prefix]
      end

      # @param klass [Class]
      # @param array [Array]
      # @return [Array<Class>]
      def objects_from_array(klass, array)
        array = Helpers.to_a(array)
        array.map do |attributes|
          instance = klass.new
          instance.configuration = self.configuration
          instance.attributes = attributes
          instance
        end
      end
    end
  end
end
