# encoding: utf-8

module Webmaster
  class Host < Base
    include Virtus

    attribute :href, String
    attribute :name, String
    attribute :virused, Boolean
    attribute :last_access, DateTime
    attribute :tcy, Integer
    attribute :url_count, Integer
    attribute :url_errors, Integer
    attribute :index_count, Integer
    attribute :internal_links_count, Integer
    attribute :links_count, Integer

    attr_accessor :verification, :crawling

    # Get id of the host
    #
    def id
      return @id if defined?(@id)
      @id = self.href.match(/\/(\d+)\z/)[1].to_i
    end

    # Load information about resources that are available for the host
    # 
    def resources
      return @resources if defined?(@resources)

      @resources = self.fetch_value(self.request(:get, self.href), :link).inject({}) do |h, resource|
        h[resource[:rel].underscore.to_sym] = resource[:href]; h        
      end
    end

    # Load information about verification for the host
    #
    def verify
      self.verification = self.fetch_value(self.request(:get, self.resources[:verify_host]), :verification)
      self.verification
    end

    def verification=(value)      
      @verification = Webmaster::Hosts::Verification.new(value)
      @verification.configuration = self.configuration
      @verification
    end

    # Load stats for the host
    # http://api.yandex.ru/webmaster/doc/dg/reference/hosts-stats.xml
    #
    def stats
      self.attributes = self.request(:get, self.resources[:host_information]).body
      self
    end
    
  end
end
