# encoding: utf-8

module Yandex
  module Webmaster
    module Api
      module Attributes
        module Types
          autoload :Base, 'yandex-webmaster/api/attributes/types/base'
          autoload :Boolean, 'yandex-webmaster/api/attributes/types/boolean'
          autoload :Date, 'yandex-webmaster/api/attributes/types/date'
          autoload :DateTime, 'yandex-webmaster/api/attributes/types/date_time'
          autoload :Float, 'yandex-webmaster/api/attributes/types/float'
          autoload :Integer, 'yandex-webmaster/api/attributes/types/integer'
          autoload :Symbol, 'yandex-webmaster/api/attributes/types/symbol'
          autoload :Time, 'yandex-webmaster/api/attributes/types/time'
        end
        
        autoload :ReaderBuilder, 'yandex-webmaster/api/attributes/reader_builder'
        autoload :WriterBuilder, 'yandex-webmaster/api/attributes/writer_builder'
      end
    end
  end
end