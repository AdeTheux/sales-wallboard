class CreateAssignations < ActiveRecord::Migration
  def change
    create_table :assignations do |t|
      t.integer :user_id
      t.integer :quarter_id
      t.float :target
      t.timestamps
    end
  end
end
