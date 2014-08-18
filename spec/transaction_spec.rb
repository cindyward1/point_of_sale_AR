require "spec_helper"

describe Transaction do
  it "has many items" do
    test_customer = Customer.create({:name=>"Cindy"})
    test_transaction = Transaction.create({:type_trans=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_item1 = Item.create({:quantity=>1, :product_id=>1, :unit=>"lb", :transaction_id=>test_transaction.id})
    test_item2 = Item.create({:quantity=>2, :product_id=>2, :unit=>"ea", :transaction_id=>test_transaction.id})
    expect(test_transaction.items).to eq [test_item1, test_item2]
  end
end
