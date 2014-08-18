class Transaction < ActiveRecord::Base
  has_many :items
  has_many :products, :through => :items
  belongs_to :customer
  belongs_to :cashier
end
