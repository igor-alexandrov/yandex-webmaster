# encoding: utf-8

module Yandex
  module Webmaster
    module Api
      class AttributesBuilder
        attr_reader :klass, :options

        def initialize(object, options, &block)
          @object = object
          @options = options

          raise ArgumentError.new('Missing options[:as] value' ) if @options[:as].blank?

          self.instance_eval(&block)
        end

        def attr(*args)
          options = args.extract_options!

          type = self.class.determine_type(options.delete(:type) || args[1])
          attribute_name = args[0].to_s

          reader_builder = Yandex::Webmaster::Api::Attributes::ReaderBuilder.new(@object, attribute_name, type, options)
          writer_builder = Yandex::Webmaster::Api::Attributes::WriterBuilder.new(@object, attribute_name, type, options)
          self.add_attribute(attribute_name, reader_builder, writer_builder)

          reader_builder.define_method.define_aliases
          writer_builder.define_method.define_aliases        
        end

      protected

        def self.determine_type(constant)
          case constant
          when ::Class
            return constant if constant < Yandex::Webmaster::Api::Attributes::Types::Base

            self.determine_type_from_string(constant.to_s)
          else            
            self.determine_type_from_string(constant.to_s)
          end 
          
        end

        def self.determine_type_from_string(string)
          string = string.camelize if (string =~ /\w_\w/ || string[0].downcase == string[0])

          if Yandex::Webmaster::Api::Attributes::Types.const_defined?(string)
            Yandex::Webmaster::Api::Attributes::Types.const_get(string)
          elsif Object.const_defined?(string)
            Object.const_get(string)    
          else
            const_missing(string)
          end
        end

        def add_attribute(attribute_name, reader_builder, writer_builder)        
          @object.send(self.options[:as])[attribute_name.to_sym] = {
            :reader_name => reader_builder.method_name,
            :writer_name => writer_builder.method_name,
            :instance_variable_name => writer_builder.instance_variable_name
          }      
        end
      end
    end
  end
end