# encoding: utf-8

require 'yandex-webmaster/configuration'

require 'yandex-webmaster/authorization'
require 'yandex-webmaster/connection'
require 'yandex-webmaster/request'

module Yandex
  module Webmaster
    class Base
      include Authorization
      include Connection
      include Request

      class << self
        def define_attributes(options = {}, &block)
          options[:as] ||= :attributes        
          
          cattr_accessor options[:as].to_sym
          class_eval(<<-EOS, __FILE__, __LINE__ + 1)          
            @@#{options[:as].to_s} ||= {}
          EOS

          unless options[:inspect] == false          
            define_method(:inspect) do
              inspection = self.send(options[:as].to_s).map { |key, value|              
                self.inspect_attribute(key, value[:instance_variable_name])
              }.compact.join(', ')

              "#<#{self.class} #{inspection}>"
            end

            define_method(:inspect_attribute) do |attribute_name, instance_variable_name|
              value = instance_variable_get(instance_variable_name.to_s)

              if value.is_a?(String) && value.length > 50
                "#{attribute_name.to_s}(#{value.size}): " + "#{value[0..50]}...".inspect
              elsif value.is_a?(Array) && value.length > 5
                "#{attribute_name.to_s}(#{value.size}): " + "#{value[0..5]}...".inspect
              else
                "#{attribute_name.to_s}: " + value.inspect
              end
            end
            
          end

          Yandex::Webmaster::Api::AttributesBuilder.new(self, options, &block)
        end

        def const_missing(name)
          Yandex::Webmaster::Api::AttributesBuilder.cast_type(name) || super
        end
      end

      attr_accessor :configuration

      def initialize(attributes = {})
        self.configuration ||= Yandex::Webmaster::Configuration.new.setup(attributes.delete(:configuration) || {})
        self.attributes = attributes
      end

      def attributes=(attributes = {})
        attributes.each do |attr,value|
          self.send("#{attr}=", value) if self.respond_to?("#{attr}=")
        end
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