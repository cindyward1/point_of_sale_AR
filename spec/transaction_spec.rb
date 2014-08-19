require "spec_helper"

describe Transaction do
  it "has many items" do
    test_customer = Customer.create({:name=>"Cindy"})
    test_transaction = Transaction.create({:type_trans=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_item1 = Item.create({:quantity=>1, :product_id=>1, :transaction_id=>test_transaction.id})
    test_item2 = Item.create({:quantity=>2, :product_id=>2, :transaction_id=>test_transaction.id})
    expect(test_transaction.items).to eq [test_item1, test_item2]
  end

  it"has many products through items" do
    test_customer = Customer.create({:name=>"Cindy"})
    test_transaction = Transaction.create({:type_trans=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_product1 = Product.create({:name=> 'hat', :price=> 40, :unit=>"ea"})
    test_product2 = Product.create({:name=> 'shoes', :price=> 75, :unit=>"ea"})
    test_item1 = Item.create({:quantity=>1, :product_id=>test_product1.id, :transaction_id=>test_transaction.id})
    test_item2 = Item.create({:quantity=>1, :product_id=>test_product2.id, :transaction_id=>test_transaction.id})
    expect(test_transaction.products).to eq [test_product1, test_product2]
  end

end
