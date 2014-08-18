class AlterTransactions1 < ActiveRecord::Migration
  def change
    add_column :transactions, :customer_id, :integer
    add_column :transactions, :cashier_id, :integer
    add_column :transactions, :item_id, :integer
  end
end
