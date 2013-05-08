# encoding: utf-8

module Yandex
  module Webmaster
    module Errors
      class WebmasterError < StandardError
        attr_reader :data

        def initialize(data)
          @data = data
          super
        end
      end

      class UnauthorizedError      < WebmasterError; end
      class GeneralError           < WebmasterError; end
      class AccessDeniedError      < WebmasterError; end
      class NoTokenError           < WebmasterError; end
      class NotFoundError          < WebmasterError; end
      class ResourceError          < WebmasterError; end
    end
  end
end