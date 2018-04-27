require_relative( '../models/customer' )
require_relative( '../models/film' )
require_relative( '../models/ticket' )

require( 'pry' )

customer1 = Customer.new({ 'name' => 'Luis', 'funds' => '100'})
customer1.save()
customer2 = Customer.new({ 'name' => 'Peter Parker', 'funds' => '10'})
customer2.save()
film1 = Film.new({ 'title' => 'Infinity War', 'price' => '15'})
film1.save()

ticket1 = Ticket.new ({ 'customer_id' => customer1.id, 'film_id' => film1.id })
ticket1.save()

binding.pry
nil
