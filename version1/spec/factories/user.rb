FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email#{n}@zendesk.com" }
    password '123456'
    password_confirmation '123456'

    factory :user_with_current_assignation do
      after(:create) do |user|
        quarter = FactoryGirl.create(:current_quarter)
        FactoryGirl.create(:assignation, user: user, quarter: quarter)
      end
    end
  end
end
