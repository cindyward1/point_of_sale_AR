require 'active_record'
require "./lib/cashier.rb"
require "./lib/customer.rb"
require "./lib/item.rb"
require "./lib/product.rb"
require "./lib/dealing.rb"

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "\n"
  puts "*" * 35
  puts "Welcome to the C & P Store's Point of Sale System"
  puts "*" * 35
  puts "\n"
  main_menu
end

def main_menu
  role = nil
  while role != 'x'
    puts "\nMAIN MENU"
    puts "[ g ] = Manager menu"
    puts "[ s ] = Cashier menu"
    puts "[ c ] = Customer menu"
    puts "[ m ] = Main menu (this menu)"
    puts "[ x ] = Exit program"
    role=gets.chomp.downcase
    case role
    when 'c'
      customer_menu
    when 's'
      cashier_menu
    when 'g'
      manager_menu
    when 'm'
    when 'x'
      exit_program
    else
      puts"\nPlease choose a valid option"
    end
  end
end

def customer_menu
  choice = nil
  while choice != 'x' && choice != 'm' do
    puts "\nVIEW RECEIPT"
    puts "To view a receipt, please enter your name"
    puts "Enter 'm' to go to the main menu or 'x' to exit the program"
    customer_name = gets.chomp.upcase
    if customer_name != "X" && customer_name != "M"
      receipt_array = list_dealings_for_customer(customer_name)
      if !receipt_array.empty?
        puts "\nPlease select the index of the receipt"
        puts "Enter 'm' to go to the main menu or 'x' to exit the program"
        receipt_index_str = gets.chomp.downcase
        if receipt_index_str != 'x' && receipt_index_str != 'm'
          receipt_index = receipt_index_str.to_i
          if receipt_index > 0 && receipt_index <= receipt_array.length
            the_receipt = receipt_array[receipt_index-1]
            puts "\n#{customer_name}, the receipt from your #{the_receipt.type_deal} on #{the_receipt.date}\n"
            total = show_items(the_receipt)
            puts "\n The total of the #{the_receipt.type_deal} was $#{total}\n"
          else
            puts "\nInvalid index #{receipt_index} (#{receipt_index_str}, #{receipt_array.length}), try again"
          end
        elsif receipt_index_str == 'x'
          exit_program
        elsif receipt_index_str == 'm'
        else
          puts "Internal error receipt_index_str == #{receipt_index_str}"
          exit_program
        end
      else
        puts "\nSorry, #{customer_name}, you have no receipts in the system"
        choice = 'm'
      end
    elsif customer_name == 'X'
      exit_program
    elsif customer_name == "M"
    else
      puts "Intenal error customer_name == #{customer_name}"
    end
  end
end

def list_dealings_for_customer(customer_name)
  the_customer = find_customer(customer_name)
  receipt_array = the_customer.dealings.order('date DESC')
  receipt_array.each_with_index do |receipt, index|
    puts "#{index+1}. #{receipt.date} $#{receipt.total}\n"
  end
  receipt_array
end

def find_customer(customer_name)
  found_customer = nil
  found_customer = Customer.find_by(name: customer_name)
  if found_customer == nil
    found_customer = Customer.create({:name=>customer_name})
  end
  found_customer
end

def show_items(the_receipt)
  total = 0
  the_receipt.items.each_with_index do |item, index|
    line_total = item.quantity * item.product.price
    total += line_total
    puts "#{index+1}. #{item.quantity} #{item.product.unit} of #{item.product.name} @ $#{item.product.price.round(2)} " +
         "= $#{line_total}\n"
  end
  total
end

def manager_menu
  choice = nil
  while choice != 'x' && choice != 'm' do
    puts "\nMANAGER MENU"
    puts "[ c ] = Create a cashier"
    puts "[ p ] = Create a product"
    puts "[ f ] = View favorite products"
    puts "[ r ] = View most returned products"
    puts "[ s ] = View sales for a date range"
    puts "[ n ] = View customer count by cashier for a date range\n"
    puts "[ b ] = (back to) Manager menu"
    puts "[ m ] = Main menu"
    puts "[ x ] = Exit program"
    choice = gets.chomp.downcase
    case choice
    when 'c'
      create_cashier
    when 'p'
      create_product
    when 'f'
      view_favorite_products
    when 'r'
      view_most_returned_products
    when 's'
      view_total_sales
    when 'n'
      view_customer_count
    when 'm'
      main_menu
    when 'b'
    when 'x'
      exit_program
    else
      puts "Please choose a valid option"
    end
  end
end

def create_cashier
  choice = nil
  while choice != "x" && choice != "m" && choice != 'b'
    puts "\nPlease enter the name of the cashier"
    name = gets.chomp
    puts "\nPlease enter the login name of the cashier"
    login = gets.chomp.downcase
    new_cashier = Cashier.create({:name=>name, :login=>login})
    puts "\nCashier #{new_cashier.name} with login: #{new_cashier.login} was added to the database."
    puts "\nEnter 'm' to go to the main menu,'x' to exit the program"
    puts "Enter any other character to continue adding cashiers"
    choice = gets.chomp.downcase
    case choice
    when 'x'
      exit_program
    when 'm'
      main_menu
    when 'b'
    else
      puts "\nInvalid option, try again"
    end
  end
end

