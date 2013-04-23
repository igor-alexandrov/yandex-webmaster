# encoding: utf-8

module Webmaster
  class ApiFactory

    attr_accessor :klass, :options

    # Instantiates a new Yandex.Webmaster api object
    #
    def initialize(klass, options={}, &block)      
      raise ArgumentError, 'must provide API class to be instantiated' if klass.blank?
      
      @klass = klass
      @options = options

      return self
    end

    def method_missing(method, *args, &block) # :nodoc:
      if self.klass.present?
        instance = self.create_instance(self.klass, self.options, &block)        
        return instance.send(method, args, &block) if instance.respond_to?(method)
      end

      super
    end

    # Passes configuration options to instantiated class
    #
    def create_instance(klass, options, &block)
      options.symbolize_keys!
      convert_to_constant(klass.to_s).new options, &block
    end

    # Convert name to constant
    #
    def convert_to_constant(classes)
      classes.split('::').inject(Webmaster) do |constant, klass|
        constant.const_get klass
      end
    end

  end
end
