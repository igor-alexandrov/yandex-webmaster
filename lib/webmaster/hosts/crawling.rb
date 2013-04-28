# encoding: utf-8

module Webmaster
  module Hosts
    class Crawling < Base
      include Virtus

      STATES = [
        'indexed',
        'not_indexed',
        'waiting'
      ].freeze

      attribute :state, String

      attr_accessor :host

      def state=(value)
        value = value.downcase.underscore
        @state = value if STATES.include?(value)
      end
    end
  end
end
