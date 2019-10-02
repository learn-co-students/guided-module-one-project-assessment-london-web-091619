require "tty-prompt"

class CLI
  
  @@prompt = TTY::Prompt.new

  

    def run
      choice = @@prompt.select("Sign up or Log in to enjoy our fantastic Gelato!", "Log In", "Sign Up")
      if choice == "Sign Up"
        @current_user = sign_up_user
      else
        @current_user = log_in_user
      end

      if @current_user
        main_menu
      else
        puts "Sorry, your username/password did not match. Please try again."
        run
      end
    end

    def sign_up_user
      # 
      
      fullName = @@prompt.ask("Please enter your Full Name: ")
      emailAdd = @@prompt.ask("Please enter your Email Address (This will be your Username): ")
      postalAdd = @@prompt.ask("Please enter your Postal Address: ")
      password1 = @@prompt.mask("Please enter your Password: ")
      password2 = @@prompt.mask("For security purposes, Please Re-enter your Password: ")
      if password1 == password2
        User.create(name: fullName, password: password1, address: postalAdd, email: emailAdd)
      end
    end


    def log_in_user
      # 

      username = @@prompt.ask("Please enter your username: ")
      password = @@prompt.mask("Please enter your password: ")

      User.find_by(address: username, password: password)
    end

    def main_menu
      # 
      puts "Hello there!"
      menu_choice = @@prompt.select("What can we do for you today?", "Create New Order", "Edit Order", "Cancel Order", "My Orders", "About/Promo")
    
      case menu_choice
      when "Create New Order"
        create_order
        puts "Thanks, we're on it!"
        main_menu
      when "Edit Order"
        # edit method
        edit_order
        puts "editing order..."
      when "Cancel Order"
        # delete method
        cancel_order
        puts "Your order has been cancelled"
      when "My Orders" 
        my_orders
        puts "these are your orders!"
      when "About/Promo"
        #post about us
        puts "we are cool"
      else
        puts "you seem to have broken our application, thank you!"
      end
    end

    def create_order
      # 
      servings = @@prompt.ask("How many servings would you like?: ")
      validate_input("from create", servings.to_i)
      total = servings.to_f * 5.0
      remove_stock(servings)
      Order.create(user_id: @current_user.id, gelato_id: current_gelato.id, order_time: order_timestamp , status: "pending", total: total, servings: servings)
      stock_control(servings)
    end

    def remove_stock(servings)
      # 
      my_gelato = current_gelato
      my_gelato.stock -= servings.to_f
      my_gelato.save
    end

    def add_stock(order_stock)
      # 
      my_gelato = current_gelato 
      my_gelato.stock += order_stock.to_f
      my_gelato.save
    end

    def current_gelato
      # 
      Gelato.find(1)
    end

    def cancel_order
      # 
      cancelled_order = @@prompt.select("Which order would you like to cancel?", pending_orders) 
      cancelled_order.status = "cancelled"
      cancelled_order.save
      add_stock(cancelled_order.servings)
    end

    def my_orders
      # 
      puts "Here are your current orders"
      user_orders = Order.all.select {|order| order.user_id == @current_user.id }
      p user_orders
    end

    def pending_orders
      # 
      my_orders.select{|order| order.status == "pending"}
    end

    def edit_order
      order_to_edit = @@prompt.select("Which order would you like to edit?", pending_orders)
      servings = @@prompt.ask("How many servings would you like instead?: ")
      
      # control max and min order amounts
      validate_input("from edit", servings.to_i)

      # add or remove from stock
      add_stock(order_to_edit.servings)
      remove_stock(servings)

      # request more stock
      stock_control(servings)
      

      # update order information
      order_to_edit.servings = servings
      order_to_edit.save
    end

    def order_timestamp
      # 
      Time.now.to_s.split(" ")[0..1].join(" ")
    end

    def stock_control(servings)
      add_stock(100 - current_gelato.stock) if current_gelato.stock <= servings.to_i || current_gelato.stock <= 10
    end

    def validate_input(location, servings)
      if servings > 50
        puts "Due to high demand, we can only complete orders of up to 50 servings at one time. Sorry for the inconvenience."
        find_location(location)
      elsif servings <= 0
        answer = @@prompt.select("This will delete your order. Are you sure you wish to proceed?", "Yes", "No")
        if answer == "Yes"
          cancel_order
        else
          find_location(location)
        end
      end
    end

    def find_location(location)
      location == "from create" ? create_order : edit_order
    end


    





  
end

# ADMIN USER
# exit option at any point
# grey out/dont display options that arent yet available
# hash passwords
# discont service
# many flavours
# pending time period (2 mins)
# VALIDATION (mvp)