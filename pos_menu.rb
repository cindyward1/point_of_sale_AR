require 'active_record'
require "./lib/cashier.rb"
require "./lib/customer.rb"
require "./lib/item.rb"
require "./lib/product.rb"
require "./lib/transaction.rb"

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  puts "\n"
  puts "*" * 35
  puts "Welcome to the Point of Sale System"
  puts "*" * 35
  puts "\nType 'c' for customer, 'ca' for cashier or 'm' for manager"
  role=gets.chomp
  case role
  when 'c'
    customer_menu
  when 'ca'
    cashier_menu
  when 'm'
    manager_menu
  else
    puts" Please choose a valid option"
  end
end

def customer_menu
  choice = nil
  while choice != 'x' && choice != 'm' do
    puts "To view your receipt, please enter your name."
    name=gets.chomp.downcase
    list_receipts
    puts "Please choose a date to view the receipt details (format 'MM/DD/YYYY')."
    date=gets.chomp
    if date =~ /\d\d\/\d\d\/\d\d\d\d/
      find_receipt
      puts "Type 'x' to exit, 'm' to go to the main menu, or any other character to continue"
      choice = gets.chomp.downcase
      if choice == 'x'
        exit
      elsif choice == 'm'
        main_menu
      end
    else
      puts "Date must be in 'MM/DD/YYYY' format; please try again"
    end
  end
end

def list_receipts
end

def find_receipt
end

def manager_menu
  choice = nil
  while choice != 'x' && choice != 'm' do
    puts "\nType 'c'   to create a cashier"
    puts "Type 'p'   to create a product"
    puts "Type 'fp'  to view favorite products"
    puts "Type 'rp'  to view most returned products"
    puts "Type 'ts'  to view total sales by date range"
    puts "Type 'cc'  to view customer count by cashier by date range"
    choice=gets.chomp.downcase
    case choice
    when'c'
      create_cashier
    when 'p'
      create_product
    when 'fp'
      view_favorite_products
    when 'rp'
      view_most_returned_products
    when 'ts'
      view_total_sales
    when 'cc'
      view_customer_count
    when 'mm'
      main_menu
    when 'x'
      exit
    else
      puts "Please choose a valid option"
    end
  end
end

def create_cashier
  choice = nil
  while choice != "x" && choice != "m"
    puts "\nPlease enter the name of the cashier"
    name = gets.chomp
    puts "Please enter the login name of the cashier"
    login = gets.chomp.downcase
    new_cashier = Cashier.create({:name=>name, :login=>login})
    puts "\nCashier #{new_cashier.name} with login: #{new_cashier.login} was added to the database."
    puts "Would you like to enter another cashier?"
    puts "Type 'x' to exit, 'm' to go to the main menu, or any other character to continue"
    choice = gets.chomp.downcase
    if choice == "x"
      exit
    elsif choice == "m"
      main_menu
    end
  end
end

def create_product
  choice = nil
  while choice != "x" && choice != "m"
    puts "Please enter the name of the product"
    name = nil
    name = gets.chomp.upcase
    if name != nil
      puts "Please enter the price of the product"
      price = gets.chomp.to_f.round(2)
      if price > 0
        puts "Please enter the unit for the price (e.g. ea, lb, kg, yd, in, cm)"
        unit = nil
        unit = gets.chomp.downcase
        if !unit
          unit = "ea"
        end
        new_product = Product.create({:name=>name, :price=>price, :unit=>unit})
        puts "Product #{new_product.name} with price : #{new_product.price}/#{new_product.unit} was saved to the database"
      else
        puts "Price must be greater than zero"
      end
    else
      puts "A product name must be entered"
    end
    puts "Would you like to enter another product?"
    puts "Type 'x' to exit, 'm' to go to the main menu, or any other character to continue"
    choice = gets.chomp.downcase
    if choice == "x"
      exit
    elsif choice == "m"
      main_menu
    end
  end
end

def view_favorite_products
end

def view_most_returned_products
end

def view_total_sales
end

def view_customer_count
end

def cashier_menu
  puts "\nPlease log in to the system"
  status = false
  status = cashier_log_in
  if !status
    puts "\nYou are not in the system as an authorized user"
    puts "Please have your manager set up a login for you"
    exit
  end
  choice = nil
  while choice != "m" && choice != "x"
    puts "\nType 'p'      to create a purchase"
    puts "Type 'r'      to process a return"
    puts "Type 'x'      to exit the program"
    puts "Type 'm'      to return to the main menu"
    choice = gets.chomp
    case choice
    when 'p'
      create_purchase
    when 'r'
      process_return
    when 'x'
      exit
    when 'm'
      main_menu
    else
      puts "Please choose a valid option"
    end
  end
end

def cashier_log_in
  puts "Please enter your login"
  login = gets.chomp.downcase
  new_cashier = nil
  new_cashier = Cashier.find_by(login: login)
  if new_cashier
    @current_cashier = new_cashier
    return true
  else
    return false
  end
end

def create_purchase
  type_trans='purchase'
  puts "Please enter the customer name"
  name = gets.chomp.upcase
  found_customer = nil
  found_customer = Customer.find_by(name: name)
  if !found_customer
    found_customer = Customer.create({:name=>name})
  end
  puts "Please enter the purchase date ('MM/DD/YYYY format')"
  date = gets.chomp
  if date =~ /\d\d\/\d\d\/\d\d\d\d/
    puts "Please enter the first product"
    product = gets.chomp.upcase
    new_product = nil
    new_product = Product.find_by(name: product)
    if new_product
      puts "Product #{new_product.name} costs #{new_product.price} per #{new_product.unit}"
      puts "Please enter the quantity"
      quantity= gets.chomp.to_i
      if quantity > 0
        new_transaction = Transaction.create({:date=>date, :type_trans=>type_trans,
                                :customer_id=>found_customer.id, :cashier_id=>@current_cashier.id})
        new_item = Item.create({:quantity=>quantity, :transaction_id=>new_transaction.id,
                                :product_id=>new_product.id})
        puts "Would you like to add more items?"
        choice = gets.chomp.downcase.slice(0,1)
        if choice == "y"
          add_items(new_transaction.id)
        end
        print_receipt
      else
        puts "Product quantity must be greater than zero"
      end
    else
      puts "Product not found in the database"
    end
  else
    puts "Date must be in 'MM/DD/YYYY' format; please try again"
  end
end

def add_items(transaction_id)
  choice = nil
  while choice != 'x' && choice != 'n'
    puts "Please enter the next product"
    product = gets.chomp.upcase
    new_product = nil
    new_product = Product.find_by(name: product)
    if new_product
      puts "Product #{new_product.name} costs #{new_product.price} per #{new_product.unit}"
      puts "Please enter the quantity"
      quantity= gets.chomp.to_i
      if quantity > 0
        new_item = Item.create({:quantity=>quantity, :transaction_id=>transaction_id,
                                :product_id=>new_product.id})
      else
        puts "Product quantity must be greater than zero"
      end
    else
      puts "Product not found in the database"
    end
    puts "Would you like to add more items?"
    puts "Enter 'n' to stop adding items and complete purchase, 'x' to exit the program"
    choice = gets.chomp.downcase.slice(0,1)
    if choice == "x"
      exit
    end
  end
end

def show_price
end

def show_total
end

def process_return
end

main_menu
