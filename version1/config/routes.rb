EmeaSentry::Application.routes.draw do
  resources :helpdesk, :only => [:create, :index, :new] do
    collection do
      get :login
    end
  end

  resources :admins
  resources :sales
  resources :quarters

  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }

  devise_scope :user do
    match '/users/' => 'users/registrations#index'
    match '/users/:id' => 'users/registrations#update', :as => 'update_user', :via => :put
    match '/users/:id' => 'users/registrations#destroy', :as => 'destroy_user', :via => :delete
    match '/users/:id/' => 'users/registrations#show', :as => 'user'
    match '/users/:id/edit' => 'users/registrations#edit', :as => 'edit_user'
  end

  root :to => "dashboard#index"
  match '/admin/' => "admins#main", :as => 'admin_main'
  match '/admin/login_as/:id/' => "admins#login_as", :as => "admin_loginas"
  match '/admin/notification/' => 'admins#notification', :as => 'admin_notification'
  match '/admin/notification/send' => 'admins#notification_send', :via => :post
end
