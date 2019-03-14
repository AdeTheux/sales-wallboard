class Users::SessionsController < Devise::SessionsController
  def destroy
    previous_id = session[:faked_user_by]
    resp = super
    # If the current session was successfully destroyed and we are actually faking a
    # session.
    if flash[:notice] && previous_id
      user = User.find(previous_id)
      sign_in user
      session[:faked_user_by] = nil
      flash[:notice] = "Sucessfully reverted to your admin session."
    end

    return resp
  end
end
