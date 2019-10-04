# FOODEE
## Usage
To install FOODEE, clone this repository with `git clone SOMETHING`, `cd` into it with `cd FOLDERNAME` and run `bundle` to install dependencies.

To seed the database, run `rake db:seed`. If you run into any errors here, you might need to try `bundle exec rake db:seed`.

FOODEE can then be run with `ruby bin/run.rb`.

## Features
### Customer
- Register an account in the database
- Search for restaurants, and get directions
- Review a restaurant from the database
- Delete and update your existing reviews

### Restaurant
- Log in as a restaurant from the database
- Read customer reviews of your restaurant
- Leave reviews for your customers

## Screenshots
![screenshot of initial greeting menu: "Are you a customer or a restaurant?"](screenshots/customer-or-restaurant.png)
![screenshot of customer registration and main menu: "Hi Joe, how can we help you today? Search for a restaurant; Review a restaurant; Exit"](screenshots/customer.png)
![screenshot of restaurant login and main menu: "Hi IZG Spoon, how can we help you today? Read reviews; Exit"](screenshots/restaurant.png)