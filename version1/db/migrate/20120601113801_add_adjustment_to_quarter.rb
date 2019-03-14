class AddAdjustmentToQuarter < ActiveRecord::Migration
  def change
    add_column :quarters, :adjustment, :float, :default => 0.0
  end
end
