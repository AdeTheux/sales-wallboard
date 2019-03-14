FactoryGirl.define do
  factory :quarter do
    begin_date Date.yesterday
    end_date Date.yesterday + 20.days

    month_target_1 0
    month_target_2 0
    month_target_3 0

    factory :current_quarter do
      current true
    end
  end
end
