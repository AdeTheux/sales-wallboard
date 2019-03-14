class AddMonthsTargetsToQuarter < ActiveRecord::Migration
  def change
    rename_column :quarters, :target, :month_target_1
    add_column :quarters, :month_target_2, :float
    add_column :quarters, :month_target_3, :float
    Quarter.all.each do |quarter|
      value = quarter.month_target_1/3.0
      quarter.update_attributes!(:month_target_1 => value,
                                 :month_target_2 => value,
                                 :month_target_3 => value)
    end
  end
end
