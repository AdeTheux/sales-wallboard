class Quarter < ActiveRecord::Base
  attr_accessible :begin_date, :end_date, :current, :target, :adjustment,
                  :month_target_1, :month_target_2, :month_target_3

  has_many :assignations

  scope :current, -> { where(current: true) }
  # target = arr

  def mrr
    target.to_f/12
  end

  def target
    month_target_1 + month_target_2 + month_target_3
  end

  def current_month_ratio
    # Compute the number of days in the current month over the number of days in the
    # whole quarter.
    today = Date.today
    first_day = Date.civil(today.year, today.month, 1)
    total_days = (end_date - begin_date).to_i
    total_month = (Date.civil(today.year, today.month, -1) - first_day).to_i + 1
    ratio = total_month.to_f / total_days
  end

  def current_month_number
    number = Date.today.month % 3
    if number == 0
      return 3
    else
      return number
    end
  end

  def month_target
    n = current_month_number
    self.send("month_target_#{n}".to_sym)
  end

  def month_mrr
    month_target.to_f/12
  end

  def month_1_mrr
    month_target_1.to_f/12
  end

  def month_2_mrr
    month_target_2.to_f/12
  end

  def month_3_mrr
    month_target_3.to_f/12
  end

  def is_user_assigned?(user)
    assignations.exists?(user_id: user.id)
  end

  def time_progress
    (begin_date - Date.today).to_i.to_f / (begin_date - end_date).to_i
  end

  def user_target(user)
    if is_user_assigned? user
      assignations.where(user_id: user.id).first.target
    else
      nil
   end
  end

  def user_month_target(user, n)
    if is_user_assigned? user
      assignations.where(user_id: user.id).first.send("month_target_#{n}")
    else
      nil
    end
  end

  def name
    "Q#{quarter_number + 1} - #{quarter_year}"
  end

  def quarter_number
    # Quarters starting months;
    # Q1 -> January -> 1
    # Q2 -> April -> 4
    # Q3 -> July -> 7
    # Q4 -> October -> 10
    if begin_date.nil?
      0
    else
      [1,4,7,10].index begin_date.month
    end
  end

  def quarter_year
    if begin_date.nil?
      Time.now.year
    else
      begin_date.year
    end
  end

  def set_from_quarter_number!(qn, year)
    return if !(0 <= qn && qn <= 3)
    qs = [1,4,7,10]
    self.begin_date = Date.civil(year, qs[qn], 1)
    self.end_date = Date.civil(year, qs[qn]+2, -1)
  end

  def done_arr
    Sale.where(['date between ? and ?', begin_date, end_date]).sum(:arr).to_f + adjustment*12
  end

  def is_quarter_target_reached?
    (done_arr / target) >= 1.0
  end

end
