class DashboardController < ApplicationController

  before_filter :authenticate_user!

  def index
    @quarter = Quarter.where(current: true).first
    if not @quarter.nil?
      # How far in time we are from the end of the quarter.
      @quarter_progress = @quarter.time_progress * 100

      # How far in time we are from the end of the month.
      today = Date.today
      first_day = Date.civil(today.year, today.month, 1)
      last_day = Date.civil(today.year, today.month, -1)
      total_month = (last_day - first_day).to_i + 1
      done = (today - first_day).to_i + 1
      @month_progress = done.to_f / total_month * 100

      # What the team has done during the quarter.
      @done_team_arr = @quarter.done_arr
      @percent_team_arr = @done_team_arr / @quarter.target * 100

      # What the team has done during the month.
      @done_team_arr_month = Sale.where(['date between ? and ?', first_day, last_day]).sum(:arr).to_f
      @percent_team_arr_month = @done_team_arr_month / @quarter.month_target * 100


      if current_user.current_assignation
        @done_you_arr = current_user.sales.where(['date between ? and ?', @quarter.begin_date, @quarter.end_date]).sum(:arr).to_f
        @percent_you_arr = @done_you_arr / current_user.current_assignation.target * 100

        @done_you_arr_month = current_user.done_arr_month
        @percent_you_arr_month = @done_you_arr_month / current_user.current_assignation.month_target * 100
      end

      @salesmen = User.all.select{ |u| u.part_of_quarter? }
      @salesmen = @salesmen.map do |salesman|
        salesman[:percentage_done] = ((salesman.done_arr_month / salesman.current_assignation.month_target) * 100)
        salesman # return
      end

      @salesmen = @salesmen.sort_by{ |u| u[:percentage_done] }.reverse!

      # floor after sorting (fixes an issue with rounding)
      @salesmen.each_with_index { |salesman, index| @salesmen[index][:percentage_done] = salesman[:percentage_done].floor }

    end

  end

end
