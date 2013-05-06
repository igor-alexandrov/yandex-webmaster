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
        attribute_name = args[0]

        Webmaster::Api::Attributes::ReaderBuilder.new(@object, attribute_name, type, options).define
        Webmaster::Api::Attributes::WriterBuilder.new(@object, attribute_name, type, options).define

        # reader_name = options.delete(:reader_name) || args[0]
        # writer_name = options.delete(:writer_name) || "#{args[0]}="
        # instance_variable_name = options.delete(:instance_variable_name) || "@#{args[0]}"

        self.add_attribute(args[0])

        # self.define_reader(reader_name, instance_variable_name)
        # self.define_reader_aliases(reader_name, type)

        # self.define_writer(writer_name, instance_variable_name, type)
        # self.define_writer_aliases(writer_name, type)
      end

    protected

      def self.determine_type(constant)
        case constant
        when ::Class
          return constant if constant < Webmaster::Api::Attributes::Types::Base

          self.determine_type_from_string(constant.to_s)
        else            
          self.determine_type_from_string(constant.to_s)
        end 
        
      end

      def self.determine_type_from_string(string)
        string = string.camelize if (string =~ /\w_\w/ || string[0].downcase == string[0])

        if Webmaster::Api::Attributes::Types.const_defined?(string)
          Webmaster::Api::Attributes::Types.const_get(string)
        elsif Object.const_defined?(string)
          Object.const_get(string)    
        else
          const_missing(string)
        end
      end

      def add_attribute(attribute_name)
        @object.send(self.options[:as]) << attribute_name.to_sym
      end      

      def define_reader(method_name, instance_variable_name)
        unless @object.method_defined?(method_name)
          @object.send :define_method, method_name do
            instance_variable_get(instance_variable_name)
          end
        end
      end

      def define_reader_aliases(method_name, klass)
        if klass.respond_to?(:default_reader_aliases)
          klass.default_reader_aliases(method_name).each do |alias_method_name|
            @object.send(:alias_method, alias_method_name, method_name)
          end
        end
      end

      def define_writer(method_name, instance_variable_name, klass)
        unless @object.method_defined?(method_name)
          @object.send :define_method, method_name do |value|
            value = klass.respond_to?(:typecast) ? klass.typecast(value) : klass.new(value)
            instance_variable_set(instance_variable_name, value)
          end          
        end
      end

      def define_writer_aliases(method_name, klass)
        if klass.respond_to?(:default_writer_aliases)
          klass.default_writer_aliases(method_name).each do |alias_method_name|
            @object.send(:alias_method, alias_method_name, method_name)
          end
        end
      end
    end
  end
end
