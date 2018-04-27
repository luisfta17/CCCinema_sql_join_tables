require('pg')
require_relative("../db/sql_runner")
require_relative("customer")
require_relative("ticket")

class Film
  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films
    (
      title,
      price
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first()
    @id = film['id'].to_i
  end


    def update()
    sql = "
    UPDATE films SET (
      title,
      price
      ) =
      (
        $1, $2
      )
      WHERE id = $3"
      values = [@title, @price, @id]
      db = SqlRunner.run(sql, values)
    end

    def delete()
      sql = "DELETE FROM films WHERE id = $1"
      values = [@id]
      db = SqlRunner.run(sql, values)
    end


    #CLASS METHODS

    def self.all()
      sql = "SELECT * FROM films"
      films = SqlRunner.run(sql)
      films_array = films.map { |film| Film.new(film)}
      return films_array
    end

    def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
