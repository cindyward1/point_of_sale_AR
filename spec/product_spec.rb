require "spec_helper"

describe Product do
  it "has many items" do
    test_customer = Customer.create({:name=>"Cindy"})
    test_transaction = Transaction.create({:type_trans=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_product1 = Product.create({:name=> 'hat', :price=> 40, :unit=>"ea"})
    test_item1 = Item.create({:quantity=>1, :product_id=>test_product1.id, :transaction_id=>test_transaction.id})
    test_item2 = Item.create({:quantity=>1, :product_id=>test_product1.id, :transaction_id=>test_transaction.id})
    expect(test_product1.items).to eq [test_item1, test_item2]
  end
end
