require_relative( '../models/customer' )
require_relative( '../models/film' )
require_relative( '../models/ticket' )
require_relative( '../models/screening' )

require( 'pry' )

customer1 = Customer.new({ 'name' => 'Luis', 'funds' => '100'})
customer1.save()
customer2 = Customer.new({ 'name' => 'Peter Parker', 'funds' => '10'})
customer2.save()
customer3 = Customer.new({ 'name' => 'Davina', 'funds' => '1000'})
customer3.save()
film1 = Film.new({ 'title' => 'Infinity War', 'price' => '15'})
film1.save()

film2 = Film.new({ 'title' => 'Drive', 'price' => '15'})
film2.save()

screening1 = Screening.new ({ 'film_id' => film1.id, 'function_time' => '10' })
screening1.save()

screening2 = Screening.new ({ 'film_id' => film1.id, 'function_time' => '5' })
screening2.save()

ticket1 = Ticket.new ({ 'customer_id' => customer1.id, 'screening_id' => screening1.id })
ticket1.save()
ticket2 = Ticket.new ({ 'customer_id' => customer2.id, 'screening_id' => screening1.id })
ticket2.save()
ticket3 = Ticket.new ({ 'customer_id' => customer1.id, 'screening_id' => screening2.id })
ticket3.save()



binding.pry
nil
