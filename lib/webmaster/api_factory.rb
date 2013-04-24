# encoding: utf-8

module Webmaster
  class ApiFactory

    attr_accessor :klass, :options

    # Instantiates a new Yandex.Webmaster api object
    #
    def initialize(klass, options={}, &block)      
      raise ArgumentError, 'must provide API class to be instantiated' if klass.blank?
      
      @klass = klass
      @options = options.symbolize_keys!

      return self
    end

    def method_missing(method, *args, &block) # :nodoc:
      if self.klass.present?
        instance = self.create_instance(&block)        
        return instance.send(method, args, &block) if instance.respond_to?(method)
      end

      super
    end

  protected

    # Passes configuration options to instantiated class
    #
    def create_instance(&block)
      self.convert_to_constant(self.klass.to_s).new(self.options, &block)
    end

    # Convert name to constant
    #
    def convert_to_constant(classes)
      classes.split('::').inject(Webmaster::API) do |constant, klass|
        constant.const_get klass
      end
    end

  end
end
