class AddMonthsTargetsForSalesToQuarter < ActiveRecord::Migration
  def change
    rename_column :assignations, :target, :month_target_1
    add_column :assignations, :month_target_2, :float
    add_column :assignations, :month_target_3, :float
    Assignation.all.each do |assignation|
      if assignation.month_target_1
        value = assignation.month_target_1/3.0
        assignation.update_attributes!(:month_target_1 => value,
                                       :month_target_2 => value,
                                       :month_target_3 => value)
      end
    end
  end
end
