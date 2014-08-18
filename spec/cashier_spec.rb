require "spec_helper"

describe Cashier do

  it 'has many transactions' do
    test_cashier = Cashier.create({:name=>"Cindy"})
    test_transaction1 = Transaction.create({:type_trans=>"purchase", :date=>"08/17/2014",
                                            :cashier_id=>test_cashier.id})
    test_transaction2 = Transaction.create({:type_trans=>"purchase", :date=>"08/15/2014",
                                            :cashier_id=>test_cashier.id})
    expect(test_cashier.transactions).to eq [test_transaction1, test_transaction2]
  end

end
