# encoding: utf-8

module Webmaster
  module API
    class Hosts < Base
      # Lists all the hosts.
      #
      # = Examples
      #
      #  Webmaster.hosts.list
      #
      def list(*args)
        # arguments(args)

        # get_request("/hosts", arguments.params)
        self.objects_from_response(Webmaster::Host, self.request(:get, '/hosts'), :host)
      end
      alias :all :list

      # Get a host
      #
      # = Examples
      #
      #  webmaster = Webmaster.new
      #  webmaster.hosts.get(12341234)
      #
      def get(api, *args)
        arguments(args, :required => [:user, :repo])
        params = arguments.params

        get_request("/repos/#{user}/#{repo}", params)
      end
      alias :find :get

      def object_from_response(klass, response)

      end

      def objects_from_response(klass, response, prefix)
        begin        
          self.objects_from_array(klass, response.body.symbolize_keys![prefix])
        rescue
          nil
        end
      end

      # @param klass [Class]
      # @param array [Array]      
      # @return [Array<Class>]
      def objects_from_array(klass, array)
        array.map do |element|
          klass.new(element)
        end
      end
    end
  end
end
