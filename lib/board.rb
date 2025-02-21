require './lib/cell'
require './lib/ship'

class Board
  def initialize(height = 4, width = 4)
    @height = height
    @width = width
    @cells = {}
    ("A"..(65 + height - 1).chr).each do |letter|
      (1..width).each do |number|
        coordinate = "#{letter}#{number}"
        @cells[coordinate] = Cell.new(coordinate)
      end
    end
  end

  def cells
    @cells
  end

  def valid_coordinate?(coordinate)
    @cells.key?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    # if coordinates matches the length of the ship, then we can check if the coordinates are valid
    return false unless coordinates.length == ship.length # still not sure if im allowed to use return unless yet.
  
    # this just gets the letters/numbers from the coords.
    letters = coordinates.map { |coord| coord[0] } # no usage of proc syntax anywhere hehehe
    numbers = coordinates.map { |coord| coord[1..-1].to_i }
    # id love some feedback to possibly shorten this code
  
    # just checks if numbers/letters are the same
    same_letter = letters.uniq.length == 1 # i know, fantanstic naming schemes all around.
    same_number = numbers.uniq.length == 1
  
    consecutive_numbers = numbers.each_cons(2).all? { |a, b| b == a + 1 }
    consecutive_letters = letters.each_cons(2).all? { |a, b| b.ord == a.ord + 1 }

    no_overlap = coordinates.all? { |coord| @cells[coord].empty? } # users could stack their ships without this
  
    (same_letter && consecutive_numbers || same_number && consecutive_letters) && no_overlap # if this is true, then the ship is placed correctly
  end

  def place(ship, coordinates)
    return unless valid_placement?(ship, coordinates)

    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  def render(show_ships = false)
    board_string = "  " + (1..@width).to_a.join(" ") + " \n"
    ("A"..(65 + @height - 1).chr).each do |letter|
      row = "#{letter} "
      (1..@width).each do |number|
        coordinate = "#{letter}#{number}"
        row += @cells[coordinate].render(show_ships) + " "
      end
      board_string += row.strip + " \n"
    end
    board_string
  end
end