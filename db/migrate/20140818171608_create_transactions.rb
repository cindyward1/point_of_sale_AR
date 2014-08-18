class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.column :type, :string
      t.column :date, :date
      t.timestamps
    end
  end
end
