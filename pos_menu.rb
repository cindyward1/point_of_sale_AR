require 'active_record'
require "./lib/cashier.rb"
require "./lib/customer.rb"
require "./lib/item.rb"
require "./lib/product.rb"
require "./lib/dealing.rb"

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  puts "\n"
  puts "*" * 35
  puts "Welcome to the C & P Store's Point of Sale System"
  puts "*" * 35
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

def customer_menu
  choice = nil
  while choice != 'x' && choice != 'm' do
    puts "\nVIEW RECEIPT"
    puts "To view a receipt, please enter your name."
    name=gets.chomp.downcase
    receipt_array = list_dealings
    if !receipt_array.empty?
      puts "\nPlease select the index of the receipt"
      puts "Enter 'm' to go to the main menu or 'x' to exit the program"
      receipt_index_str = gets.chomp
      if receipt_index_str != 'x' && receipt_index_str != 'm'
        receipt_index = receipt_index_str.to_i
        the_receipt = receipt_array[index-1]
        show_receipt(the_receipt)
      end
    end
  end
end

def list_receipts
end

def show
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
  unit_array - ["ea","lb","oz","yd","in","q","ts","kg","g","m","cm","l","ml"]
  while choice != "x" && choice != "m"
    puts "\nEnter the name of the product"
    name = nil
    name = gets.chomp.upcase
    if name != nil
      puts "Enter the price of the product"
      price = gets.chomp.to_f.round(2)
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
          puts "Product #{new_product.name} with price : #{new_product.price}/#{new_product.unit} was saved to the database"
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
      exit program
    when 'm'
    else
      puts "Please choose a valid option"
    end
  end
end

def cashier_log_in
  puts "Please log in to the system by entering your cashier ID"
  login = gets.chomp.downcase
  cashier_array = Cashier.find_by(login: login)
  if !cashier_array.empty?
    @current_cashier = login
    return true
  else
    return false
  end
end

def create_purchase
  type_deal='purchase'
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
        new_dealing = Dealing.create({:date=>date, :type_deal=>type_deal,
                                :customer_id=>found_customer.id, :cashier_id=>@current_cashier.id})
        new_item = Item.create({:quantity=>quantity, :dealing_id=>new_dealing.id,
                                :product_id=>new_product.id})
        puts "Enter 'y' or 'yes' to continue adding items"
        puts "Enter 'm' to go to the main menu,'x' to exit the program"
        puts "Enter any other character to complete the transaction and print the receipt"
        choice = gets.chomp.downcase.slice(0,1)
        case choice
        when 'y'
          add_items(new_dealing.id,"y")
          show_receipt(new_dealing.id)
        when 'm'
          main_menu
        when 'x'
          exit_program
        else
          show_receipt(new_dealing.id)
        end
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

def show_price
end

def show_total
end

def process_return
end

def exit_program
  puts "\n\nThanks for using the C & P Store's Point of Sale program!"
  puts "Please visit again soon!\n\n"
  exit
end

main_menu
