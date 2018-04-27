require('pg')
require_relative("../db/sql_runner")
require_relative("film")
require_relative("ticket")

class Customer
  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers
    (
      name,
      funds
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first()
    @id = customer['id'].to_i
  end


  def update()
  sql = "
  UPDATE customers SET (
    name,
    funds
    ) =
    (
      $1, $2
    )
    WHERE id = $3"
    values = [@name, @funds, @id]
    db = SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    db = SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films INNER JOIN tickets ON tickets.film_id = films.id WHERE tickets.customer_id = $1"
    values = [@id]
    films_hashes = SqlRunner.run(sql, values)
    film = films_hashes.map {|film| Film.new(film)}
    return film
  end


  #CLASS METHODS

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    customers_array = customers.map { |customer| Customer.new(customer)}
    return customers_array
  end

  def self.delete_all()
  sql = "DELETE FROM customers"
  SqlRunner.run(sql)
end

end
