require 'spec_helper'

feature 'User Dashboard Range' do
  before do
    user = create(:user)
    create(:current_quarter)
    sign_in(user)
  end

  scenario 'User chooses Month range' do
    visit edit_user_registration_path

    within('#edit_user') do
      select('month', from: 'Dashboard range')
      fill_in 'user_current_password', with: 123456
      click_on 'Update your account details'
    end

    visit root_path

    expect(page.find('#dashboard_range').value).to eql "month"
  end

  scenario 'User chooses quarter range' do
    visit edit_user_registration_path

    within('#edit_user') do
      select('quarter', from: 'Dashboard range')
      fill_in 'user_current_password', with: 123456
      click_on 'Update your account details'
    end

    visit root_path

    expect(page.find('#dashboard_range').value).to eql "quarter"
  end
end
