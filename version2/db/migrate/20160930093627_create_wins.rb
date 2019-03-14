class CreateWins < ActiveRecord::Migration[5.0]
  def change
    create_table :wins do |t|
      t.string :company
      t.string :agents
      t.string :mrr
      t.string :reps

      t.timestamps
    end
  end
end