def create_product
  choice = nil
  unit_array = ["ea","lb","oz","yd","in","q","ts","kg","g","m","cm","l","ml"]
  while choice != "x" && choice != "m"
    puts "\nEnter the name of the product"
    name = nil
    name = gets.chomp.upcase
    if name != nil
      puts "Enter the price of the product in dollars"
      price_char = gets.chomp
      price_char.slice!(/\D/)
      price = price_char.to_f.round(2)
      if price > 0
        puts "Select the unit by which the product will be sold"
        puts "[ ea ] = each (default)"
        puts "British units"
        puts "[ lb ] = pound"
        puts "[ oz ] = ounce"
        puts "[ yd ] = yard"
        puts "[ in ] = inch"
        puts "[ q  ] = quart"
        puts "[ ts ] = teaspoon"
        puts "Metric units"
        puts "[ kg ] = kilogram"
        puts "[ g  ] = gram"
        puts "[ me ] = meter"
        puts "[ cm ] = centimeter"
        puts "[ l  ] = liter"
        puts "[ ml ] = milliliter"
        puts "Menu options"
        puts "[ m ] = Main menu"
        puts "[ x ] = Exit program"
        unit = gets.chomp.downcase
        if unit_array.include?(unit)
          new_product = Product.create({:name=>name, :price=>price, :unit=>unit})
          puts "Product #{new_product.name} with price : #{new_product.price} per #{new_product.unit} was saved to the database"
        else
          puts "Unit entered not found, try again"
        end
      else
        puts "Price must be greater than zero"
      end
    else
      puts "A product name must be entered"
    end
    puts "Would you like to enter another product?"
    puts "Enter 'x' to exit, 'm' to go to the main menu, or any other character to continue"
    choice = gets.chomp.downcase
    if choice == "x"
      exit_program
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
  puts "\nCASHIER LOGIN"
  status = false
  status = cashier_log_in
  if !status
    puts "\nYou are not in the system as an authorized cashier"
    puts "Please contact your manager"
    exit
  end
  choice = nil
  while choice != "m" && choice != "x"
    puts "\nCASHIER MENU"
    puts "[ p ] = Create a purchase"
    puts "[ r ] = Process a return"
    puts "[ m ] = Main menu"
    puts "[ x ] = Exit program"
    choice = gets.chomp
    case choice
    when 'p'
      create_purchase
    when 'r'
      process_return
    when 'x'
      exit_program
    when 'm'
    else
      puts "Please choose a valid option"
    end
  end
end

def cashier_log_in
  puts "Please log in to the system by entering your cashier ID"
  login = gets.chomp.downcase
  cashier = Cashier.find_by(login: login)
  if cashier != nil
    @current_cashier = cashier
    return true
  else
    return false
  end
end

def create_purchase
  type_deal='purchase'
  puts "\nPlease enter the customer name"
  name = gets.chomp.upcase
  the_customer = find_customer(name)
  puts "Please enter the purchase date ('YYYY-MM-DD' format)"
  date = gets.chomp
  if date =~ /\d\d\d\d-\d\d-\d\d/
    puts "Please enter the first product"
    product = gets.chomp.upcase
    new_product = nil
    new_product = Product.find_by(name: product)
    if new_product
      puts "Product #{new_product.name} costs #{new_product.price} per #{new_product.unit}"
      puts "Please enter the quantity"
      quantity= gets.chomp.to_i
      if quantity > 0
        new_dealing = Dealing.create({:date=>date, :type_deal=>type_deal, :total=>0,
                                :customer_id=>the_customer.id, :cashier_id=>@current_cashier.id})
        new_item = Item.create({:quantity=>quantity, :dealing_id=>new_dealing.id,
                                :product_id=>new_product.id})
        puts "Enter 'y' or 'yes' to continue adding items"
        puts "Enter 'm' to go to the main menu,'x' to exit the program"
        puts "Enter any other character to complete the transaction and print the receipt"
        choice = gets.chomp.downcase.slice(0,1)
        case choice
        when 'y'
          add_items(new_dealing.id,"y")
          the_total = show_receipt(new_dealing, the_customer)
          new_dealing.update(:total=>the_total)
        when 'm'
          main_menu
        when 'x'
          exit_program
        else
          the_total = show_receipt(new_dealing, the_customer)
          new_dealing.update(:total=>the_total)
        end
      else
        puts "Product quantity must be greater than zero"
      end
    else
      puts "Product not found in the database"
    end
  else
    puts "Date must be in 'YYYY-MM-DD' format; please try again"
  end
end

def add_items(dealing_id, choice)
  while choice == "y"
    puts "Please enter the next product"
    product = gets.chomp.upcase
    new_product = nil
    new_product = Product.find_by(name: product)
    if new_product
      puts "Product #{new_product.name} costs #{new_product.price} per #{new_product.unit}"
      puts "Please enter the quantity"
      quantity= gets.chomp.to_i
      if quantity > 0
        new_item = Item.create({:quantity=>quantity, :dealing_id=>dealing_id,
                                :product_id=>new_product.id})
      else
        puts "Product quantity must be greater than zero"
      end
    else
      puts "Product not found in the database"
    end
    puts "Enter 'y' or 'yes' to continue adding items"
    puts "Enter 'm' to go to the main menu,'x' to exit the program"
    puts "Enter any other character to complete the transaction and print the receipt"
    choice = gets.chomp.downcase.slice(0,1)
    case choice
    when 'm'
      main_menu
    when 'x'
      exit_program
    end
  end
end

def show_receipt(the_receipt, the_customer)
  puts "\nThe receipt for #{the_customer.name}'S #{the_receipt.type_deal} on #{the_receipt.date}\n"
  total = show_items(the_receipt)
  puts "\nTotal of #{the_receipt.type_deal} was $#{receipt.total}\n"
  total
end

def process_return
end

def exit_program
  puts "\n\nThanks for using the C & P Store's Point of Sale program!"
  puts "Please visit again soon!\n\n"
  exit
end

main_menu
