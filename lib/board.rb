require 'spec_helper.rb'

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
  
    (same_letter && consecutive_numbers || same_number && consecutive_letters || ship.coordinates == coordinates) && no_overlap # if this is true, then the ship is placed correctly
  end

  def place(ship, coordinates)
    return unless valid_placement?(ship, coordinates)

    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  def render(show_ships = false) # I have no idea the best way to line it up... it is ever so slightly off
    top_border = "  ┌" + "────" * @width + "┐\n" # added a border for style (;
    bottom_border = "  └" + "────" * @width + "┘\n"
    rendered_board = "    " + (1..@width).to_a.map { |n| " #{n} " }.join + "\n"
    rendered_board += top_border
    @height.times do |row|
      rendered_board += (65 + row).chr + " │"
      @width.times do |col|
        cell = @cells[(65 + row).chr + (col + 1).to_s]
        if cell.fired_upon?
          if cell.empty?
            rendered_board += " \e[34mO\e[0m │" # Blue "O" for miss
          else
            rendered_board += " \e[31mX\e[0m │" # Red "X" for hit
          end
        elsif show_ships && !cell.empty?
          rendered_board += " \e[32mS\e[0m │" # Green "S" for ship
        else
          rendered_board += "   │"
        end
      end
      rendered_board += "\n"
      rendered_board += "  ├" + "───┼" * (@width - 1) + "───┤\n" unless row == @height - 1
    end
    rendered_board += bottom_border
    rendered_board
  end
end