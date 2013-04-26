# encoding: utf-8

module Webmaster
  module Hosts
    class Verification < Base

      STATES = [
        'in_progress',
        'never_verified',
        'verification_failed',
        'verified',
        'waiting'
      ]

      TYPES = [
        'auto',
        'dns_record',
        'html_file',
        'manual',
        'meta_tag',
        'pdd',
        'txt_file',
        'pdd_external',
        'delegation',
        'whois'
      ]

      include Virtus

      attribute :state, String
      attribute :type, String
      
      attribute :possible_to_cancel, Boolean
      attribute :date, Date      

      def state=(value)
        value = value.downcase.underscore
        @state = value if STATES.include?(value)
      end

      def type=(value)
        value = value.downcase.underscore
        @type = value if TYPES.include?(value)
      end
    end
  end
end
