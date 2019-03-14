class Assignation < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :quarter
  belongs_to :user

  attr_accessible :target, :user_id, :quarter, :month_target_1, :month_target_2,
                  :month_target_3

  def mrr
    target.to_f/12
  end

  def target
    month_target_1 + month_target_2 + month_target_3
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
end
