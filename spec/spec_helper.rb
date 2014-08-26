require 'active_record'
require 'rspec'

require 'cashier'
require 'product'
require 'customer'
require 'dealing'
require 'item'

database_configurations = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Cashier.all.each { |cashier| cashier.destroy }
  end
  config.after(:each) do
    Product.all.each { |product| product.destroy }
  end
  config.after(:each) do
    Customer.all.each { |customer| customer.destroy }
  end
  config.after(:each) do
    Dealing.all.each { |transaction| transaction.destroy }
  end
  config.after(:each) do
    Item.all.each { |item| item.destroy }
  end
end

