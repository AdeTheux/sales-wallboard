class SaleStatistic
  def mrr_remaining_monthly
    today = Date.today
    first_day = Date.civil(today.year, today.month, 1)
    last_day = Date.civil(today.year, today.month, -1)

    mrr_total_monthly - (Sale.where(['date between ? and ?', first_day, last_day]).sum(:arr).to_f / 12.0)
  end

  def mrr_total_monthly
    quarter.month_mrr
  end

  def mrr_remaining_quarterly
    quarter.mrr - quarter.done_arr / 12.0
  end

  def mrr_total_quarterly
    quarter.mrr
  end

  private
  def quarter
    @quarter ||= Quarter.current.first
  end
end
