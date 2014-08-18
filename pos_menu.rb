def main_menu
  puts "Welcome to the Point of Sale System"
  puts "Type 'c' for customer, 'ca' for cashier or 'm' for manager"
  role=gets.chomp
  case 'c'
    customer_menu
  case 'ca'
    cashier_menu
  case 'm'
    manager_menu
  else
    puts" Please choose a valid option"
  end
end

def customer_menu
  puts "To view your receipt, please enter your name."
  name=gets.chomp
  list_receipts
  puts "Please choose a date to view the receipt details."
  date=gets.chomp
  find_receipt
end

def manager_menu

end

def cashier_menu

end

def list_receipts
end

