class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.column :quantity, :integer
      t.column :unit, :string
      t.timestamps
    end
  end
end
