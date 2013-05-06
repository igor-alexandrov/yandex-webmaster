module Webmaster
  module Api
    module Attributes
      module Types
        autoload :Base, 'webmaster/api/attributes/types/base'
        autoload :Boolean, 'webmaster/api/attributes/types/boolean'
        autoload :Date, 'webmaster/api/attributes/types/date'
        autoload :DateTime, 'webmaster/api/attributes/types/date_time'
        autoload :Float, 'webmaster/api/attributes/types/float'
        autoload :Integer, 'webmaster/api/attributes/types/integer'
        autoload :Symbol, 'webmaster/api/attributes/types/symbol'
        autoload :Time, 'webmaster/api/attributes/types/time'
      end
      
      autoload :ReaderBuilder, 'webmaster/api/attributes/reader_builder'
      autoload :WriterBuilder, 'webmaster/api/attributes/writer_builder'
    end
  end
end