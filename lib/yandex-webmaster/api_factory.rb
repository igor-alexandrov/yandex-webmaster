module Yandex
  module Webmaster
    class ApiFactory < Base
      extend Forwardable

      def_delegators :to_a, :to_xml, :to_yaml, :length, :collect, :map, :each, :all?, :include?, :to_ary

      attr_accessor :klass, :url

      def respond_to?(method, include_private = false)
        super || Array.method_defined?(method) || @klass.respond_to?(method, include_private)
      end  

      def method_missing(method, *args, &block)      
        if @klass.respond_to?(method)
          args = args.push(self)
          @klass.send(method, *args, &block)
        elsif Array.method_defined?(method)
          self.class.def_delegator :to_a, method
          self.to_a.send(method, *args, &block)
        else
          super
        end
      end

      def to_a
        @objects ||= self.objects_from_response(self.klass, self.request(:get, self.url), :host)      
      end
      alias :all :to_a
    end
  end
end
