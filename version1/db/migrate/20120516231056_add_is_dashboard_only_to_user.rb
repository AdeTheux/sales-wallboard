class AddIsDashboardOnlyToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_dashboard_only, :boolean, :default => false
  end
end
