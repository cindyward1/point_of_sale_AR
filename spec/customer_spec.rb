require "spec_helper"

describe Customer do
  it 'has many dealings' do
    test_customer = Customer.create({:name=>"Cindy"})
    test_dealing1 = Dealing.create({:type_deal=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_dealing2 = Dealing.create({:type_deal=>"purchase", :date=>"08/15/2014",
                                            :customer_id=>test_customer.id})
    expect(test_customer.dealings).to eq [test_dealing1, test_dealing2]
  end
end
