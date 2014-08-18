require "spec_helper"

describe Customer do
  it 'has many transactions' do
    test_customer = Customer.create({:name=>"Cindy"})
    test_transaction1 = Transaction.create({:type_trans=>"purchase", :date=>"08/17/2014",
                                            :customer_id=>test_customer.id})
    test_transaction2 = Transaction.create({:type_trans=>"purchase", :date=>"08/15/2014",
                                            :customer_id=>test_customer.id})
    expect(test_customer.transactions).to eq [test_transaction1, test_transaction2]
  end
end
