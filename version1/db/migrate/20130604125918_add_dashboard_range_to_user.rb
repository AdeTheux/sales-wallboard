class AddDashboardRangeToUser < ActiveRecord::Migration
  def change
    add_column :users, :dashboard_range, :string, default: 'month'
  end
end
