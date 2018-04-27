require('pg')
require_relative("../db/sql_runner")
require_relative("film")
require_relative("ticket")
require_relative("customer")

class Screening
  attr_accessor :film_id, :function_time
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @function_time = options['function_time'].to_i
  end

  def save()
    sql = "INSERT INTO screenings
    (
      film_id,
      function_time
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@film_id, @function_time]
    screening = SqlRunner.run(sql, values).first()
    @id = screening['id'].to_i
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    db = SqlRunner.run(sql, values)
  end

  def film()
    sql = "SELECT films.* FROM films WHERE films.id = $1"
    values = [@id]
    films_hashes = SqlRunner.run(sql, values)
    film = films_hashes.map {|film| Film.new(film)}
    return film
  end

#CLASS METHODS

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    screenings_array = screenings.map { |screening| Screening.new(screening)}
    return screenings_array
  end

  def self.delete_all()
  sql = "DELETE FROM screenings"
  SqlRunner.run(sql)
end

end
