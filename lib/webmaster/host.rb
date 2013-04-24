# encoding: utf-8

module Webmaster
  class Host

    attr_accessor :href, :name, :verification, :crawling, :virused, :last_access, :tcy, :url_count, :index_count

    def initialize(attributes = {})
      self.attributes = attributes
    end

    def attributes=(attributes = {})
      attributes.each do |attr,value|
        self.send("#{attr}=", value) if self.respond_to?("#{attr}=")
      end
    end
  end
end
