class Dealing < ActiveRecord::Base
  belongs_to :customer
  belongs_to :cashier
  has_many :items
  has_many :products, through: :items
end
