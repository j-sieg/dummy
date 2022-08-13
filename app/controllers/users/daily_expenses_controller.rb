module Users
  class DailyExpensesController < ApplicationController
    before_action :set_date_viewed

    def index
    end

    private

    def set_date_viewed
      @date_viewed = Date.parse(params[:date])
    rescue
      @date_viewed = Date.current
    end
  end
end
