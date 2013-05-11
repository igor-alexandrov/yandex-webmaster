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

        attr :index_count, Integer, :writer => :protected
        attr :last_week_index_urls, Array, :writer => :protected

        attr :internal_links_count, Integer, :writer => :protected

        attr :links_count, Integer, :writer => :protected
        attr :last_week_links, Array, :writer => :protected

        attr :total_shows_count, Integer, :writer => :protected
        attr :top_shows_percent, Float, :writer => :protected
        attr :top_shows, Array, :writer => :protected

        attr :total_clicks_count, Integer, :writer => :protected
        attr :top_clicks_percent, Float, :writer => :protected
        attr :top_clicks, Array, :writer => :protected

        attr :verification, Yandex::Webmaster::Hosts::Verification, :writer => :protected
        attr :crawling, Yandex::Webmaster::Hosts::Crawling, :writer => :protected

        attr :sitemaps, Array, :writer => :protected
      end

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
        @verification = nil if reload

        self.load_verification if @verification.nil?
        @verification
      end

      def load_verification
        self.validate_resource!(:verify_host)

        self.verification = self.fetch_value(self.request(:get, self.resources[:verify_host]), :verification)
        self
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

      # Load information about indexed urls for the host
      # @return [Yandex::Webmaster::Host]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/hosts-indexed.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/hosts-indexed.xml
      #
      def load_indexed_urls
        self.validate_resource!(:indexed_urls)

        self.attributes = self.request(:get, self.resources[:indexed_urls]).body
        self
      end

      # Load information about incoming links for the host
      # @return [Yandex::Webmaster::Host]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/host-links.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/host-links.xml
      #
      def load_incoming_links
        self.validate_resource!(:incoming_links)

        self.attributes = self.request(:get, self.resources[:incoming_links]).body
        self
      end

      # Load information about top queries for the host
      # @return [Yandex::Webmaster::Host]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/host-tops.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/host-tops.xml
      #
      def load_top_queries
        self.validate_resource!(:top_queries)

        self.attributes = self.fetch_value(self.request(:get, self.resources[:top_queries]), :top_queries)
        self        
      end

      # Get(load) list of sitemap files for the host
      # @return [Yandex::Webmaster::Host]
      # [RU] http://api.yandex.ru/webmaster/doc/dg/reference/sitemaps.xml
      # [EN] http://api.yandex.com/webmaster/doc/dg/reference/sitemaps.xml
      #
      def sitemaps(reload = false)
        @sitemaps = nil if reload

        self.load_sitemaps if @sitemaps.nil?
        @sitemaps        
      end

      def load_sitemaps
        self.validate_resource!(:sitemaps)
        
        self.sitemaps = self.fetch_value(self.request(:get, self.resources[:sitemaps]), :sitemap)
        self
      end

    protected

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

      def top_shows=(value)
        array = value.is_a?(Hash) ? value[:top_info] : value
        @top_shows = self.objects_from_array(Yandex::Webmaster::Hosts::TopInfo, array)
      end

      def top_clicks=(value)
        array = value.is_a?(Hash) ? value[:top_info] : value
        @top_clicks = self.objects_from_array(Yandex::Webmaster::Hosts::TopInfo, array)
      end

      def sitemaps=(value)
        array = Array.wrap(value).flatten
        @sitemaps = self.objects_from_array(Yandex::Webmaster::Hosts::Sitemap, array)
      end
    end
  end
end