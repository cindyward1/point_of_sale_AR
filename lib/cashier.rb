class Cashier < ActiveRecord::Base
  has_many :transactions
end
