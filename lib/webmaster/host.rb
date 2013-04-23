# encoding: utf-8

module Webmaster
  class Host < API

    attr_reader :href, :name, :verification, :crawling, :virused, :last_access, :tcy, :url_count, :index_count

    def self.from_xml(document)

    end

    # Lists all the hosts.
    #
    # = Examples
    #
    #  Webmaster.hosts.list
    #
    def list(*args)
      # arguments(args)

      # get_request("/hosts", arguments.params)
      get_request("/hosts")
    end
    alias :all :list

    # Get a host
    #
    # = Examples
    #
    #  webmaster = Webmaster.new
    #  webmaster.hosts.get(12341234)
    #
    def get(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}", params)
    end
    alias :find :get

  end
end
