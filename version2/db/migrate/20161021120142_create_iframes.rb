class CreateIframes < ActiveRecord::Migration[5.0]
  def change
    create_table :iframes do |t|
      t.string :title
      t.string :url
      t.string :department

      t.timestamps
    end
  end
end
