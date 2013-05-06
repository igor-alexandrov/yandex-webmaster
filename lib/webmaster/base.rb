# encoding: utf-8

require 'webmaster/configuration'

require 'webmaster/api/authorization'
require 'webmaster/api/connection'
require 'webmaster/api/request'

module Webmaster
  class Base
    include Api::Authorization
    include Api::Connection
    include Api::Request

    class << self
      def define_attributes(options = {}, &block)
        options[:as] ||= :attributes        
        
        cattr_accessor options[:as].to_sym
        class_eval(<<-EOS, __FILE__, __LINE__ + 1)          
          @@#{options[:as].to_s} ||= []
        EOS

        unless options[:inspect] == false          
          define_method(:inspect) do
            inspection = self.send(options[:as].to_s).map { |attribute|
              value = self.instance_variable_get("@#{attribute.to_s}")
              value.present? ? "#{attribute}: #{value}" : "#{attribute}: nil"
            }.compact.join(', ')

            "#<#{self.class} #{inspection}>"
          end
        end

        Webmaster::Api::AttributesBuilder.new(self, options, &block)
      end

      def const_missing(name)
        Webmaster::Api::AttributesBuilder.determine_type(name) || super
      end
    end

    attr_accessor :configuration

    def initialize(attributes = {})
      self.configuration ||= Webmaster::Configuration.new.setup(attributes.delete(:configuration) || {})
      self.attributes = attributes
    end

    def attributes=(attributes = {})
      attributes.each do |attr,value|
        self.send("#{attr}=", value) if self.respond_to?("#{attr}=")
      end
    end



    # Configure options and process basic authorization    
    # def setup(options={})
    #   options = Webmaster.options.merge(options)
    #   self.current_options = options
    #   Configuration.keys.each do |key|
    #     send("#{key}=", options[key])
    #   end    
    # end

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
    def arguments(args=(not_set = true), options={}, &block)
      if not_set
        @arguments
      else
        @arguments = Arguments.new(self, options).parse(*args, &block)
      end
    end

    # Scope for passing request required arguments.
    #
    def with(args)
      case args
      when Hash
        set args
      when /.*\/.*/i
        user, repo = args.split('/')
        set :user => user, :repo => repo
      else
        ::Kernel.raise ArgumentError, 'This api does not support passed in arguments'
      end
    end

    # Set an option to a given value
    def set(option, value=(not_set=true), ignore_setter=false, &block)
      raise ArgumentError, 'value not set' if block and !not_set
      return self if !not_set and value.nil?

      if not_set
        set_options option
        return self
      end

      if respond_to?("#{option}=") and not ignore_setter
        return __send__("#{option}=", value)
      end

      define_accessors option, value
      self
    end

  protected

    # Set multiple options
    #
    def set_options(options)
      unless options.respond_to?(:each)
        raise ArgumentError, 'cannot iterate over value'
      end
      options.each { |key, value| set(key, value) }
    end

    def define_accessors(option, value)
      setter = proc { |val|  set option, val, true }
      getter = proc { value }

      define_singleton_method("#{option}=", setter) if setter
      define_singleton_method(option, getter) if getter
    end

    # Dynamically define a method for setting request option
    #
    def define_singleton_method(method_name, content=Proc.new)
      (class << self; self; end).class_eval do
        undef_method(method_name) if method_defined?(method_name)
        if String === content
          class_eval("def #{method_name}() #{content}; end")
        else
          define_method(method_name, &content)
        end
      end
    end

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
