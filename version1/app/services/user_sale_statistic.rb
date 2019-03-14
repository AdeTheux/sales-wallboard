class UserSaleStatistic
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def quarter_target
    user.current_assignation.mrr
  end

  def quarter_target_done
    user.sales.where(['date between ? and ?', quarter.begin_date, quarter.end_date]).sum(:arr).to_f/12.0
  end

  def quarter_target_remaining
    quarter_target - quarter_target_done
  end

  def month_target
    user.current_assignation.month_mrr
  end

  def month_target_done
    user.done_arr_month / 12.0
  end

  def month_target_remaining
    month_target - month_target_done
  end

  private
  def quarter
    @quarter ||= Quarter.current.first
  end
end
