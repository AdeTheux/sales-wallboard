class AddCompanyToSale < ActiveRecord::Migration
  def change
    add_column :sales, :company, :string, :default => ""
  end
end
