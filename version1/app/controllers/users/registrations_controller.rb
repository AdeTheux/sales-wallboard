class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :cancel ]
  before_filter :ensure_admin!, :only => [ :index, :new, :destroy ]

  def index
    @users = User.all
  end
  def new
    @user = User.new
  end

  def show
    @user = User.find params[:id]
  end

  def edit
    @admin_view = current_user.is_admin?
    if @admin_view && !params[:id].blank?
      @user ||= User.find params[:id]
      if @user.id != params[:id]
        @user = User.find params[:id]
      end
    else
      super
    end
  end

  def update
    params[:user].delete('utf-8')
    @admin_view = current_user.is_admin?
    @user = User.find params[:id]

    if @admin_view || @user.id == current_user.id

      if @admin_view
        if params[:user]['password_confirmation'] == params[:user]['password']
          if params[:user]['password'].blank?
            params[:user].delete('password')
            params[:user].delete('password_confirmation')
          end

          if @user.update_attributes(params[:user], :without_protection => true)
            redirect_to @user
          else
            render :action => 'edit'
          end
        else
          @user.errors.add(:password_confirmation, "Does not match")
          render :action => 'edit'
        end
      else
        @user.update_with_password(params[:user])
        clean_up_passwords @user
        if @user.errors.messages.blank?
          sign_in('user', @user, :bypass => true)
        end
        respond_with @user
      end

    else
      redirect_to '/'
    end
  end

  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        respond_with resource, :location => users_path
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "User has been deleted."
    redirect_to users_path
  end

  protected

  def ensure_admin!
    if not (current_user && current_user.is_admin)
      redirect_to '/', :status => 404
    end
  end
end
