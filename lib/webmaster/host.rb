# encoding: utf-8

require 'forwardable'

module Webmaster
  class Host < Base
    extend Forwardable
    include Virtus

    attribute :href, String
    attribute :name, String
    attribute :virused, Boolean
    attribute :last_access, DateTime
    attribute :tcy, Integer

    attribute :url_count, Integer
    attribute :url_errors, Integer

    attribute :index_count, Integer
    attribute :last_week_index_urls, Array

    attribute :internal_links_count, Integer
    
    attribute :links_count, Integer
    attribute :last_week_links, Array

    attr_reader :crawling

    delegate :verified? => :verification

    # Id of the host
    # @return [Integer]
    #
    def id
      return @id if defined?(@id)
      @id = self.href.match(/\/(\d+)\z/)[1].to_i
    end

    # Load information about resources that are available for the host
    # @return [Hash]
    # 
    def resources
      return @resources if defined?(@resources)

      @resources = self.fetch_value(self.request(:get, self.href), :link).inject({}) do |h, resource|
        h[resource[:rel].underscore.to_sym] = resource[:href]; h        
      end
    end

    # Delete information about the host from Yandex.Market
    # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-delete.xml
    # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-delete.xml
    # 
    def delete            
      response = self.request(:delete, self.href)
      # @deleted = true if response.status.to_i == 204
      @deleted = true if response.status.to_i == 405
      self
    end

    # @return [Boolean]
    # 
    def deleted?
      !!@deleted
    end

    # Load information about verification for the host
    #
    def verify(type)
      self.validate_resource!(:verify_host)

      status = self.verification.run(type)
      @verification = nil

      status
    end

    # Information about verification for the host
    # @return [Webmaster::Hosts::Verification]
    # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-verify.xml
    # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-verify.xml
    def verification(reload = false)
      @verification = nil if reload

      if @verification.nil?        
        self.validate_resource!(:verify_host)
        self.verification = self.fetch_value(self.request(:get, self.resources[:verify_host]), :verification)
      end

      @verification
    end

    # Load stats for the host
    # @return [Webmaster::Host]
    # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-stats.xml
    # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-stats.xml
    #
    def stats
      self.validate_resource!(:host_information)

      self.attributes = self.request(:get, self.resources[:host_information]).body
      self
    end

    # Load information about indexed urls for the host
    # @return [Webmaster::Host]
    # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-indexed.xml
    # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-indexed.xml
    #
    def indexed_urls
      self.validate_resource!(:indexed_urls)

      self.attributes = self.request(:get, self.resources[:indexed_urls]).body
      self
    end

    # Load information about incoming links for the host
    # @return [Webmaster::Host]
    # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/host-links.xml
    # [EN] http://api.yandex.com/webmaster/doc/dg/reference/host-links.xml
    #
    def incoming_links
      self.validate_resource!(:incoming_links)

      self.attributes = self.request(:get, self.resources[:incoming_links]).body
      self
    end

  protected

    def validate_resource!(resource)
      unless self.resources.keys.include?(resource)
        raise Webmaster::Errors::ResourceError.new("Resource '#{resource.to_s}' is not available for the host")
      end
    end

  private

    def verification=(value)      
      @verification = value.is_a?(Webmaster::Hosts::Verification) ? value : Webmaster::Hosts::Verification.new(value)
      @verification.host = self
      @verification.configuration = self.configuration
      @verification
    end

    def crawling=(value)      
      @crawling = Webmaster::Hosts::Crawling.new(value)
      @crawling.host = self
      @crawling.configuration = self.configuration
      @crawling
    end

  end
end
