require './lib/board'
require './lib/ship'

class Player
  def initialize
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def board
    @board
  end

  def cruiser
    @cruiser
  end

  def submarine
    @submarine
  end

  def place_ships
    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts @board.render

    place_ship(@cruiser)
    place_ship(@submarine)
  end

  def place_ship(ship)
    valid_placement = false
    until valid_placement
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      coordinates = gets.chomp.upcase.split
      if @board.valid_placement?(ship, coordinates)
        @board.place(ship, coordinates)
        valid_placement = true
        puts @board.render(true)
      else
        puts "Those are invalid coordinates. Please try again:"
      end
    end
  end

  def take_shot(opponent_board)
    valid_shot = false
    until valid_shot
      puts "Enter the coordinate for your shot:"
      coordinate = gets.chomp.upcase
      if opponent_board.valid_coordinate?(coordinate) && !opponent_board.cells[coordinate].fired_upon?
        opponent_board.cells[coordinate].fire_upon
        valid_shot = true
        puts "Your shot on \e[33m#{coordinate}\e[0m was a #{shot_result(opponent_board, coordinate)}."
      else
        puts "Please enter a valid coordinate:"
      end
    end
  end

  def shot_result(board, coordinate)
    cell = board.cells[coordinate]
    if cell.empty?
      "\e[31mmiss\e[0m"
    elsif cell.ship.sunk?
      "\e[31mhit and sunk the ship\e[0m"
    else
      "\e[32mhit\e[0m"
    end
  end
end