require "spec_helper"

describe Product do
  it "has many items" do
    test_customer = Customer.create({:name=>"Cindy"})
    test_dealing = Dealing.create({:type_deal=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_product1 = Product.create({:name=> 'hat', :price=> 40, :unit=>"ea"})
    test_item1 = Item.create({:quantity=>1, :product_id=>test_product1.id, :dealing_id=>test_dealing.id})
    test_item2 = Item.create({:quantity=>1, :product_id=>test_product1.id, :dealing_id=>test_dealing.id})
    expect(test_product1.items).to eq [test_item1, test_item2]
  end

  it "returns the total number of products sold or returned (by dealing type)" do
    test_customer = Customer.create({:name=>"Cindy"})
    test_dealing = Dealing.create({:type_deal=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_product1 = Product.create({:name=> 'hat', :price=> 40, :unit=>"ea"})
    test_item1 = Item.create({:quantity=>1, :product_id=>test_product1.id, :dealing_id=>test_dealing.id})
    test_item2 = Item.create({:quantity=>1, :product_id=>test_product1.id, :dealing_id=>test_dealing.id})
    expect(test_product1.quantity_product("purchase")).to eq 2
  end
end
