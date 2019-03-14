require 'notifications'
require 'pp'


class AdminsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_admin!

  def main
  end

  def notification
    @builtin_sounds = Notifications::SOUNDS
  end

  def notification_send
    type = params[:notiftype]
    big = (type != 'simple')
    music = nil
    if type == 'music'
      name = params[:music]
      if name == 'custom'
        music = params[:customfile]
      else
        music = Notifications::SOUNDS[name.to_sym]
      end
    end

    Notifications.send(params[:message], {
      :big => big,
      :sound => music
    })
    render :nothing => true
  end

  def login_as
    user = User.find_by_id(params[:id])
    if user.nil?
      flash[:alert] = "Could not find that user."
      return redirect_to users_path
    end

    session[:faked_user_by] = current_user.id
    sign_in user
    flash[:notice] = "Successfully signed in as #{user.name}."
    redirect_to '/'
  end

  protected

  def ensure_admin!
    redirect_to '/', :status => 404 unless current_user.is_admin
  end
end
