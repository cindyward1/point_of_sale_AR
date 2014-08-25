class Addtotaltodealing < ActiveRecord::Migration
  def change
    add_column :dealings, :total, :decimal
  end
end
