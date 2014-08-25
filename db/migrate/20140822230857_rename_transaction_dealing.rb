class RenameTransactionDealing < ActiveRecord::Migration
  def change
    drop_table :transactions
    create_table :dealings do |t|
      t.date "date"
      t.string "type_deal"
      t.integer "customer_id"
      t.integer "cashier_id"
      t.timestamps
    end
  end
end
