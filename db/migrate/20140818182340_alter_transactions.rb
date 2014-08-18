class AlterTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :type
    add_column :transactions, :type_trans, :string
  end
end
