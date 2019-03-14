class CreateQuarters < ActiveRecord::Migration
  def change
    create_table :quarters do |t|
      t.date :begin_date
      t.date :end_date
      t.boolean :current, :default => false
      t.float :target
      t.timestamps
    end
  end
end
