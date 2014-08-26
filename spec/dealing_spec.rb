require "spec_helper"

describe Dealing do
  it "has many items" do
    test_customer = Customer.create({:name=>"Cindy"})
    test_dealing = Dealing.create({:type_deal=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_item1 = Item.create({:quantity=>1, :product_id=>1, :dealing_id=>test_dealing.id})
    test_item2 = Item.create({:quantity=>2, :product_id=>2, :dealing_id=>test_dealing.id})
    expect(test_dealing.items).to eq [test_item1, test_item2]
  end

  it"has many products through items" do
    test_customer = Customer.create({:name=>"Cindy"})
    test_dealing = Dealing.create({:type_deal=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_product1 = Product.create({:name=> 'hat', :price=> 40, :unit=>"ea"})
    test_product2 = Product.create({:name=> 'shoes', :price=> 75, :unit=>"ea"})
    test_item1 = Item.create({:quantity=>1, :product_id=>test_product1.id, :dealing_id=>test_dealing.id})
    test_item2 = Item.create({:quantity=>1, :product_id=>test_product2.id, :dealing_id=>test_dealing.id})
    expect(test_dealing.products("purchase")).to eq [test_product1, test_product2]
  end

end
