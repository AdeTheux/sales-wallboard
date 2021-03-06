module Features
  module SessionHelpers
    def sign_in(_user = nil)
      user = _user or create(:user)

      visit new_user_session_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_button 'Sign in'
    end
  end
end
