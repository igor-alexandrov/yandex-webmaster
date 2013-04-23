module Webmaster
  class Client < API
    def hosts(options={}, &block)
      @hosts ||= ApiFactory.new('Host', current_options.merge(options), &block)
    end
  end
end