# encoding: utf-8

require 'forwardable'

module Yandex
  module Webmaster
    class Host < Base
      extend Forwardable
      
      define_attributes :as => 'api_attributes' do
        attr :href, String, :writer => :protected
        attr :name, String, :writer => :protected
        attr :virused, Boolean, :writer => :protected
        attr :last_access, DateTime, :writer => :protected
        attr :tcy, Integer, :writer => :protected

        attr :url_count, Integer, :writer => :protected
        attr :url_errors, Integer, :writer => :protected

        attr :internal_links_count, Integer, :writer => :protected

        attr :indexed_urls, Yandex::Webmaster::Hosts::IndexedUrls, :writer => :protected
        attr :incoming_links, Yandex::Webmaster::Hosts::IncomingLinks, :writer => :protected
        attr :top_queries, Yandex::Webmaster::Hosts::TopQueries, :writer => :protected

        attr :verification, Yandex::Webmaster::Hosts::Verification, :writer => :protected
        attr :crawling, Yandex::Webmaster::Hosts::Crawling, :writer => :protected

        attr :sitemaps, Array, :writer => :protected
      end

      delegate :verified? => :verification

      def self.create(name, factory)
        xml = "<host><name>#{name}</name></host>"
        response = factory.request(:post, '/hosts', xml)
        if response.status.to_i == 201
          self.new({
            :href => response.headers['Location'],
            :configuration => factory.configuration
          })          
        end
      end

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

      # Delete information about the host from Yandex.Webmaster
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-delete.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-delete.xml
      # 
      def delete            
        response = self.request(:delete, self.href)
        @deleted = true if response.status.to_i == 204        
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
      # @return [Yandex::Webmaster::Hosts::Verification]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-verify.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-verify.xml
      def verification(reload = false)
        self.load_verification if reload || @verification.nil?
        @verification
      end

      # Load stats for the host
      # @return [Yandex::Webmaster::Host]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-stats.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-stats.xml
      #
      def load_stats
        self.validate_resource!(:host_information)

        self.attributes = self.request(:get, self.resources[:host_information]).body
        self
      end

      # Information about indexed urls for the host
      # @return [Yandex::Webmaster::Hosts::IndexedUrls]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-indexed.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-indexed.xml
      #
      def indexed_urls(reload = false)
        self.load_indexed_urls if reload || @indexed_urls.nil?
        @indexed_urls
      end

      # Information about incoming links for the host
      # @return [Yandex::Webmaster::Hosts::IncomingLinks]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/host-links.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/host-links.xml
      #
      def incoming_links(reload = false)
        self.load_incoming_links if reload || @incoming_links.nil?
        @incoming_links
      end

      # Information about top queries for the host
      # @return [Yandex::Webmaster::Hosts::TopQueries]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/host-tops.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/host-tops.xml
      #
      def top_queries(reload = false)
        self.load_top_queries if reload || @top_queries.nil?
        @top_queries
      end

      # Get(load) list of sitemap files for the host
      # @return [Yandex::Webmaster::Host]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/sitemaps.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/sitemaps.xml
      #
      def sitemaps(reload = false)
        self.load_sitemaps if reload || @sitemaps.nil?
        @sitemaps
      end

    protected

      def load_verification
        self.validate_resource!(:verify_host)

        self.verification = self.fetch_value(self.request(:get, self.resources[:verify_host]), :verification)
        self
      end

      def load_indexed_urls
        self.validate_resource!(:indexed_urls)

        self.indexed_urls = self.request(:get, self.resources[:indexed_urls]).body
        self
      end

      def load_incoming_links
        self.validate_resource!(:incoming_links)

        self.incoming_links = self.request(:get, self.resources[:incoming_links]).body
        self
      end

      def load_top_queries
        self.validate_resource!(:top_queries)

        self.top_queries = self.fetch_value(self.request(:get, self.resources[:top_queries]), :top_queries)
        self        
      end

      def load_sitemaps
        self.validate_resource!(:sitemaps)
        
        self.sitemaps = self.fetch_value(self.request(:get, self.resources[:sitemaps]), :sitemap)
        self
      end

      def validate_resource!(resource)
        unless self.resources.keys.include?(resource)
          raise Yandex::Webmaster::Errors::ResourceError.new("Resource '#{resource.to_s}' is not available for the host")
        end
      end

      def verification=(value)
        @verification = value.is_a?(Yandex::Webmaster::Hosts::Verification) ? value : Yandex::Webmaster::Hosts::Verification.new(value)
        @verification.host = self
        @verification.configuration = self.configuration
        @verification
      end

      def crawling=(value)      
        @crawling = Yandex::Webmaster::Hosts::Crawling.new(value)
        @crawling.host = self
        @crawling.configuration = self.configuration
        @crawling
      end

      def indexed_urls=(value)
        @indexed_urls = Yandex::Webmaster::Hosts::IndexedUrls.new(value)
        @indexed_urls.host = self
        @indexed_urls.configuration = self.configuration
        @indexed_urls
      end

      def incoming_links=(value)
        @incoming_links = Yandex::Webmaster::Hosts::IncomingLinks.new(value)
        @incoming_links.host = self
        @incoming_links.configuration = self.configuration
        @incoming_links
      end

      def top_queries=(value)
        @top_queries = Yandex::Webmaster::Hosts::TopQueries.new(value)
        @top_queries.host = self
        @top_queries.configuration = self.configuration
        @top_queries
      end

      def top_shows=(value)
        array = value.is_a?(Hash) ? value[:top_info] : value
        @top_shows = self.objects_from_array(Yandex::Webmaster::Hosts::TopInfo, array)
      end

      def top_clicks=(value)
        array = value.is_a?(Hash) ? value[:top_info] : value
        @top_clicks = self.objects_from_array(Yandex::Webmaster::Hosts::TopInfo, array)
      end

      def sitemaps=(value)
        array = Helpers.to_a(value).flatten
        @sitemaps = self.objects_from_array(Yandex::Webmaster::Hosts::Sitemap, array)
      end
    end
  end
end