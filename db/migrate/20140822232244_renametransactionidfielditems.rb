class Renametransactionidfielditems < ActiveRecord::Migration
  def change
    remove_column :items, :transaction_id
    add_column :items, :dealing_id, :integer
  end
end
