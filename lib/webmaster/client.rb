module Webmaster
  class Client < Base
    def hosts(options={}, &block)
      @hosts ||= ApiFactory.new('Hosts', current_options.merge(options), &block)
    end
  end
end