class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :user_id

      t.integer :arr
      t.date :date

      t.timestamps
    end
  end
end
