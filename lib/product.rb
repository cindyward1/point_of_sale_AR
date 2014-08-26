class Product < ActiveRecord::Base
  has_many :items
  has_many :dealings, through: :items

  # Failed attempt by Dustin and me to get a raw SQL command to work through Active Record
  #
  def quantity_product(type)
    self.items.includes(:dealing).where("dealings.type_deal", type)
    # quantity_array = Product.find_by_sql("SELECT products.name SUM(quantity) FROM items " +
    #                                       "JOIN products ON (items.product_id = products.id) " +
    #                                       "JOIN dealings ON (items.dealing_id = dealings.id)" +
    #                                       "WHERE dealings.type_deal = '#{type}' " +
    #                                       "AND products.id = #{self.id};")
    # puts "!!!return from quantity_products self.id = #{self.id}"
    # p quantity_array.first.sum
    # p quantity_array
    # quantity_array.first
  end
end
