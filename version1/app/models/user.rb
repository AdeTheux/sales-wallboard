class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :is_admin, :name, :email_notification
  attr_accessible :is_dashboard_only, :dashboard_range

  has_many :assignations
  has_many :sales
  # attr_accessible :title, :body
  #
  scope :subscribed_to_email_notifications, -> { where(email_notification: true) }

  DashboardRange = %W(quarter month)

  def current_assignation
    current_quarter = Quarter.where(current: true).first
    assignations.where(quarter_id: current_quarter.id).first
  end

  def part_of_quarter?
    !current_assignation.nil?
  end

  def done_arr_month
    today = Date.today
    first_day = Date.civil(today.year, today.month, 1)
    last_day = Date.civil(today.year, today.month, -1)
    sales.where(['date between ? and ?', first_day, last_day]).sum(:arr).to_f
  end

  def has_reached_month_target?
    (done_arr_month / current_assignation.target) >= 1
  end

  def username
    name || email
  end
end
