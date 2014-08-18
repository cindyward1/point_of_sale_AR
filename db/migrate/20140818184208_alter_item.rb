class AlterItem < ActiveRecord::Migration
  def change
    add_column :items, :transaction_id, :integer
    add_column :items, :product_id, :integer
  end
end
