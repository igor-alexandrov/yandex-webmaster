module Webmaster
  module Helpers
    autoload :Authorization, 'webmaster/helpers/authorization'

    include Webmaster::Helpers::Authorization    

  protected

    def format_params(params)  
      params[:date1] = self.format_date(params[:date1]) if params[:date1].present?
      params[:date2] = self.format_date(params[:date2]) if params[:date2].present?

      params
    end

    def format_date(date)
      date.is_a?(Date) || date.is_a?(DateTime) ? date.strftime('%Y%m%d') : date
    end
  end
end