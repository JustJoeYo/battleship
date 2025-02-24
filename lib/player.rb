require './lib/board'
require './lib/ship'
require './lib/color'

class Player
  def initialize(height = 4, width = 4)
    @board = Board.new(height, width)
    @ships = []
    @color = Color.new
  end

  def board
    @board
  end

  def ships
    @ships
  end

  def add_ship(name, length, coordinates = [])
    @ships << Ship.new(name, length, coordinates)
  end

  def place_ships
    puts @color.colorize("I have laid out my ships on the grid.", :blue)
    puts @color.colorize("You now need to lay out your ships.", :blue)
    puts @board.render

    @ships.each do |ship|
      place_ship(ship)
    end
  end

  def place_ship(ship)
    valid_placement = false
    until valid_placement
      puts @color.colorize("Enter the squares for the #{ship.name} (#{ship.length} spaces):", :blue)
      coordinates = gets.chomp.upcase.split
      if @board.valid_placement?(ship, coordinates)
        @board.place(ship, coordinates)
        valid_placement = true
        puts @board.render(true)
      else
        puts @color.colorize("Those are invalid coordinates. Please try again:", :red)
      end
    end
  end

  def take_shot(opponent_board)
    valid_shot = false
    until valid_shot
      puts @color.colorize("Enter the coordinate for your shot:", :blue)
      coordinate = gets.chomp.upcase
      if opponent_board.valid_coordinate?(coordinate) && !opponent_board.cells[coordinate].fired_upon?
        opponent_board.cells[coordinate].fire_upon
        valid_shot = true
        puts "Your shot on #{@color.colorize(coordinate, :yellow)} was a #{shot_result(opponent_board, coordinate)}."
      else
        puts @color.colorize("Please enter a valid coordinate:", :red)
      end
    end
  end

  def shot_result(board, coordinate)
    cell = board.cells[coordinate]
    if cell.empty?
      @color.colorize("miss", :red)
    elsif cell.ship.sunk?
      @color.colorize("hit and sunk the ship", :red)
    else
      @color.colorize("hit", :green)
    end
  end
end