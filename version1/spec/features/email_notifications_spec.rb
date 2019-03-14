require 'spec_helper'

feature 'Email Notifications' do
  scenario 'User enables email notifications' do
    user = create(:user)
    sign_in(user)

    visit edit_user_registration_path

    within('#edit_user') do
      check 'user_email_notification'
      fill_in 'user_current_password', with: 123456
      click_on 'Update your account details'
    end

    expect(user.reload.email_notification).to be_true
  end

  scenario 'User disables email notifications' do
    user = create(:user, email_notification: true)
    sign_in(user)

    visit edit_user_registration_path

    within('#edit_user') do
      uncheck 'user_email_notification'
      fill_in 'user_current_password', with: 123456
      click_on 'Update your account details'
    end

    expect(user.reload.email_notification).to be_false
  end
end
