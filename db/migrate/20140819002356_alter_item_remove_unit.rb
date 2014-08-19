class AlterItemRemoveUnit < ActiveRecord::Migration
  def change
    remove_column :items, :unit
  end
end
