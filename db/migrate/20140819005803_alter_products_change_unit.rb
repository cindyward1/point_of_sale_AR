class AlterProductsChangeUnit < ActiveRecord::Migration
  def change
    remove_column :products, :unit
    add_column :products, :unit, :string
  end
end
