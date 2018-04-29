require('pg')
require_relative("../db/sql_runner")
require_relative("film")
require_relative("customer")
require_relative("screening")

class Ticket
  attr_accessor :customer_id, :screening_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets
    (
      customer_id,
      screening_id
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@customer_id, @screening_id]
    location = SqlRunner.run(sql, values).first()
    @id = location['id'].to_i
  end

    def update()
    sql = "
    UPDATE tickets SET (
      customer_id,
      screening_id
      ) =
      (
        $1, $2
      )
      WHERE id = $3"
      values = [@customer_id, @screening_id, @id]
      db = SqlRunner.run(sql, values)
    end

    def delete()
      sql = "DELETE FROM tickets WHERE id = $1"
      values = [@id]
      db = SqlRunner.run(sql, values)
    end

    #CLASS METHODS

    def self.all()
      sql = "SELECT * FROM tickets"
      tickets = SqlRunner.run(sql)
      tickets_array = tickets.map { |ticket| Ticket.new(ticket)}
      return tickets_array
    end

    def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

def self.film_by_id(id)
  sql = "SELECT films.* FROM films WHERE films.id = $1"
  values = [id]
  films_hashes = SqlRunner.run(sql, values)
  film = films_hashes.map {|film| Film.new(film)}
  return film
end

def self.screening_by_id(id)
  sql = "SELECT screenings.* FROM screenings WHERE screenings.id = $1"
  values = [id]
  films_hashes = SqlRunner.run(sql, values)
  film = films_hashes.map {|film| Screening.new(film)}
  return film
end

def self.most_sold()
sql = "SELECT screening_id FROM tickets GROUP BY screening_id ORDER BY COUNT(*) DESC LIMIT 1"
tickets = SqlRunner.run(sql)[0]['screening_id'].to_i
return self.film_by_id(tickets)[0].title + " is the most popular film at: " + self.screening_by_id(tickets)[0].function_time.to_s
end

# Ruby method to get most sold ticket

def self.get_id()
  array_of_tickets= self.all()
  ids_array = []
  for id in array_of_tickets
    ids_array.push(id.screening_id)
  end
  return ids_array.uniq.max_by{ |i| ids_array.count( i ) }
end

def self.most_sold_ruby()
  popular = self.get_id()
  return self.film_by_id(popular)[0].title + " is the most popular film at: " + self.screening_by_id(popular)[0].function_time.to_s
end


end
