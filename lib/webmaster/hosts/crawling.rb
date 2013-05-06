# encoding: utf-8

module Webmaster
  module Hosts
    class Crawling < Base
      STATES = [
        'indexed',
        'not_indexed',
        'waiting'
      ].freeze

      attr_accessor :host, :state

      def state=(value)
        value = value.downcase.underscore
        @state = value if STATES.include?(value)
      end
    end
  end
end
