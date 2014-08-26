require "spec_helper"

describe Cashier do

  it 'has many transactions' do
    test_cashier = Cashier.create({:name=>"Cindy"})
    test_dealing1 = Dealing.create({:type_deal=>"purchase", :date=>"08/17/2014",
                                            :cashier_id=>test_cashier.id})
    test_dealing2 = Dealing.create({:type_deal=>"purchase", :date=>"08/15/2014",
                                            :cashier_id=>test_cashier.id})
    expect(test_cashier.dealings).to eq [test_dealing1, test_dealing2]
  end

end
