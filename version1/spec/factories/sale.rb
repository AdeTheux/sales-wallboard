FactoryGirl.define do
  factory :sale do
    arr 0
    date Date.today
    company 'Salesforce'

    association :user, factory: :user_with_current_assignation
  end
end
