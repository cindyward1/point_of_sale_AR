class AlterTransactionDropItemid < ActiveRecord::Migration
  def change
    remove_column :transactions, :item_id
  end
end
