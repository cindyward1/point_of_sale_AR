class AlterProductAddUnit < ActiveRecord::Migration
  def change
    add_column :products, :unit, :integer
  end
end
