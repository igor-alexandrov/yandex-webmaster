# encoding: utf-8

module Webmaster
  module Hosts
    class Crawling < Base

      STATES = [
        'indexed',
        'not_indexed',
        'waiting'
      ]

      include Virtus

      attribute :state, String

      def state=(value)
        value = value.downcase.underscore
        @state = value if STATES.include?(value)
      end
    end
  end
end
